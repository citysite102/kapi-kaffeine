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
    
    static func sendButtonClickEvent(_ buttonName: String!) {
        KPAnalyticManager.sendEvent(KPAnalyticsEvent.button_click,
                                    [KPAnalyticsEventProperty.name: buttonName])
    }
    
    static func sendCellClickEvent(_ storeName: String!,
                                   _ storeRating: String?,
                                   _ source: String! ) {
        KPAnalyticManager.sendEvent(KPAnalyticsEvent.cell_click,
                                    [KPAnalyticsEventProperty.store_name: storeName,
                                     KPAnalyticsEventProperty.store_rate: storeRating ?? KPAnalyticsEventValue.unknown,
                                     KPAnalyticsEventProperty.source: source])
    }
    
    static func sendAdsClickEvent() {
        KPAnalyticManager.sendEvent(KPAnalyticsEvent.ads_click,
                                    nil)
    }
    
    
    static func sendPageViewEvent(_ pageName: String!) {
        KPAnalyticManager.sendEvent(KPAnalyticsEvent.page_event,
                                    [KPAnalyticsEventProperty.name: pageName])
    }
}
