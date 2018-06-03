//
//  KPErrorReportRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2018/6/4.
//  Copyright © 2018年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper
import PromiseKit
import Alamofire

class KPErrorReportRequest: NetworkRequest {
    
    private var reportMessage: String?
    var endpoint: String { return "/error_reports" }
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        
        parameters["member_id"] = KPUserManager.sharedManager.currentUser?.identifier
        parameters["message"] = reportMessage ?? ""
        
        return parameters
    }
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var headers: [String : String] {
        return ["Content-Type": "application/json",
                "token": (KPUserManager.sharedManager.currentUser?.accessToken) ?? ""]
    }
    
    
    
    public func perform(_ message: String) -> Promise<(ResponseType)> {
        self.reportMessage = message
        return  networkClient.performRequest(self).then(execute: responseHandler)
    }
    
}
