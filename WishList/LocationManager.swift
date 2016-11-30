//
//  LocationManager.swift
//  CLTest
//
//  Created by valvoline on 29/11/2016.
//  Copyright © 2016 Sofapps. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager : NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var completionBlock:(([CLLocation], Error?) -> Void)?
    static let shared = LocationManager()

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func startUpdatingLocation(completion: @escaping ([CLLocation], Error?) -> Void ) {
        // 1. status is not determined
        if CLLocationManager.authorizationStatus() == .notDetermined {
            completionBlock = completion
            locationManager.requestWhenInUseAuthorization()
        }
            // 2. authorization were denied
        else if CLLocationManager.authorizationStatus() == .denied {
            print("Location services were previously denied. Please enable location services.")
        }
            // 3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            completionBlock = completion
        }
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.isEmpty == false {
            manager.stopUpdatingLocation()

            if let aCompletionBlock  = completionBlock {
                aCompletionBlock(locations, nil)
            }

        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let aCompletionBlock = completionBlock {
            aCompletionBlock([], error)
        }
        manager.stopUpdatingLocation()
    }

}
