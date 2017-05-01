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

class searchResult: Mappable {
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
    }
}

class KPCafeRequest: NetworkRequest {

    typealias ResponseType = searchResult
    
    private var limitedTime: NSNumber?
    private var socket: NSNumber?
    private var standingDesk: NSNumber?
    private var mrt: String?
    private var city: String?
    
    var parameters: [String : Any]? {
        return [
            "limited_time": self.limitedTime ?? NSNull(),
            "socket": self.socket ?? NSNull(),
            "standing_desk": self.standingDesk ?? NSNull(),
            "mrt": self.mrt ?? NSNull(),
            "city": self.city ?? NSNull()
        ]
    }
    var endpoint: String { return "/cafes" }
    
    public func perform(_ limitedTime: NSNumber?,
                        _ socket: NSNumber?,
                        _ standingDesk: NSNumber?,
                        _ mrt: String?,
                        _ city: String?) -> Promise<([ResponseType])> {
        self.limitedTime = limitedTime
        self.socket = socket
        self.standingDesk = standingDesk
        self.mrt = mrt
        self.city = city
        return networkClient.performRequest(self).then(execute: arrayResponseHandler)
    }
}
