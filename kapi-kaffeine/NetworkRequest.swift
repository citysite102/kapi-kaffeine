//
//  NetworkRequest.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/1.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

public struct errorInformation {
    
    let error: Error
    let statusCode: Int?
    let responseBody: KPErrorResponseModel?
    let errorCode: String?
    
    init(error: Error, data: Data?, urlResponse: HTTPURLResponse?) {
        self.error = error
        let json = String(data: data ?? Data(), encoding: String.Encoding.utf8)
        responseBody = KPErrorResponseModel(JSONString:json!)
        statusCode = urlResponse?.statusCode
        errorCode = responseBody?.errorCode
    }
}

public enum NetworkRequestError: Error {
    case invalidData
    case apiError(errorInformation: errorInformation)
    case unknownError
    case noNetworkConnection
    case resultUnavailable
}

public typealias RawJsonResult = JSON

// MARK: Request

public protocol NetworkRequest {
    
    associatedtype ResponseType
    
    // Required
    /// End Point.
    /// e.g. /cards/:id/dislike
    var endpoint: String { get }
    
    /// Will transform given data to requested type of response.
    var responseHandler: (Data) throws -> ResponseType { get }
    
    // Optional
    var baseURL: String { get }
    /// Method to make the request. E.g. get, post.
    
    var method: Alamofire.HTTPMethod { get }
    /// Parameter encoding. E.g. JSON, URLEncoding.default.
    
    var encoding: Alamofire.ParameterEncoding { get }
    
    var parameters: [String : Any]? { get }
    var headers: [String : String] { get }
    
    /// Client that helps you to make reqeust.
    var networkClient: NetworkClientType { get }
    
}

extension NetworkRequest {
    
    public var url: String { return baseURL + endpoint}
//    public var baseURL: String { return "https://kapi-v2-test.herokuapp.com/api/v2" }
    public var baseURL: String { return "https://api.kapi.tw/api/v2" }
//    public var baseURL: String { return "http://35.201.206.7/api/v2" }
    public var method: Alamofire.HTTPMethod { return .get }
    public var encoding: Alamofire.ParameterEncoding { return method == .get ?
        URLEncoding.default :
        JSONEncoding.default }
    
    public var parameters: [String : AnyObject] { return [:] }
    public var headers: [String : String] {
        return ["token": (KPUserManager.sharedManager.currentUser?.accessToken) ?? ""]
    }
    
    public var networkClient: NetworkClientType { return NetworkClient() }
    
}

extension NetworkRequest where ResponseType: Mappable {
    
    // 輸入 Data 型別，回傳 ResponseType
    public var responseHandler: (Data) throws -> ResponseType { return jsonResponseHandler }
    public var arrayResponseHandler: (Data) throws -> [ResponseType] { return jsonArrayResponseHandler }
    
    private func jsonResponseHandler(_ data: Data) throws -> ResponseType {
        let json = String(data: data, encoding: String.Encoding.utf8)
        
        if let response = Mapper<ResponseType>().map(JSONString: json!) {
            return response
        } else {
            throw NetworkRequestError.invalidData
        }
    }
    
    private func jsonArrayResponseHandler(_ data: Data) throws -> [ResponseType] {
        let json = String(data: data , encoding: String.Encoding.utf8)
        if let responses = Mapper<ResponseType>().mapArray(JSONString: json!) {
            return responses
        } else {
            throw NetworkRequestError.invalidData
        }
    }
}

extension NetworkRequest where ResponseType == RawJsonResult {
    
    public var responseHandler: (Data) throws -> ResponseType {
        return rawJsonResponseHandler
    }

    private func rawJsonResponseHandler(_ data: Data) throws -> ResponseType {
        if let responseResult = try JSON(data: data).dictionary?["result"] {
            if responseResult.boolValue {
                return try JSON(data: data)
            } else {
                throw NetworkRequestError.resultUnavailable
            }
        }
        return try JSON(data: data)
    }
}


// MARK: Upload Request

public protocol NetworkUploadRequest {
    
    associatedtype ResponseType
    
    var endpoint: String { get }
    
    var responseHandler: (Data) throws -> ResponseType { get }
    
    // Optional
    var baseURL: String { get }
    
    var method: Alamofire.HTTPMethod { get }
    
    var threshold: UInt64 { get }

    var parameters: [String : Any]? { get }

    var headers: [String : String] { get }
    
    var fileData: Data? { get }
    var fileKey: String? { get }
    var fileName: String? { get }
    var mimeType: String? { get }
    
    /// Client that helps you to make reqeust.
    var networkClient: NetworkClientType { get }
    
}

extension NetworkUploadRequest {
    
    public var url: String { return baseURL + endpoint}
//    public var baseURL: String {return "https://kapi-v2-test.herokuapp.com/api/v2"}
    public var baseURL: String { return "https://api.kapi.tw/api/v2" }
//    public var baseURL: String { return "http://35.201.206.7/api/v2" }
    public var method: Alamofire.HTTPMethod { return .post }
    
    public var threshold: UInt64 { return 100_000_000 }
    public var parameters: [String : AnyObject] { return [:] }
    public var headers: [String : String] { return ["Content-Type":"multipart/form-data",
                                                    "User-Agent":"iReMW4K4fyWos"] }
    
    public var networkClient: NetworkClientType { return NetworkClient() }
    
}

extension NetworkUploadRequest where ResponseType: Mappable {
    
    // 輸入 Data 型別，回傳 ResponseType
    public var responseHandler: (Data) throws -> ResponseType { return jsonResponseHandler }
    public var arrayResponseHandler: (Data) throws -> [ResponseType] { return jsonArrayResponseHandler }
    
    private func jsonResponseHandler(_ data: Data) throws -> ResponseType {
        let json = String(data: data, encoding: String.Encoding.utf8)
        
        if let response = Mapper<ResponseType>().map(JSONString: json!) {
            return response
        } else {
            throw NetworkRequestError.invalidData
        }
    }
    
    private func jsonArrayResponseHandler(_ data: Data) throws -> [ResponseType] {
        let json = String(data: data , encoding: String.Encoding.utf8)
        if let responses = Mapper<ResponseType>().mapArray(JSONString: json!) {
            return responses
        } else {
            throw NetworkRequestError.invalidData
        }
    }
}

extension NetworkUploadRequest where ResponseType == RawJsonResult {
    
    public var responseHandler: (Data) throws -> ResponseType { return rawJsonResponseHandler }
    
    private func rawJsonResponseHandler(_ data: Data) throws -> ResponseType {
        return try JSON(data: data)
    }
}

