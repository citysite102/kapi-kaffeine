//
//  KPMenuUploadRequest.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 17/10/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire

class KPMenuUploadRequest: NetworkUploadRequest {
    
    typealias ResponseType = RawJsonResult
    private var cafeID: String!
    private var memberID: String!
    private var photoData: Data!
    
    var method: Alamofire.HTTPMethod {
        return .post
    }
    
    var endpoint: String {
        return "/menus"
    }
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        parameters["cafe_id"] = cafeID
        parameters["member_id"] = memberID
        return parameters
    }
    
    var fileData: Data? {
        return photoData
    }
    var fileKey: String? {
        return "menu1"
    }
    var fileName: String? {
        return "\(self.cafeID)-\(self.memberID)-\(arc4random_uniform(1000))"
    }
    
    var mimeType: String? {
        return "image/jpg"
    }
    
    var headers: [String : String] {
        return ["Content-Type":"multipart/form-data",
                "token":(KPUserManager.sharedManager.currentUser?.accessToken) ?? ""]
    }
    
    public func perform(_ cafeID: String,
                        _ memberID: String?,
                        _ photoData: Data!) -> Promise<(ResponseType)> {
        self.cafeID = cafeID
        self.memberID = memberID ?? KPUserManager.sharedManager.currentUser?.identifier
        self.photoData = photoData
        return  networkClient.performUploadRequest(self).then(execute: responseHandler)
    }
    
}
