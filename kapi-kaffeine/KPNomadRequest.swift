//
//  KPNomadRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/3.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON
import PromiseKit

class KPNomadRequest: NetworkRequest {

    typealias ResponseType = KPDataModel
    var baseURL: String {return "https://cafenomad.tw/api/v1.2"}
    var endpoint: String { return "/cafes" }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    public func perform() -> Promise<([ResponseType])> {
        return networkClient.performRequest(self).then(execute: arrayResponseHandler)
    }
}
