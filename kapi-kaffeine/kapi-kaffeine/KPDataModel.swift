//
//  KPDataModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPDataModel: NSObject, Mappable, GMUClusterItem {
    
    var identifier: String!
    var address: String!
    var name: String!
    var phone: String!
    var city: String!
    var latitude: String?
    var longitude: String?
    var standingDesk: String?
    var socket: String?
    var limitedTime: String?
    var url: String?
    var facebookURL: String?
    var mrt: String?
    var businessHour: [String: String]!
    var tags: [KPDataTagModel]?
    var rates: KPDataRateModel?
    var photos: [String: String]?
    var isKapi: Bool!
    
    
    var featureContents: [String]! {
        get {
            var features = [String]()
            
            if let storeRates = self.rates {
                
                if (storeRates.wifi?.intValue ?? 0)! > 4 {
                    features.append("網路快速")
                }
                
                if (storeRates.seat?.intValue ?? 0)! > 4 {
                    features.append("座位舒適")
                }
                
                if (storeRates.music?.intValue ?? 0)! > 4 {
                    features.append("提供音樂")
                }
                
                if (storeRates.food?.intValue ?? 0)! > 4 &&
                    features.count < 2 {
                    features.append("提供餐點")
                }
                
                if (storeRates.quite?.intValue ?? 0)! > 4 &&
                    features.count < 2 {
                    features.append("環境安靜")
                }
                
                if (storeRates.tasty?.intValue ?? 0)! > 4 &&
                    features.count < 2 {
                    features.append("食物美味")
                }
                
                if (storeRates.cheap?.intValue ?? 0)! > 4 &&
                    features.count < 2 {
                    features.append("價格實在")
                }
            
            }
            return features
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
        address             <-    map["address"]
        name                <-    map["name"]
        phone               <-    map["phone"]
        city                <-    map["city"]
        latitude            <-    map["latitude"]
        longitude           <-    map["longitude"]
        standingDesk        <-    map["standing_desk"]
        socket              <-    map["socket"]
        limitedTime         <-    map["limited_time"]
        url                 <-    map["url"]
        facebookURL         <-    map["fb_url"]
        mrt                 <-    map["mrt"]
        businessHour        <-    map["business_hour"]
        tags                <-    map["tags"]
        rates               <-    map["rates"]
        photos              <-    map["photos"]
        isKapi              <-    map["is_kapi"]
    }

}
