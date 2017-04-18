//
//  KPLocationManager.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 18/04/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit
import CoreLocation

class KPLocationManager: NSObject, CLLocationManagerDelegate {
    
    private static var mInstance:KPLocationManager?
    
    private let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    static func sharedInstance() -> KPLocationManager {
        if mInstance == nil {
            mInstance = KPLocationManager()
        }
        return mInstance!
    }
    
    func hello() {
        
    }
    
    override init() {
        super.init()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last;
        print(self.currentLocation!)
    }
    
}
