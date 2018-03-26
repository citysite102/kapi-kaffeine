//
//  KPNewStoreController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import GooglePlaces

class KPNewStoreController: KPNewStoreBasicController, KPSubtitleInputDelegate {
    
    func outputValueSet<GMSPlace>(_ controller: KPViewController, value: GMSPlace) {
        if controller.isKind(of: KPNewStoreSearchViewController.self) {
            
        }
    }
    
    var storeNameEditor,
        locationEditor,
        addressEditor,
        phoneEditor,
        urlEditor: KPTitleEditorView<UITextField>!
    
    var nextButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        title = "新增店家"
//        navigationController?.navigationBar.shadowImage = UIImage()
        
        let barLeftItem = UIBarButtonItem(title: "取消",
                                          style: .plain,
                                          target: self,
                                          action: #selector(handleCancelButtonOnTap(_:)))
        barLeftItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.mainContent), NSAttributedStringKey.foregroundColor: UIColor.gray],
                                           for: .normal)
        
        navigationItem.leftBarButtonItem = barLeftItem
    
        
        storeNameEditor = KPTitleEditorView<UITextField>("店家名稱")
        storeNameEditor.contentView.placeholder = "請輸入店家名稱"
        scrollContainer.addSubview(storeNameEditor)
        storeNameEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                         "V:|-20-[$self]"])
        
        storeNameEditor.contentView.addTarget(self, action: #selector(KPNewStoreController.handleStoreNameDidChanged(_:)), for: .editingChanged)
        
        
        locationEditor = KPTitleEditorView<UITextField>("所在位置")
        locationEditor.contentView.placeholder = "請選擇所在位置"
        scrollContainer.addSubview(locationEditor)
        locationEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                        "V:[$view0]-20-[$self]"],
                                      views: [storeNameEditor])
        
        addressEditor = KPTitleEditorView<UITextField>("地址")
        addressEditor.contentView.placeholder = "請輸入地址"
        scrollContainer.addSubview(addressEditor)
        addressEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                       "V:[$view0]-20-[$self]"],
                                      views: [locationEditor])
        
        phoneEditor = KPTitleEditorView<UITextField>("聯絡電話")
        phoneEditor.contentView.placeholder = "請輸入聯絡電話"
        scrollContainer.addSubview(phoneEditor)
        phoneEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                     "V:[$view0]-20-[$self]"],
                                      views: [addressEditor])
        
        urlEditor = KPTitleEditorView<UITextField>("網址或Facebook")
        scrollContainer.addSubview(urlEditor)
        urlEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                   "V:[$view0]-20-[$self]-20-|"],
                                      views: [phoneEditor])
        
        
        nextButton = UIButton(type: .custom)
//        nextButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.greenColor!), for: .normal)
//        nextButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.grayColor_level4!), for: .disabled)
        nextButton.setTitleColor(KPColorPalette.KPMainColor_v2.grayColor_level4,
                                 for: .disabled)
        nextButton.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor,
                                 for: .normal)
        nextButton.setTitle("下一步", for: .normal)
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = 4.0
        nextButton.layer.borderWidth = 1.0
        nextButton.layer.borderColor = KPColorPalette.KPMainColor_v2.grayColor_level4?.cgColor
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        buttonContainer.addSubview(nextButton)
        nextButton.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                    "V:|-12-[$self(40)]-12-|"])
        nextButton.addTarget(self, action: #selector(KPNewStoreController.handleNextButtonOnTap(_:)), for: .touchUpInside)
        
        nextButton.isEnabled = false
        
        
    }
    
    @objc func handleNextButtonOnTap(_ sender: UIButton) {
        let detailInfoViewController = KPNewStoreDetailInfoViewController()
        detailInfoViewController.title = storeNameEditor.contentView.text
        navigationController?.pushViewController(detailInfoViewController, animated: true)
    }

    @objc func handleCancelButtonOnTap(_ sender: UIBarButtonItem) {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    @objc func handleStoreNameDidChanged(_ sender: UITextField) {
        nextButton.isEnabled = !sender.text!.isEmpty
    }

}
