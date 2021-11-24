//
//  LocationHelper.swift
//  Satvik_Friends
//
//  Created by Satvik Kathpal on 2021-11-24.
//  991487352

import Foundation
import CoreLocation
import Contacts
import MapKit

class LocationHelper: NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var address : String = "unknown"
    @Published var currentLocation: CLLocation?
    
    private let locationManager = CLLocationManager()
    private var lastSeenLocation: CLLocation?
    private let geocoder = CLGeocoder()
    
    override init() {
        super.init()
        
        if (CLLocationManager.locationServicesEnabled()){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        self.checkPermission()
        
        if (CLLocationManager.locationServicesEnabled() && ( self.authorizationStatus == .authorizedAlways || self.authorizationStatus == .authorizedWhenInUse)){
            self.locationManager.startUpdatingLocation()
        }else{
            self.requestPermission()
        }
    }
    
    func requestPermission() {
        if (CLLocationManager.locationServicesEnabled()){
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func checkPermission(){
        print(#function, "Checking for permission")
        switch self.locationManager.authorizationStatus {
        case .denied:
            self.requestPermission()
        case .notDetermined:
            self.requestPermission()
        case .restricted:
            self.requestPermission()
        case .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, "Authorization Status : \(manager.authorizationStatus.rawValue)")
        self.authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "error: \(error.localizedDescription)")
    }
    
    func doGeocoding(address: String, completionHandler: @escaping(CLLocation?, NSError?) -> Void){
        self.geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil{
                completionHandler(nil, error as NSError?)
            }else{
                if let placemark = placemarks?.first{
                    let location = placemark.location!
                    
                    print(#function, "location: ", location)
                    
                    completionHandler(location, nil)
                    return
                }
                completionHandler(nil, error as NSError?)
            }
        })
    }
    
}
