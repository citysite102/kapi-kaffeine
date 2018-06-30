//
//  KPSchemeHandler.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/10/8.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation

class KPSchemeHandler: KPMainViewControllerDelegate {
    
    
    let defaultCustomScheme = [
        "coffeeshop"
    ]
    
    static let sharedHandler = KPSchemeHandler()
    
    var currentDataModel: KPDataModel?
    var selectedDataModel: KPDataModel? {
        return currentDataModel
    }

    
    func shouldHandleURLScheme(_ url: URL) -> Bool {
        return defaultCustomScheme.contains(url.scheme ?? "")
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
        
        if let identifier = parameters["cafe_id"] as String? {
            KPServiceHandler.sharedHandler.fetchSimpleStoreInformation(identifier, { (result) in
                if result != nil {
                    self.currentDataModel = result
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let rootViewController = appDelegate.window?.rootViewController as! KPMainViewController
                    rootViewController.performSegue(withIdentifier: "datailedInformationSegue", sender: self)
                    
                }
            })
        }
        
        
        return true
    }
}

