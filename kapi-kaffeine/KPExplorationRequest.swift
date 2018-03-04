//
//  KPExplorationRequest.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 04/03/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

class KPExplorationRequest: NetworkRequest {

    typealias ResponseType = RawJsonResult
    
    var endpoint: String { return "/explorers" }
    
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
