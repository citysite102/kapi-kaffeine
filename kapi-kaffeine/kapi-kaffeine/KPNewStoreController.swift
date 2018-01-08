//
//  KPNewStoreController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import GooglePlaces

struct KPNewStoreControllerConstants {
    static let leftPadding = 168
}

class KPNewStoreController: KPViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "新增店家"
        view.backgroundColor = UIColor.white
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(handleCancelButtonOnTap(_:)))
        navigationItem.leftBarButtonItem = cancelButton
        
        
        let storeNameEditor = KPEditorView(type: .Text,title: "店家名稱")
        view.addSubview(storeNameEditor)
        storeNameEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:|-20-[$self]"])
        
        let locationEditor = KPEditorView(type: .Custom,title: "所在城市")
        view.addSubview(locationEditor)
        locationEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:[$view0]-20-[$self]"],
                                      views: [storeNameEditor])
        
    }

    @objc func handleCancelButtonOnTap(_ sender: UIBarButtonItem) {
        self.appModalController()?.dismissControllerWithDefaultDuration()
    }

}
