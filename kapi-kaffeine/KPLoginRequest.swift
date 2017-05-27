//
//  KPLoginRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import PromiseKit

class KPLoginRequest: NetworkRequest {
    
    typealias ResponseType = KPUser
    var baseURL: String {return "https://kapi-test.herokuapp.com"}
    var endpoint: String { return "/login" }
    
    var identifier: String!
    var displayName: String!
    var photoURL: String!
    var email: String!
    
    var parameters: [String : Any]? {
        var parameters = [String : Any]()
        parameters["id"] = self.identifier
        parameters["display_name"] = self.displayName
        parameters["photo_url"] = self.photoURL
        parameters["email"] = self.email
        return parameters
    }
    
//    
//    Alamofire.upload(multipartFormData: { (multipartFormData) in
//        multipartFormData.append("M8okOL1VC5bHjjqVqYwsk2db1AK2".data(using: .utf8)!, withName: "id")
//        multipartFormData.append("Angle".data(using: .utf8)!, withName: "display_name")
//        multipartFormData.append("https://scontent.xx.fbcdn.net/v/xxx.jpg".data(using: .utf8)!, withName: "photo_url")
//        multipartFormData.append("j29192@hotmail.com".data(using: .utf8)!, withName: "email")
//    }, usingThreshold: UInt64.init(),
//        to: "https://kapi-test.herokuapp.com/api/v1/login",
//        method: .post,
//        headers: ["Content-Type":"multipart/form-data","User-Agent":"iReMW4K4fyWos"]) { (encodingResult) in
//            switch encodingResult {
//            case .success(let upload, _, _):
//            upload.responseJSON { response in
//            debugPrint(response)
//            }
//            case .failure(let encodingError):
//            print(encodingError)
//            }
//    }
    
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
