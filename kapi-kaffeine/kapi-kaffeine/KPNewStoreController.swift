//
//  KPNewStoreController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import GooglePlaces

class KPNewStoreController: KPViewController, KPSubtitleInputDelegate {
    
    func outputValueSet<GMSPlace>(_ controller: KPViewController, value: GMSPlace) {
        if controller.isKind(of: KPNewStoreSearchViewController.self) {
            
        }
    }
    
    var storeNameEditor,
        locationEditor,
        addressEditor,
        phoneEditor,
        urlEditor: KPEditorView!
    
    var scrollContainer: UIView!
    var scrollView: UIScrollView!
    var buttonContainer: UIView!
    
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
        barLeftItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.gray],
                                           for: .normal)
        
        navigationItem.leftBarButtonItem = barLeftItem
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = KPColorPalette.KPMainColor_v2.whiteColor_level1
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        scrollView.addConstraint(from: "H:|[$self]|")
        
        scrollContainer = UIView()
        scrollContainer.backgroundColor = KPColorPalette.KPMainColor_v2.whiteColor_level1
        scrollView.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        scrollContainer.addConstraintForHavingSameWidth(with: view)
        
        buttonContainer = UIView()
        buttonContainer.backgroundColor = KPColorPalette.KPMainColor_v2.whiteColor_level1
        view.addSubview(buttonContainer)
        buttonContainer.layer.borderColor = KPColorPalette.KPBackgroundColor.grayColor_level6?.cgColor
        buttonContainer.layer.borderWidth = 1
        
        buttonContainer.addConstraints(fromStringArray: ["H:|-(-1)-[$self]-(-1)-|", "V:[$view0][$self]"],
                                       views: [scrollView])
        buttonContainer.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
    
        
        storeNameEditor = KPEditorView(type: .Text,
                                       title: "店家名稱" ,
                                       placeHolder: "請輸入店家名稱")
        scrollContainer.addSubview(storeNameEditor)
        storeNameEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                         "V:|-20-[$self]"])
        
        storeNameEditor.textField.addTarget(self, action: #selector(KPNewStoreController.handleStoreNameDidChanged(_:)), for: .editingChanged)
        
        locationEditor = KPEditorView(type: .Text,
                                          title: "所在位置",
                                          placeHolder: "請選擇所在位置")
        scrollContainer.addSubview(locationEditor)
        locationEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                        "V:[$view0]-20-[$self]"],
                                      views: [storeNameEditor])
        
        addressEditor = KPEditorView(type: .Text,
                                     title: "地址",
                                     placeHolder: "請輸入地址")
        scrollContainer.addSubview(addressEditor)
        addressEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                       "V:[$view0]-20-[$self]"],
                                      views: [locationEditor])
        
        phoneEditor = KPEditorView(type: .Text,
                                   title: "聯絡電話",
                                   placeHolder: "請輸入聯絡電話")
        scrollContainer.addSubview(phoneEditor)
        phoneEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                     "V:[$view0]-20-[$self]"],
                                      views: [addressEditor])
        
        urlEditor = KPEditorView(type: .Text,
                                 title: "網址或Facebook",
                                 placeHolder: "")
        scrollContainer.addSubview(urlEditor)
        urlEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                   "V:[$view0]-20-[$self]-20-|"],
                                      views: [phoneEditor])
        
        
        nextButton = UIButton(type: .custom)
        nextButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.greenColor!), for: .normal)
        nextButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.grayColor_level4!), for: .disabled)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.setTitle("下一步", for: .normal)
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = 4.0
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        buttonContainer.addSubview(nextButton)
        nextButton.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|", "V:|-16-[$self(40)]-16-|"])
        nextButton.addTarget(self, action: #selector(KPNewStoreController.handleNextButtonOnTap(_:)), for: .touchUpInside)
        
        nextButton.isEnabled = false
        
    }
    
    @objc func handleNextButtonOnTap(_ sender: UIButton) {
        let detailInfoViewController = KPNewStoreDetailInfoViewController()
        detailInfoViewController.title = storeNameEditor.textField.text
        navigationController?.pushViewController(detailInfoViewController, animated: true)
    }

    @objc func handleCancelButtonOnTap(_ sender: UIBarButtonItem) {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    @objc func handleStoreNameDidChanged(_ sender: UITextField) {
        nextButton.isEnabled = !sender.text!.isEmpty
    }

}
