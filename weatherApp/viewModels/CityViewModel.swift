//
//  CityViewModel.swift
//  weatherApp
//
//  Created by Clement  Wekesa on 23/08/2020.
//

import Foundation

class CityViewModel {
    
    var city: String {
        if let name = data["name"] as? String {
            return name
        } else {
            return ""
        }
    }
    var data: [String: Any] = [:]
    var wind: String {
        if let rawWind = data["wind"] {
            if let rawWindVal = rawWind as? [String: Any] {
                return "\(rawWindVal["deg"])"
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    var temp: String {
        if let rawMain = data["main"] {
            if let rawTempVal = rawMain as? [String: Any] {
                return "\(rawTempVal["temp"])"
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    var pressure: String {
        if let rawMain = data["main"] {
            if let rawPressureVal = rawMain as? [String: Any] {
                return "\(rawPressureVal["pressure"])"
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    var humidity: String {
        if let rawMain = data["main"] {
            if let rawHumidityVal = rawMain as? [String: Any] {
                return "\(rawHumidityVal["humidity"])"
            } else {
                return ""
            }
        } else {
            return ""
        }
    }

    init() {}
    
    func getCityWeather(completion:@escaping () -> ()) {
        NetworkClient.standard.get(city: city) { (status, data) in
            guard
                status,
                let data = data
            else { return }
            self.data = data
        }
    }
}
