//
//  KPNewStoreController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/17.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation

class KPNewStoreController: KPNewStoreBasicController, KPSubtitleInputDelegate, KPSharedSettingDelegate {
    
    var storeNameEditor,
        locationEditor,
        addressEditor,
        phoneEditor,
        urlEditor: KPTitleEditorView<UITextField>!
    
    var nextButton: UIButton!
    
    // MARK: - Data
    var coordinate: CLLocationCoordinate2D?
    var city: CityData?
    var country: CountryData?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        title = "新增店家"
        
        let barLeftItem = UIBarButtonItem(title: "取消",
                                          style: .plain,
                                          target: self,
                                          action: #selector(handleCancelButtonOnTap(_:)))
        barLeftItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.mainContent), NSAttributedStringKey.foregroundColor: UIColor.gray],
                                           for: .normal)
        
        navigationItem.leftBarButtonItem = barLeftItem
    
        
        storeNameEditor = KPTitleEditorView<UITextField>("店家名稱")
        storeNameEditor.contentView.placeholder = "請輸入店家名稱"
        storeNameEditor.isTextFieldEditable = false
        storeNameEditor.textFieldTapAction = { [weak self] in
            guard let `self` = self else { return }
            let storeNameSearchController = KPSubtitleInputController()
            if let oldContent = self.storeNameEditor.contentView.text {
                storeNameSearchController.oldContent = oldContent
            }
            storeNameSearchController.delegate = self
            self.present(storeNameSearchController, animated: true, completion: nil)
        }
        scrollContainer.addSubview(storeNameEditor)
        storeNameEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                         "V:|-20-[$self]"])
        
        
        locationEditor = KPTitleEditorView<UITextField>("所在城市")
        locationEditor.isTextFieldEditable = false
        locationEditor.textFieldTapAction = { [weak self] in
            guard let `self` = self else { return }
            let locationController = KPLocationSelectViewController()
            let navigationController = UINavigationController(rootViewController: locationController)
            locationController.delegate = self
            self.present(navigationController, animated: true, completion: nil)
        }
        locationEditor.contentView.placeholder = "請選擇所在城市"
        scrollContainer.addSubview(locationEditor)
        locationEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                        "V:[$view0]-20-[$self]"],
                                      views: [storeNameEditor])
        
        addressEditor = KPTitleEditorView<UITextField>("地址")
        addressEditor.contentView.placeholder = "請輸入地址"
        let mapEditButton = UIButton()
        mapEditButton.setImage(R.image.icon_pin_fill(), for: .normal)
        mapEditButton.setTitle("使用地圖搜尋", for: .normal)
        mapEditButton.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor_light!, for: .normal)
        mapEditButton.adjustsImageWhenHighlighted = false
        mapEditButton.titleLabel?.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        mapEditButton.imageView?.tintColor = KPColorPalette.KPMainColor_v2.mainColor_light!
        mapEditButton.imageView?.contentMode = .scaleAspectFit
        mapEditButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        mapEditButton.addTarget(self, action: #selector(handleMapEditButtonOnTap(_:)), for: .touchUpInside)
        addressEditor.accessoryView = mapEditButton
        scrollContainer.addSubview(addressEditor)
        addressEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|",
                                                       "V:[$view0]-20-[$self]"],
                                      views: [locationEditor])
        addressEditor.contentView.addTarget(self, action: #selector(addressDidChanged(_:)), for: .editingChanged)
        
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
        nextButton.setTitleColor(KPColorPalette.KPMainColor_v2.grayColor_level4,
                                 for: .disabled)
        nextButton.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor,
                                 for: .normal)
        nextButton.setTitle("下一步", for: .normal)
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = KPLayoutConstant.corner_radius
        nextButton.layer.borderWidth = 1.0
        nextButton.layer.borderColor = KPColorPalette.KPMainColor_v2.mainColor?.cgColor
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        buttonContainer.addSubview(nextButton)
        nextButton.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                    "V:|-12-[$self(40)]-12-|"])
        nextButton.addTarget(self, action: #selector(KPNewStoreController.handleNextButtonOnTap(_:)), for: .touchUpInside)
        
        locationEditor.isHidden = true
        addressEditor.isHidden = true
        phoneEditor.isHidden = true
        urlEditor.isHidden = true
        
    }
    
    func outputValueSet(_ controller: KPSubtitleInputController) {
        if controller.isKind(of: KPSubtitleInputController.self) {
            if let place = controller.outputValue as? GMSPlace {

                storeNameEditor.contentView.text = place.name
                
                addressEditor.contentView.text = place.formattedAddress
                phoneEditor.contentView.text = place.phoneNumber
                urlEditor.contentView.text = place.website?.absoluteString
                
                coordinate = place.coordinate
                
                locationEditor.isHidden = false
                addressEditor.isHidden = false
                phoneEditor.isHidden = false
                urlEditor.isHidden = false
                
            } else if let placeName = controller.outputValue as? String {
                storeNameEditor.contentView.text = placeName
                locationEditor.isHidden = !(placeName.count > 0)
                addressEditor.isHidden = !(placeName.count > 0)
                phoneEditor.isHidden = !(placeName.count > 0)
                urlEditor.isHidden = !(placeName.count > 0)
            } else {
                locationEditor.isHidden = true
                addressEditor.isHidden = true
                phoneEditor.isHidden = true
                urlEditor.isHidden = true
            }
        }
    }
    
    func returnValueSet(_ controller: KPSharedSettingViewController) {
        
        if controller.isKind(of: KPMapInputViewController.self) {
            if let address = controller.returnValue as? (String, CLLocationCoordinate2D) {
                coordinate = address.1
                addressEditor.contentView.text = address.0
            }
        } else if controller.isKind(of: KPCountrySelectController.self) {
            if let region = controller.returnValue as? String {
                locationEditor.contentView.text = region
            }
        }
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
        
        guard let storeName = storeNameEditor.contentView.text, !storeName.isEmpty else {
            popoverErrorView(storeNameEditor.title)
            return
        }
        
        guard let address = addressEditor.contentView.text, !address.isEmpty else {
            popoverErrorView(addressEditor.title)
            return
        }
        
        guard let coordinate = coordinate else {
            popoverErrorView(addressEditor.title)
            return
        }
        
        guard let city = city, let country = country else {
            popoverErrorView(locationEditor.title)
            return
        }
                
        let dataModel = KPUploadDataModel(storeName,
                                          coordinate,
                                          address,
                                          city.key,
                                          country.key)
        
        // TODO: 所在城市
        
        
        if let phone = phoneEditor.contentView.text,
            !phone.isEmpty {
            dataModel.phone = phone
        }
        
        if let url = urlEditor.contentView.text,
            !url.isEmpty {
            dataModel.url = url
        }
        
        
        let detailInfoViewController = KPNewStoreDetailInfoViewController(dataModel)
        detailInfoViewController.title = storeNameEditor.contentView.text
        navigationController?.pushViewController(detailInfoViewController, animated: true)
    }

    @objc func handleCancelButtonOnTap(_ sender: UIBarButtonItem) {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    func popoverErrorView(_ editor: String) {
        let content = KPNotificationPopoverContent()
        content.titleLabel.text = "\(editor) 尚未填寫"
        content.descriptionLabel.text = "店家名稱、所在城市、地址為必填選項！"
        KPPopoverView.sharedPopoverView.contentView = content
        KPPopoverView.sharedPopoverView.popoverContent()
    }
    
    @objc func addressDidChanged(_ sender: UITextField) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(sender.text!) { [weak self] (placemarks, error) in
            guard
                let `self` = self,
                let placemarks = placemarks,
                let coordinate = placemarks.first?.location?.coordinate
                else {
                    // handle no location found
                    return
            }
            // Use your location
            self.coordinate = coordinate

        }
    }
    
}

extension KPNewStoreController: KPLocationSelectViewControllerDelegate {
    
    func locationSelectController(_ controller: KPLocationSelectViewController, selectedCountry: CountryData, selectedCity: CityData) {
        country = selectedCountry
        city = selectedCity
        locationEditor.contentView.text = city?.name
        dismiss(animated: true, completion: nil)
    }
    
}
