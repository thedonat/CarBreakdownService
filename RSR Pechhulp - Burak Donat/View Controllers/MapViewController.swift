//
//  MapViewController.swift
//  RSR Pechhulp - Burak Donat
//
//  Created by Burak Donat on 15.03.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    //
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    //
    let customCalloutView = CalloutViewMenager()
    var annotationView: MKAnnotationView?
    var locationMenager = CLLocationManager()
    let mapMarker = MKPointAnnotation()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        checkConnectivity()
        locationMenager.delegate = self
        locationMenager.desiredAccuracy = kCLLocationAccuracyBest
        locationMenager.requestWhenInUseAuthorization()
        locationMenager.startUpdatingLocation()
        mapView.delegate = self
    }
    // MARK: - IBAction Methods
    @IBAction func buttomButtonTapped(_ sender: UIButton) {
        annotationView?.isHidden = true
        popupView.isHidden = false
        cancelButton.isHidden = false
        callButton.isHidden = true
    }
    //function for calling the contact number
    @IBAction func callButtonTapped(_ sender: UIButton) {
        if let url: URL = URL(string: Constants.phoneNumber) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            annotationView?.isHidden = false
            callButton.isHidden = false
            popupView.isHidden = true
            cancelButton.isHidden = true
        }
    }
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        annotationView?.isHidden = false
        popupView.isHidden = true
        cancelButton.isHidden = true
        callButton.isHidden = false
    }
// MARK: - Class Methods
    // function for sending alert to inform user
    func displayAlert (title: String, message: String, idError: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Localizable.ShowAlert.cancelButtonText.localized, style: .default) { (_) in }
        let okayAction = UIAlertAction(title: Localizable.ShowAlert.okButtonText.localized, style: .default) { (_) in
            if idError == Constants.locationID {
                if let url = URL.init(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else if idError == Constants.internetID {
                self.checkConnectivity()
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    //function for handling location authorisation
    func handleAuthorisationStatus (status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            // GPS permission has already been authorised, so start requesting location information
            locationMenager.startUpdatingLocation()
        case .denied, .restricted:
            // GPS permission denied or restricted, so ask user to change setting
            displayAlert(title: Localizable.ShowAlert.locationErrorText.localized, message: Localizable.ShowAlert.checkLocationText.localized, idError: Constants.locationID)
        case .notDetermined:
            // User hasn't been asked for GPS permission yet, so ask for it
            locationMenager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    //function for checking internet connection
    func checkConnectivity() {
        // Checking for internet connection
        if !ConnectionMenager.isConnectedToNetwork() {
            self.displayAlert(title: Localizable.ShowAlert.internetErrorText.localized, message: Localizable.ShowAlert.checkInternetText.localized, idError: Constants.internetID)
        } else {
            locationMenager.startUpdatingLocation()
        }
        // Checking for GPS
        if !CLLocationManager.locationServicesEnabled() {
            self.displayAlert(title: Localizable.ShowAlert.locationErrorText.localized, message: Localizable.ShowAlert.checkLocationText.localized, idError: Constants.locationID)
        }
    }
}

// MARK: - CLLocationMenagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        //Deciding how much you're going to zoom in
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        //setting the region to be captured
        mapView.setRegion(region, animated: true)
        //setting where to put map maker on the map
        mapMarker.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        mapView.addAnnotation(mapMarker)
        // getting location in CLLocation format to access geoCoder functions.
        if let clLocation = locations.last {
            customCalloutView.displayAddress(with: clLocation)
        }
        locationMenager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthorisationStatus(status: status)
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //creating custom annotation view
        var customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotationViewIdentifier)
        //checking if the annotation view is already exist.
        if customAnnotationView == nil {
            customAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationViewIdentifier)
            customAnnotationView?.canShowCallout = true
            customAnnotationView?.image = UIImage(named: "marker")
        } else {
            customAnnotationView?.annotation = annotation
        }
        //adding annotation view to custom callout.
        if let annotationView = customAnnotationView {
            self.customCalloutView.addCustomView(annotationView)
        }
        self.annotationView = customAnnotationView
        locationMenager.stopUpdatingLocation()
        return annotationView
    }
}
