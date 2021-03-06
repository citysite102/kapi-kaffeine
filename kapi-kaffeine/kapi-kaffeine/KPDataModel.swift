//
//  KPDataModel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPDataModel: NSObject, Mappable, GMUClusterItem, Comparable {
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    ///
    /// This function is the only requirement of the `Comparable` protocol. The
    /// remainder of the relational operator functions are implemented by the
    /// standard library for any type that conforms to `Comparable`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    static func <(lhs: KPDataModel, rhs: KPDataModel) -> Bool {
        return lhs.distanceInMeter! < rhs.distanceInMeter!
    }

    
    
    
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
    var facebookURL: String?
    var facebookID: String?
    var mrt: String?
    var businessHour: KPDataBusinessHourModel?
    var tags: [KPDataTagModel]?
    var closed: Bool = false
    var verified: Bool = true
    
    var averageRate: NSNumber? = 0
    var rateCount: NSNumber? = 0
    var commentCount: NSNumber? = 0
    var favoriteCount: NSNumber? = 0
    var visitCount: NSNumber? = 0
    var photoCount: NSNumber? = 0
    
    var cheapAverage: NSNumber? = 0
    var foodAverage: NSNumber? = 0
    var quietAverage: NSNumber? = 0
    var seatAverage: NSNumber? = 0
    var tastyAverage: NSNumber? = 0
    var musicAverage: NSNumber? = 0
    var wifiAverage: NSNumber? = 0
    var priceAverage: NSNumber? = 0
    
    var covers: [String: String]?
    var isKapi: Bool!
    
    var createdTime: NSNumber?
    var modifiedTime: NSNumber?
    
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
        facebookURL         <-    map["fb_url"]
        facebookID          <-    map["fb_id"]
        mrt                 <-    map["mrt"]
        businessHour        <-    (map["business_hours"], businessHourTransform)
        tags                <-    (map["tags"], tagsTransform)
        averageRate         <-    map["rate_average"]
        rateCount           <-    map["rate_count"]
        commentCount        <-    map["comment_count"]
        favoriteCount       <-    map["favorite_count"]
        visitCount          <-    map["visit_count"]
        photoCount          <-    map["photo_count"]
        covers              <-    map["covers"]
        isKapi              <-    map["is_kapi"]
        createdTime         <-    map["created_time"]
        modifiedTime        <-    map["modified_time"]
        cheapAverage        <-    map["cheap_avg"]
        foodAverage         <-    map["food_avg"]
        quietAverage        <-    map["quiet_avg"]
        seatAverage         <-    map["seat_avg"]
        tastyAverage        <-    map["tasty_avg"]
        musicAverage        <-    map["music_avg"]
        wifiAverage         <-    map["wifi_avg"]
        priceAverage        <-    map["price_average"]
        closed              <-    map["is_close"]
        verified            <-    map["is_verify"]
        
    }
    
//    let tagsModelTransform = TransformOf(fromJSON: { (value: [String]?) -> [KPDataTagModel]? in
//        
//        return []
//    }) { (tags: [KPDataTagModel]?) -> [String]? in
//        return []
//    }
    
    let tagsTransform = TransformOf<[KPDataTagModel], [String]>(fromJSON: {(tagIdentifiers: [String]?) -> [KPDataTagModel]? in
        
        var tags = [KPDataTagModel]()
        if let tagids = tagIdentifiers {
            for identifier in tagids {
                for tag in KPServiceHandler.sharedHandler.featureTags {
                    if identifier == tag.identifier {
                        tags.append(tag)
                        break
                    }
                }
            }
        }
        return tags
    }, toJSON: { (value: [KPDataTagModel]?) -> [String]? in
        return []
    });
    
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
