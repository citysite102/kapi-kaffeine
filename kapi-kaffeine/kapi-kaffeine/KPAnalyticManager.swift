//
//  KPAnalyticManager.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/8/30.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import Amplitude_iOS

public class KPAnalyticManager {

    static func sendEvent(_ eventName: String!,
                          _ properties: [AnyHashable: Any]?) {
        if let _properties = properties {
            Amplitude.instance().logEvent(eventName,
                                          withEventProperties: _properties)
        } else {
            Amplitude.instance().logEvent(eventName)
        }
    }
}
