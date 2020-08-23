//
//  HomeViewModel.swift
//  weatherApp
//
//  Created by Clement  Wekesa on 23/08/2020.
//

import Foundation

class HomeViewModel {
    var places: [String]? {
        let rawPlaces = UserDefaults.standard.string(forKey: "places")
        return rawPlaces?.components(separatedBy: ", ")    }
}
