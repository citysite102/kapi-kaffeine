//
//  KPAddNewStoreRequest.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 2018/4/16.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire

class KPAddNewStoreRequest: NetworkRequest {
    
    typealias ResponseType = RawJsonResult

    var endpoint: String { return "/cafes" }
    var method: Alamofire.HTTPMethod { return .post }
    var parameters: [String : Any]? {
        
        var parameters = [String : Any]()
        
        parameters["name"] = uploadData.name
        parameters["address"] = uploadData.address
        parameters["latitude"] = uploadData.coordinate.latitude
        parameters["longitude"] = uploadData.coordinate.longitude
        
        // TODO:  城市/地區
//        parameters["country"] = country
//        parameters["city"] = city
        
        if let url = uploadData.url {
            parameters["url"] = url
        }
        
        if let limitedTime = uploadData.limitedTime {
            parameters["limited_time"] = limitedTime
        }
        if let socket = uploadData.socket {
            parameters["socket"] = socket
        }
        if let wifi = uploadData.wifi {
            parameters["wifi"] = wifi
        }
        if let standingDesk = uploadData.standingDesk {
            parameters["standing_desk"] = standingDesk
        }

        
        // TODO: tags
//
//        //        parameters["tags"] = tags?.toJSONString()
//
//        var tagStrings = [String]()
//        for tag in tags ?? [] {
//            tagStrings.append(tag.identifier)
//        }
//        parameters["tags"] = tagStrings
//
        
        
        if let businessHour = uploadData.businessHour {
            parameters["business_hours"] = businessHour
        }
        
        if let drinkPrice = uploadData.drinkPrice {
            parameters["price_average"] = drinkPrice
        }
        
        if let foodPrice = uploadData.foodPrice {
            parameters["price_average_food"] = foodPrice
        }
        
        parameters["member_id"] = KPUserManager.sharedManager.currentUser?.identifier
        
        return parameters
        
    }
    
    private var uploadData: KPUploadDataModel!
    
    public func perform(_ data: KPUploadDataModel) -> Promise<ResponseType> {
        uploadData = data
        return networkClient.performRequest(self).then(execute: responseHandler)
    }
    
}

