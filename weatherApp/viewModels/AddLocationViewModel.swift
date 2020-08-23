//
//  AddLocationViewModel.swift
//  weatherApp
//
//  Created by Clement  Wekesa on 23/08/2020.
//

import Foundation
import MapKit

class AddLocationViewModel {
    let defaults = UserDefaults.standard
    
    func saveLocation(placemark: MKPlacemark) {
        var newPlace = ""
        if let places = defaults.string(forKey: "places") {
            newPlace = places + ", \(placemark.locality)"
        } else {
            newPlace = ", \(placemark.locality)"
        }
        defaults.setValue(newPlace, forKey: "places")
    }
}
