//
//  HandlefetchingController.swift
//  DagbokAppTry1
//
//  Created by imran khan on 2018-02-01.
//  Copyright © 2018 imran khan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension AddFormController {
    
    func findMyLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        myLocation = locations[0] as CLLocation
        //        print("user latitude = \(myLocation.coordinate.latitude)")
        //        print("user longtitude = \(myLocation.coordinate.longitude)")
        
    }
}

