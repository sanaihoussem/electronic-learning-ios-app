//
//  MapViewController.swift
//  ElectroProject
//
//  Created by Bechir Belkahla on 1/10/18.
//  Copyright © 2018 ESPRIT. All rights reserved.
//

import UIKit
import Alamofire
import MapKit
import CoreLocation
import GoogleMaps

class MapViewController: UIViewController, CLLocationManagerDelegate{
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let center = locationManager.location?.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center!, span: span)
        mapView.setRegion(region, animated: true)
        
        mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getNearbyPlaces(lat: locations[0].coordinate.latitude, long: locations[0].coordinate.longitude )
    }
    
    func getNearbyPlaces(lat: Double , long: Double) -> Void {
        let nearbyPlacesUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(long)&radius=5000&keyword=electronic_store&key=AIzaSyCQvEGjTkaKp71M53lLXpPIe-WbMPFSRIA"
        
        Alamofire.request(nearbyPlacesUrl, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    let results = JSON["results"] as! NSArray
                    
                    for i in 0...(results.count-1){
                        let firstOne = results[i] as! NSDictionary
                        let geometry = firstOne["geometry"] as! NSDictionary
                        let location = geometry["location"] as! NSDictionary

                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: location["lat"]! as! CLLocationDegrees, longitude: location["lng"]! as! CLLocationDegrees)
                        annotation.title = String(describing: firstOne["name"]!)
                        annotation.subtitle = String(describing: firstOne["vicinity"]!)
                        
                        self.mapView.addAnnotation(annotation)
                    }
                }
        }
    }

}
