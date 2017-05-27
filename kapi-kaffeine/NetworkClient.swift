//
//  NetworkClient.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/1.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//


import Foundation
import Alamofire
import ObjectMapper
import PromiseKit

public protocol NetworkClientType {
    func performRequest<Request: NetworkRequest>(_ networkRequest: Request) -> Promise<Data>
//    func performUploadRequest<Request: NetworkUploadRequest>
}

public struct NetworkClient: NetworkClientType {
    
    public func performRequest<Request : NetworkRequest>(_ networkRequest: Request) -> Promise<Data> {
        
        let (promise, fulfill, reject) = Promise<Data>.pending()
        Alamofire.request(networkRequest.url,
                          method: networkRequest.method,
                          parameters: networkRequest.parameters,
                          encoding: networkRequest.encoding,
                          headers: networkRequest.headers).validate().response { (response) in
                            if let data = response.data, response.error == nil {
                                fulfill(data)
                            } else if let error = response.error, let data = response.data {
                                let requestError = NetworkErrorHandler.handleNetworkRequestError(error,
                                                                                          data: data,
                                                                                          urlResponse: response.response
                                                                                          )
                                reject(requestError);
                                
                            } else {
                                reject(NetworkRequestError.unknownError)
                            }
        }
        return promise
    }
    
    
    
}

