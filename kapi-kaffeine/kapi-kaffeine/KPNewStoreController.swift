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
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = "新增店家"
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let barLeftItem = UIBarButtonItem(title: "取消",
                                          style: .plain,
                                          target: self,
                                          action: #selector(handleCancelButtonOnTap(_:)))
        barLeftItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.gray],
                                           for: .normal)
        
        navigationItem.leftBarButtonItem = barLeftItem
    
        
        
        let storeNameEditor = KPEditorView(type: .Text,
                                           title: "店家名稱" ,
                                           placeHolder: "請輸入店家名稱")
        view.addSubview(storeNameEditor)
        storeNameEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                         "V:|-20-[$self]"])
        
        let locationEditor = KPEditorView(type: .Custom,
                                          title: "所在位置",
                                          placeHolder: "請選擇所在位置")
        view.addSubview(locationEditor)
        locationEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                        "V:[$view0]-20-[$self]"],
                                      views: [storeNameEditor])
        
    }

    @objc func handleCancelButtonOnTap(_ sender: UIBarButtonItem) {
        self.appModalController()?.dismissControllerWithDefaultDuration()
    }

}
