//
//  KPNewStoreController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import GooglePlaces

class KPNewStoreController: KPNewStoreBasicController, KPSubtitleInputDelegate, KPSharedSettingDelegate {
    
    var storeNameEditor: KPTitleEditorView<UIButton>!
    
    var
        locationEditor,
        addressEditor,
        phoneEditor,
        urlEditor: KPTitleEditorView<UITextField>!
    
    var nextButton: UIButton!
    
    // MARK: - Data
    var coordinate: CLLocationCoordinate2D?
    
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
    
        
        storeNameEditor = KPTitleEditorView<UIButton>("店家名稱")
        storeNameEditor.contentView.addTarget(self,
                                              action: #selector(handleStoreNameEditButtonOnTap(_:)),
                                              for: .touchUpInside)
        storeNameEditor.contentView.setTitleColor(UIColor.black, for: .normal)
        storeNameEditor.contentView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        storeNameEditor.contentView.layer.cornerRadius = 5
        storeNameEditor.contentView.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        storeNameEditor.contentView.contentHorizontalAlignment = .left
        storeNameEditor.contentView.titleEdgeInsets.left = 10
//        storeNameEditor.contentView.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//        storeNameEditor.contentView.placeholder = "請輸入店家名稱"
        scrollContainer.addSubview(storeNameEditor)
        storeNameEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                         "V:|-20-[$self]"])
        
        
        locationEditor = KPTitleEditorView<UITextField>("所在位置")
        locationEditor.isTextFieldEditable = false
        locationEditor.textFieldTapAction = {
            
        }
        locationEditor.contentView.placeholder = "請選擇所在位置"
        scrollContainer.addSubview(locationEditor)
        locationEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                        "V:[$view0]-20-[$self]"],
                                      views: [storeNameEditor])
        
        addressEditor = KPTitleEditorView<UITextField>("地址")
        addressEditor.contentView.placeholder = "請輸入地址"
        let mapEditButton = UIButton()
        mapEditButton.setImage(#imageLiteral(resourceName: "icon_map"), for: .normal)
        mapEditButton.setTitle("使用地圖搜尋", for: .normal)
        mapEditButton.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor_light!, for: .normal)
//        mapEditButton.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor_light!.withAlphaComponent(0.1), for: .highlighted)
        mapEditButton.adjustsImageWhenHighlighted = false
        mapEditButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        mapEditButton.imageView?.tintColor = KPColorPalette.KPMainColor_v2.mainColor_light!
        mapEditButton.imageView?.contentMode = .scaleAspectFit
        mapEditButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        mapEditButton.addTarget(self, action: #selector(handleMapEditButtonOnTap(_:)), for: .touchUpInside)
        addressEditor.accessoryView = mapEditButton
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
        
        locationEditor.isHidden = true
        addressEditor.isHidden = true
        phoneEditor.isHidden = true
        urlEditor.isHidden = true
        
    }
    
    func outputValueSet(_ controller: KPSubtitleInputController) {
        if controller.isKind(of: KPSubtitleInputController.self) {
            if let place = controller.outputValue as? GMSPlace {
                
                storeNameEditor.contentView.setTitle(place.name, for: .normal)
                
                if let addressComponents = place.addressComponents {
                    for component in addressComponents {
                        if component.type == "administrative_area_level_1" {
                            locationEditor.contentView.text = component.name
                        }
                    }
                }
                
                addressEditor.contentView.text = place.formattedAddress
                phoneEditor.contentView.text = place.phoneNumber
                urlEditor.contentView.text = place.website?.absoluteString
                
                coordinate = place.coordinate
                
            } else if let placeName = controller.outputValue as? String {
                storeNameEditor.contentView.setTitle(placeName, for: .normal)
                
            }
            
            nextButton.isEnabled = true
            locationEditor.isHidden = false
            addressEditor.isHidden = false
            phoneEditor.isHidden = false
            urlEditor.isHidden = false
            
        }
    }
    
    @objc func handleLocationEditorTap() {
        print("12343334334343434fdsafdskfhuasldkfhaskdj")
    }
    
    func returnValueSet(_ controller: KPSharedSettingViewController) {
        
        if controller.isKind(of: KPMapInputViewController.self) {
            if let address = controller.returnValue as? (String, CLLocationCoordinate2D) {
                coordinate = address.1
                addressEditor.contentView.text = address.0
            }
        }
        
    }
    
//    func outputValueSet(_ controller: KPViewController, value: Any) {
//        if controller.isKind(of: KPNewStoreSearchViewController.self) {
//            if let place = value as? GMSPlace {
//
//                storeNameEditor.contentView.setTitle(place.name, for: .normal)
//
//                if let addressComponents = place.addressComponents {
//                    for component in addressComponents {
//                        if component.type == "administrative_area_level_1" {
//                            locationEditor.contentView.text = component.name
//                        }
//                    }
//                }
//
//                addressEditor.contentView.text = place.formattedAddress
//                phoneEditor.contentView.text = place.phoneNumber
//                urlEditor.contentView.text = place.website?.absoluteString
//
//                coordinate = place.coordinate
//
//            } else if let placeName = value as? String {
//                storeNameEditor.contentView.setTitle(placeName, for: .normal)
//
//            }
//
//            nextButton.isEnabled = true
//            locationEditor.isHidden = false
//            addressEditor.isHidden = false
//            phoneEditor.isHidden = false
//            urlEditor.isHidden = false
//
//        }
//    }
    
    @objc func handleStoreNameEditButtonOnTap(_ sender: UIButton) {
        let storeNameSearchController = KPSubtitleInputController()
        storeNameSearchController.delegate = self
//        let navController = UINavigationController(rootViewController: storeNameSearchController)
//        storeNameSearchController.delegate = self
        present(storeNameSearchController, animated: true, completion: nil)
    }
    
    @objc func handleMapEditButtonOnTap(_ sender: UIButton) {
        let mapEditController = KPMapInputViewController()
        mapEditController.delegate = self
        if let coordinate = coordinate ?? KPLocationManager.sharedInstance().currentLocation?.coordinate {
            mapEditController.coordinate = coordinate
        } else  {
            mapEditController.coordinate = CLLocationCoordinate2D(latitude: 25.0470462,
                                                                  longitude: 121.5156119)
        }
        present(mapEditController, animated: true, completion: nil)
    }
    
    @objc func handleNextButtonOnTap(_ sender: UIButton) {
        let detailInfoViewController = KPNewStoreDetailInfoViewController()
        detailInfoViewController.title = storeNameEditor.contentView.titleLabel?.text
        navigationController?.pushViewController(detailInfoViewController, animated: true)
    }

    @objc func handleCancelButtonOnTap(_ sender: UIBarButtonItem) {
        appModalController()?.dismissControllerWithDefaultDuration()
    }

}
