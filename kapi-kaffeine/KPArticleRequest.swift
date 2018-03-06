//
//  KPArticleRequest.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 04/03/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import Alamofire
import PromiseKit

class KPArticleRequest: NetworkRequest {
    
    typealias ResponseType = RawJsonResult
    
    private var articleID: String?
    
    var endpoint: String { return "/articles" }
    
    var parameters: [String : Any]? {
        if let identifier = articleID {
            return ["article_id": identifier]
        }
        return nil
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    public func perform(_ articleID: String?) -> Promise<(ResponseType)> {
        self.articleID = articleID
        return networkClient.performRequest(self).then(execute: responseHandler)
    }
}
