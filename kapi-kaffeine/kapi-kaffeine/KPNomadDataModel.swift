//
//  KPNomadDataModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPNomadDataModel: NSObject, Mappable, GMUClusterItem {
    
    var identifier: String!
    var name: String!
    var city: String!
    var wifi: NSNumber?
    var seat: NSNumber?
    var quite: NSNumber?
    var tasty: NSNumber?
    var cheap: NSNumber?
    var music: NSNumber?
    var url: String?
    var address: String?
    var latitude: String?
    var longitude: String?
    var limitedTime: String?
    var socket: String?
    var standingDesk: String?
    var mrt: String?
    var openTime: String?
    
    
    var usableFeatureCount: Int? {
        get {
            var count:Int = 0
            count += self.wifi?.intValue == 0 ? 0 : 1;
            count += self.seat?.intValue == 0 ? 0 : 1;
            count += self.quite?.intValue == 0 ? 0 : 1;
            count += self.tasty?.intValue == 0 ? 0 : 1;
            count += self.cheap?.intValue == 0 ? 0 : 1;
            count += self.music?.intValue == 0 ? 0 : 1;
            return count
        }
    }
    
    var score: Double? {
        get {
            
            var sum = 0.0;
            sum += (self.wifi?.doubleValue) ?? 0;
            sum += (self.seat?.doubleValue) ?? 0;
            sum += (self.quite?.doubleValue) ?? 0;
            sum += (self.tasty?.doubleValue) ?? 0;
            sum += (self.cheap?.doubleValue) ?? 0;
            sum += (self.music?.doubleValue) ?? 0;
            
            return sum/Double(self.usableFeatureCount!)
        }
    }
    
    var position: CLLocationCoordinate2D {
        get {
            
            if let latstr = self.latitude, let latitude = Double(latstr),
                let longstr = self.longitude, let longitude = Double(longstr) {
                return CLLocationCoordinate2DMake(latitude, longitude)
            }
            
            return CLLocationCoordinate2DMake(-90, 0)
        }
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        identifier          <-    map["identifier"]
        name                <-    map["name"]
        city                <-    map["city"]
        wifi                <-    map["wifi"]
        seat                <-    map["seat"]
        quite               <-    map["quite"]
        tasty               <-    map["tasty"]
        cheap               <-    map["cheap"]
        music               <-    map["music"]
        url                 <-    map["url"]
        address             <-    map["address"]
        latitude            <-    map["latitude"]
        longitude           <-    map["longitude"]
        limitedTime         <-    map["limited_time"]
        socket              <-    map["socket"]
        standingDesk        <-    map["standing_desk"]
        mrt                 <-    map["mrt"]
        openTime            <-    map["open_time"]
    }
    
}
