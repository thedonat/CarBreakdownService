//
//  Localizable.swift
//  RSR Pechhulp - Burak Donat
//
//  Created by Burak Donat on 3.04.2020.
//  Copyright © 2020 Burak Donat. All rights reserved.
//

import Foundation

protocol LocalizableDelegate {
    var rawValue: String { get } //localize key
    var table: String? { get }
    var localized: String { get }
}

enum Localizable {
    enum OverPage: String, LocalizableDelegate {
        case overText = "Over Rsr Text"
    }
    enum CustomCallout: String, LocalizableDelegate {
        case yourLocationText = "Your location"
        case loadingAddressText = "Loading address"
        case rememberLocationText = "Remember location"
    }
    enum ShowAlert: String, LocalizableDelegate {
        case cancelButtonText = "Cancel"
        case okButtonText = "OK"
        case internetErrorText = "Internet error"
        case checkInternetText = "Check internet connection"
        case locationErrorText = "Location service disabled"
        case checkLocationText = "Please enable location"
    }
}

extension LocalizableDelegate {
    //returns a localized value by specified key located in the specified table
    var localized: String {
        return Bundle.main.localizedString(forKey: rawValue, value: nil, table: table)
    }
    // file name, where to find the localized key
    // by default is the Localizable.string table
    var table: String? {
        return nil
    }
}
