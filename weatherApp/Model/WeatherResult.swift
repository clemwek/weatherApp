//
//  WeatherResult.swift
//  weatherApp
//
//  Created by Clement  Wekesa on 23/08/2020.
//

import Foundation

struct WeatherResult: Codable {
    var name: String = ""
    var main: [Main]?
//    var wind: Wind?
}

struct Wind: Codable {
    var speed: Int = 0
    var deg: Int = 0
}

struct Main: Codable {
    var humidity: Int = 0
    var temp: Double = 0.0
    var pressure: Int = 0
}
