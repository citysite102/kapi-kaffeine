//
//  KPFeatureTagRequest.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 19/07/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

class KPFeatureTagRequest: NetworkRequest {
    
    typealias ResponseType = RawJsonResult
    
    var endpoint: String { return "/tags" }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    public func perform() -> Promise<(ResponseType)> {
        return  networkClient.performRequest(self).then(execute: responseHandler)
    }

}
