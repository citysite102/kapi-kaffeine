//
//  KPDataModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPDataModel: Mappable {
    
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
 
    
//    id: "00014645-38c8-4eb4-ad9b-faa871d7e511",
//    name: "R5小餐館",
//    city: "chiayi",
//    wifi: 5,
//    seat: 5,
//    quiet: 5,
//    tasty: 5,
//    cheap: 5,
//    music: 5,
//    url: "https://www.facebook.com/r5.bistro",
//    address: "嘉義市東區忠孝路205號",
//    latitude: "23.48386540",
//    longitude: "120.45358340",
//    limited_time: "maybe",
//    socket: "maybe",
//    standing_desk: "no",
//    mrt: "",
//    open_time: "11:30~21:00"

}