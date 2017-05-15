//
//  NetworkErrorHandler.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/1.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import Alamofire

public class NetworkErrorHandler {
    
    public class func handleNetworkRequestError(_ error: Error,
                                                data: Data?,
                                                urlResponse: HTTPURLResponse?) -> Error {
        if (error as NSError).code == -1009 {
            return NetworkRequestError.noNetworkConnection
        } else {
            let errorInfo = errorInformation(error: error,
                                             data: data,
                                             urlResponse: urlResponse)
            return NetworkRequestError.apiError(errorInformation: errorInfo)
        }
    }
    
}
