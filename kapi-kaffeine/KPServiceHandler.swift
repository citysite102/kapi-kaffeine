//
//  KPServiceHandler.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPServiceHandler {

    
    static let sharedHandler = KPServiceHandler()
    
    private var kapiDataRequest: KPCafeRequest!
    
    // MARK: Initialization
    
    private init() {
        kapiDataRequest = KPCafeRequest()
    }
    
    
    // MARK: API
    
    func fetchRemoteData(_ limitedTime: NSNumber? = nil,
                         _ socket: NSNumber? = nil,
                         _ standingDesk: NSNumber? = nil,
                         _ mrt: String? = nil,
                         _ city: String? = nil,
                         _ completion:((_ result: [KPDataModel]) -> Void)? = nil) {
        kapiDataRequest.perform(limitedTime,
                                socket,
                                standingDesk,
                                mrt,
                                city).then { result -> Void in
                                    var cafeDatas = [KPDataModel]()
                                    for data in (result["data"].arrayObject)! {
                                        let cafeData = KPDataModel(JSON: (data as! [String: Any]))
                                        if cafeData != nil {
                                            cafeDatas.append(cafeData!)
                                        }
                                    }
                                    completion?(cafeDatas)
            }.catch { error in
                print("Error")
        }
    }
}
