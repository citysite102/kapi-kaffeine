//
//  KPUserInformationRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/9.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper
import PromiseKit
import Alamofire


class KPUserInformationRequest: NetworkRequest {
    
    enum requestType {
        case get
        case put
    }
    
    typealias ResponseType = RawJsonResult
    private var displayName: String?
    private var photoURL: String?
    private var defaultLocation: String?
    private var intro: String?
    private var email: String?
    private var type: requestType?
    
    var endpoint: String { return "/members" }
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        
        
        if self.type == requestType.get {
            parameters["member_id"] = KPUserManager.sharedManager.currentUser?.identifier
        } else {
            parameters["member_id"] = KPUserManager.sharedManager.currentUser?.identifier
            parameters["display_name"] = self.displayName
            parameters["photo_url"] = self.photoURL
            parameters["default_location"] = self.defaultLocation
            parameters["intro"] = self.intro
            parameters["email"] = self.email
        }
        
        return parameters
    }
    
    var method: Alamofire.HTTPMethod {
        return self.type == requestType.get ?
            .get :
            .put }
    
    public func perform(_ displayName: String?,
                        _ photoURL: String?,
                        _ defaultLocation: String?,
                        _ intro: String?,
                        _ email: String?,
                        _ type: requestType) -> Promise<(ResponseType)> {
        self.displayName = displayName
        self.photoURL = photoURL
        self.defaultLocation = defaultLocation
        self.intro = intro
        self.email = email
        self.type = type
        return  networkClient.performRequest(self).then(execute: responseHandler)
    }
}
