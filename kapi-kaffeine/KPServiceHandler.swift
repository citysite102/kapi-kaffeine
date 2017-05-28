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
    
    func fetchRemoteData(_ limitedTime: NSNumber?,
                         _ socket: NSNumber?,
                         _ standingDesk: NSNumber?,
                         _ mrt: String?,
                         _ city: String?,
                         _ completion:((_ result: [KPDataModel]) -> Void)?) {
        kapiDataRequest.perform(limitedTime,
                                socket,
                                standingDesk,
                                mrt,
                                city).then { result -> Void in
                                    var cafaDatas = [KPDataModel]()
                                    
                                    for data in (result["data"].arrayObject)! {
                                        let cafeData = Mapper<KPDataModel>().map(JSONObject: data)
                                        if cafeData != nil {
                                            cafaDatas.append(cafeData!)
                                        }
                                    }
                                    completion?(cafaDatas)
            }.catch { error in
                print("Error")
        }
    }
}
