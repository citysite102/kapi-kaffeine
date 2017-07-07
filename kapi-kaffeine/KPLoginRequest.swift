//
//  KPLoginRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire

class KPLoginRequest: NetworkRequest {

    typealias ResponseType = RawJsonResult
    
    var endpoint: String { return "/login" }
    var identifier: String!
    var displayName: String!
    var photoURL: String!
    var email: String!
    var method: Alamofire.HTTPMethod { return .post }
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        parameters["member_id"] = self.identifier
        parameters["display_name"] = self.displayName
        parameters["photo_url"] = self.photoURL
        parameters["email"] = self.email
        return parameters
    }
    
    var headers: [String : String] {
        return ["Content-Type": "application/json",
                "User-Agent": "iReMW4K4fyWos"]
    }
    
    
    public func perform(_ identifier: String!,
                        _ displayName: String!,
                        _ photoURL: String!,
                        _ email: String!) -> Promise<(ResponseType)> {
        self.identifier = identifier
        self.displayName = displayName
        self.photoURL = photoURL
        self.email = email
        return networkClient.performRequest(self).then(execute: responseHandler)
    }
}
