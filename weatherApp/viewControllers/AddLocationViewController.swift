//
//  AddLocationViewController.swift
//  weatherApp
//
//  Created by Clement  Wekesa on 23/08/2020.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark, name: String)
    func showAlert(place: MKMapItem)
}

class AddLocationViewController: UIViewController {
    
    private var addLocationVM: AddLocationViewModel!

    @IBOutlet weak var mapView: MKMapView!
    var currentLoc: CLLocation!
    var locationManager: CLLocationManager?
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        addLocationVM = AddLocationViewModel()
        setLocation()
        setupSearchTable()
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }

    func setupSearchTable() {
        // Setup the search table
        let locationTable = storyboard!.instantiateViewController(withIdentifier: "LocationTable") as! LocationTableViewController
        resultSearchController = UISearchController(searchResultsController: locationTable)
        resultSearchController?.searchResultsUpdater = locationTable

        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar

        resultSearchController?.hidesNavigationBarDuringPresentation = false
        if #available(iOS 9.1, *) {
            resultSearchController?.obscuresBackgroundDuringPresentation = true
        } else {
            // Fallback on earlier versions
        }
        definesPresentationContext = true

        locationTable.mapView = mapView

        locationTable.handleMapSearchDelegate = self
    }
    
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddLocationViewController: CLLocationManagerDelegate {
    func setLocation() {
        // Setup location manager and request for permisions track user location
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()

        // Start tracking location
        locationManager?.startUpdatingLocation()

    }

    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last,
            location.horizontalAccuracy > 0 {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            locationManager?.stopUpdatingLocation()
        }
    }

    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("There was an error: ", error)
    }
}

extension AddLocationViewController: UIGestureRecognizerDelegate {
    @objc
    func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        let cgLocation = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(cgLocation, toCoordinateFrom: mapView)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        lookUpCurrentLocation(location: location) { (placemark) in
            if let placemark = placemark {
                self.showAlert(place: MKMapItem(placemark: MKPlacemark(placemark: placemark)))
            }
        }
    }

    // This looks up the tapped location and adds description
    func lookUpCurrentLocation(location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()

        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let firstLocation = placemarks?[0]
                                                completionHandler(firstLocation)
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                completionHandler(nil)
                                            }
        })
    }
}

extension AddLocationViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark, name: String = "") {
        // cache the pin
        selectedPin = placemark
        let newName = name == "" ? placemark.name : name
        // clear existing pins
//        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = newName
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }

        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }

    func showAlert(place: MKMapItem) {
        let alertController = UIAlertController(title: "Do you what to select this location?",
                                                message: "If you select this location you will be able to get the weather for this place",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            self.dropPinZoomIn(placemark: place.placemark)
            self.addLocationVM.saveLocation(placemark: place.placemark)
            
        }))

        self.present(alertController, animated: true, completion: nil)
    }
}
