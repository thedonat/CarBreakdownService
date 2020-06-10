//
//  CustomCalloutViewController.swift
//  RSR Pechhulp - Burak Donat
//
//  Created by Burak Donat on 16.03.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

 class CalloutViewMenager {
    let geoCoder = CLGeocoder()
    let addressLabel = UILabel(frame: CGRect.zero)
    //creating custom blue callout programatically and adding it to annotationView
    func addCustomView(_ customAnnotationView: MKAnnotationView) {
        let customCalloutView = UIImageView(image: UIImage(named: "address_back"))
        customCalloutView.translatesAutoresizingMaskIntoConstraints = false
        customCalloutView.frame = CGRect.zero
        customAnnotationView.addSubview(customCalloutView)

        customCalloutView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        customCalloutView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        customCalloutView.bottomAnchor.constraint(equalTo: customAnnotationView.topAnchor, constant: 0).isActive = true
        customCalloutView.centerXAnchor.constraint(equalTo: customAnnotationView.centerXAnchor, constant: -10).isActive = true
        //creating addressLabel
        addressLabel.textColor = UIColor.white
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.numberOfLines = 0
        addressLabel.textAlignment = .center
        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.text = Localizable.CustomCallout.yourLocationText.localized + "\n\n" +
        Localizable.CustomCallout.loadingAddressText.localized + "\n\n" +
            Localizable.CustomCallout.rememberLocationText.localized
        customCalloutView.addSubview(addressLabel)
        //setting addressLabel constraints
        addressLabel.widthAnchor.constraint(equalTo: customCalloutView.widthAnchor, constant: 0).isActive = true
        addressLabel.topAnchor.constraint(equalTo: customCalloutView.topAnchor, constant: 30).isActive = true
        addressLabel.centerXAnchor.constraint(equalTo: customCalloutView.centerXAnchor).isActive = true
    }
    // Converting coordinates to address, postal code etc.
    func displayAddress(with location: CLLocation) {
           let address = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

           geoCoder.reverseGeocodeLocation(address) { (placemarks, error) -> Void in
            if error == nil {
                if let placemarks = placemarks, placemarks.count > 0 {
                    let placemark = placemarks[0]
                    var addressString: String = ""
                    // First check if placemarks exist
                    if let thoroughfare = placemark.thoroughfare {
                        addressString += thoroughfare + ", "
                    }
                    if let subThoroughfare = placemark.subThoroughfare {
                        addressString += subThoroughfare + "\n"
                    }
                    if let postalCode = placemark.postalCode {
                        addressString += postalCode + ", "
                    }
                    if let locality = placemark.locality {
                        addressString += locality
                    }
                    print(addressString)
                    self.addressLabel.text =
                        Localizable.CustomCallout.yourLocationText.localized +
                        "\n\n" + addressString + "\n\n" +
                        Localizable.CustomCallout.rememberLocationText.localized
                }
            }
        }
    }
}
