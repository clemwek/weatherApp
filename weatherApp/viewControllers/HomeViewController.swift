//
//  HomeViewController.swift
//  weatherApp
//
//  Created by Clement  Wekesa on 23/08/2020.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var homeVm: HomeViewModel!
    private var cities: [String] = []
    private var selectedCity: String? = nil
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        homeVm = HomeViewModel()
        cities = homeVm.places ?? []
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.destination is CityViewController {
            let vc = segue.destination as? CityViewController
            if let city = selectedCity {
                vc?.city = city
            } else {
                print("ERROR: City cannot be nill")
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print(" ---------->>>>>>>: We are gstting here")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row \(indexPath.row) is selected!!!")
        selectedCity = cities[indexPath.row]
        performSegue(withIdentifier: "citySegue", sender: nil)
    }
}
