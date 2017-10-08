//
//  KPSchemeHandler.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/10/8.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation

class KPSchemeHandler {
    
    let defaultCustomScheme = [
        "coffeeshop://"
    ]
    
    static let sharedHandler = KPSchemeHandler()
    
    func shouldHandleURLScheme(_ url: URL) -> Bool {
        return defaultCustomScheme.contains(url.absoluteString)
    }
    
    
    func handleURLScheme(_ url: URL) -> Bool {
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else {
                return true
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        
        return true
    }
}

