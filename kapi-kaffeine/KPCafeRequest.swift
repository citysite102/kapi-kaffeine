//
//  KPCafeRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/1.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper
import PromiseKit
import Alamofire

class KPCafeRequest: NetworkRequest {

    typealias ResponseType = KPDataModel
    
    private var limitedTime: NSNumber?
    private var socket: NSNumber?
    private var standingDesk: NSNumber?
    private var mrt: String?
    private var city: String?
    private var rightTopCoordinate: CLLocationCoordinate2D?
    private var leftBottomCoordinate: CLLocationCoordinate2D?
    private var searchText: String?
    
    var endpoint: String { return "/cafes" }
    
    var parameters: [String : Any]? {    
        var parameters = [String : Any]()
        
        if self.limitedTime != nil {
            parameters["limited_time"] = self.limitedTime
        }
        if self.socket != nil {
            parameters["socket"] = self.socket
        }
        if self.standingDesk != nil {
            parameters["standing_desk"] = self.standingDesk
        }
        if self.mrt != nil {
            parameters["mrt"] = self.mrt
        }
        if self.city != nil {
            parameters["city"] = self.city
        }
        if self.rightTopCoordinate != nil {
            
            parameters["first_corner"] = "\(self.rightTopCoordinate!.latitude),\(self.rightTopCoordinate!.longitude)"
        }
        if self.leftBottomCoordinate != nil {
            parameters["third_corner"] = "\(self.leftBottomCoordinate!.latitude),\(self.leftBottomCoordinate!.longitude)"
        }
        
        if self.searchText != nil {
            parameters["text"] = self.searchText
        }
        
        return parameters
    }
    
    var method: Alamofire.HTTPMethod { return .get }
    
    public func perform(_ limitedTime: NSNumber? = nil,
                        _ socket: NSNumber? = nil,
                        _ standingDesk: NSNumber? = nil,
                        _ mrt: String? = nil,
                        _ city: String? = nil,
                        _ rightTop: CLLocationCoordinate2D? = nil,
                        _ leftBottom: CLLocationCoordinate2D? = nil,
                        _ searchText: String? = nil) -> Promise<([ResponseType])> {
        self.limitedTime = limitedTime
        self.socket = socket
        self.standingDesk = standingDesk
        self.mrt = mrt
        self.city = city
        self.rightTopCoordinate = rightTop
        self.leftBottomCoordinate = leftBottom
        self.searchText = searchText
        return networkClient.performRequest(self).then(execute: arrayResponseHandler)
    }
}
