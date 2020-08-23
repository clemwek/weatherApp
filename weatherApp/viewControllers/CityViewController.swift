//
//  CityViewController.swift
//  weatherApp
//
//  Created by Clement  Wekesa on 23/08/2020.
//

import UIKit

class CityViewController: UIViewController {

    var city: String = ""
    var cityVm: CityViewModel!

    @IBOutlet weak var cityNameText: UILabel!
    @IBOutlet weak var tempLable: UILabel!
    @IBOutlet weak var tempText: UILabel!
    @IBOutlet weak var humidityLable: UILabel!
    @IBOutlet weak var humidityText: UILabel!
    @IBOutlet weak var pressureLable: UILabel!
    @IBOutlet weak var pressureText: UILabel!
    @IBOutlet weak var windLable: UILabel!
    @IBOutlet weak var windtext: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        cityVm = CityViewModel()
        cityVm.getCityWeather {
            DispatchQueue.main.sync {
                self.setUpValue()
            }
        }
    }
    
    func setUpValue() {
        cityNameText.text = cityVm.city
        tempText.text = cityVm.temp
        humidityText.text = cityVm.humidity
        pressureText.text = cityVm.pressure
        windtext.text = cityVm.wind
    }
}
