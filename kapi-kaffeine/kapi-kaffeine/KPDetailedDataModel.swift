//
//  KPDetailedDataModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/9.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPDetailedDataModel: NSObject, Mappable, GMUClusterItem {

    var identifier: String!
    var address: String!
    var name: String!
    var phone: String!
    var city: String!
    var latitude: Double!
    var longitude: Double!
    var standingDesk: NSNumber? = 0
    var socket: NSNumber? = 0
    var limitedTime: NSNumber? = 0
    var url: String?
    var facebookURL: String?
    var facebookID: String?
    var mrt: String?
    var businessHour: KPDataBusinessHourModel?
    var tags: [KPDataTagModel]?
    var rates: [KPSimpleRateModel]?
    var visitedMembers: [KPSimpleMemberModel]?
    var favoritedMembers: [String]?
    
    var averageRate: NSNumber? = 0
    var rateCount: NSNumber?
    var commentCount: NSNumber?
    var favoriteCount: NSNumber?
    var visitCount: NSNumber?
    var photoCount: NSNumber?
    
    var cheapAverage: NSNumber? = 0
    var foodAverage: NSNumber? = 0
    var quietAverage: NSNumber? = 0
    var seatAverage: NSNumber? = 0
    var tastyAverage: NSNumber? = 0
    var musicAverage: NSNumber? = 0
    var wifiAverage: NSNumber? = 0
    
    var imageURL_s: URL?
    var imageURL_l: URL?
    
    var googleURL_s: URL?
    var googleURL_l: URL?
    
    var isKapi: Bool!
    
    var createdTime: NSNumber?
    var modifiedTime: NSNumber?
    
    var photos: [String]?
    var kapiPhotos: [String]?
    var comments:[KPCommentModel]?
    
    var priceAverage: NSNumber? = 0
    
    var featureContents: [String]! {
        get {
            var features = [String]()
            
            if let tagContent = self.tags {
                for tag in tagContent {
                    features.append(tag.name)
                }
            }
            return features
        }
    }
    
    var position: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
    }
    
    var distanceInMeter: Double? {
        get {
            if let currentLocation = KPLocationManager.sharedInstance().currentLocation {
                return CLLocation(latitude: self.latitude,
                                  longitude: self.longitude).distance(from: currentLocation)
            }
            return nil
        }
    }
    
    required init?(map: Map) {
        if map.JSON["cafe_id"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        identifier          <-    map["cafe_id"]
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
        facebookID          <-    map["fb_id"]
        mrt                 <-    map["mrt"]
        businessHour        <-    (map["business_hours"], businessHourTransform)
        tags                <-    map["tags"]
        averageRate         <-    map["rate_average"]
        rateCount           <-    map["rate_count"]
        commentCount        <-    map["comment_count"]
        favoriteCount       <-    map["favorite_count"]
        visitCount          <-    map["visit_count"]
        photoCount          <-    map["photo_count"]
        isKapi              <-    map["is_kapi"]
        createdTime         <-    map["created_time"]
        modifiedTime        <-    map["modified_time"]
        photos              <-    map["photos"]
        kapiPhotos          <-    map["kapi_photos"]
        comments            <-    map["comments"]
        priceAverage        <-    map["price_average"]
        rates               <-    map["rates"]
        visitedMembers      <-    map["visit_members"]
        favoritedMembers    <-    map["favorite_members"]
        cheapAverage    <-  map["cheap_avg"]
        foodAverage     <-  map["food_avg"]
        quietAverage    <-  map["quiet_avg"]
        seatAverage     <-  map["seat_avg"]
        tastyAverage    <-  map["tasty_avg"]
        musicAverage    <-  map["music_avg"]
        wifiAverage     <-  map["wifi_avg"]
        imageURL_s      <-  (map["covers.kapi_s"], URLTransform())
        imageURL_l      <-  (map["covers.kapi_l"], URLTransform())
        googleURL_s     <-  (map["covers.google_s"], URLTransform())
        googleURL_l     <-  (map["covers.google_l"], URLTransform())

    }
    
    let businessHourTransform = TransformOf<KPDataBusinessHourModel,
        [String: String]>(fromJSON: { (value: [String: String]?) -> KPDataBusinessHourModel? in
            // transform value from String? to Int?
            if value != nil {
                return KPDataBusinessHourModel(value: value!)
            }
            return nil
        }, toJSON: { (value: KPDataBusinessHourModel?) -> [String: String]? in
            // transform value from Int? to String?
            return nil
        })
    
}
