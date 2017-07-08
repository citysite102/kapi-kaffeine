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
    func performUploadRequest<Request: NetworkUploadRequest>(_ networkRequest: Request) -> Promise<Data>
}

public struct NetworkClient: NetworkClientType {
    
    public func performRequest<Request : NetworkRequest>(_ networkRequest: Request) -> Promise<Data> {
        
        let (promise, fulfill, reject) = Promise<Data>.pending()
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "User-Agent": "iReMW4K4fyWos"
        ]
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
    
    
    public func performUploadRequest<Request>(_ networkRequest: Request) -> Promise<Data> where Request : NetworkUploadRequest {

        let (promise, fulfill, reject) = Promise<Data>.pending()
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in networkRequest.parameters! {
                if value as? String != nil {
                    multipartFormData.append((value as! String).data(using: .utf8)!,
                                             withName: key)
                } else if value as? NSNumber != nil {
                    let number = value as! NSNumber
                    multipartFormData.append("\(number.stringValue)".data(using: .utf8)!, withName: key)
                }
            }
        }, usingThreshold: networkRequest.threshold,
           to: networkRequest.url,
           method: networkRequest.method,
           headers: networkRequest.headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    fulfill(response.data!)
                }
            case .failure(let encodingError):
                reject(encodingError)
            }
        }
        
        return promise
    }
    
    
    
}

