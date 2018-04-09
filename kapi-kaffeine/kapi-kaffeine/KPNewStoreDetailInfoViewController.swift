//
//  KPNewStoreDetailInfoViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 25/01/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPNewStoreDetailInfoViewController: KPNewStoreBasicController {
    
    fileprivate var comsumptionInfoButton: KPNewStoreDetailCheckButton!
    fileprivate var businessTimeButton: KPNewStoreDetailCheckButton!
    fileprivate var additionalInfoButton: KPNewStoreDetailCheckButton!
    
    fileprivate let photoUploadView = KPTitleEditorView<KPPhotoUploadView>("上傳照片")
    fileprivate let menuUploadView = KPTitleEditorView<KPPhotoUploadView>("上傳菜單")
    
    var uploadData: KPUploadDataModel
    
    init(_ data: KPUploadDataModel) {
        uploadData = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let barLeftItem = UIBarButtonItem(title: "上一步",
                                          style: .plain,
                                          target: self,
                                          action: #selector(handleCancelButtonOnTap(_:)))
        barLeftItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.mainContent), NSAttributedStringKey.foregroundColor: UIColor.gray],
                                           for: .normal)
        
        navigationItem.leftBarButtonItem = barLeftItem
        
        
        let detailTitleLabel = UILabel()
        detailTitleLabel.text = "提供店家相關資訊"
        detailTitleLabel.font = UIFont.boldSystemFont(ofSize: KPFontSize.sub_header)
        detailTitleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_title
        scrollContainer.addSubview(detailTitleLabel)
        detailTitleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]|", "V:|-20-[$self]"])
        
        
        comsumptionInfoButton = KPNewStoreDetailCheckButton("消費體驗資訊")
        comsumptionInfoButton.addTarget(self,
                                        action: #selector(KPNewStoreDetailInfoViewController.handleInfoButtonOnTap(_:)),
                                        for: .touchUpInside)
        scrollContainer.addSubview(comsumptionInfoButton)
        comsumptionInfoButton.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0]-20-[$self(70)]"],
                                           views: [detailTitleLabel])
        
        businessTimeButton = KPNewStoreDetailCheckButton("店家營業時間")
        businessTimeButton.addTarget(self,
                                    action: #selector(KPNewStoreDetailInfoViewController.handleInfoButtonOnTap(_:)),
                                    for: .touchUpInside)
        scrollContainer.addSubview(businessTimeButton)
        businessTimeButton.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self(70)]"],
                                          views: [comsumptionInfoButton])
        
        additionalInfoButton = KPNewStoreDetailCheckButton("提供設備")
        additionalInfoButton.addTarget(self,
                                       action: #selector(KPNewStoreDetailInfoViewController.handleInfoButtonOnTap(_:)),
                                       for: .touchUpInside)
        scrollContainer.addSubview(additionalInfoButton)
        additionalInfoButton.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self(70)]"],
                                        views: [businessTimeButton])
        
        
        scrollContainer.addSubview(photoUploadView)
        photoUploadView.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:[$view0]-20-[$self]"],
                                       views: [additionalInfoButton])
        
        scrollContainer.addSubview(menuUploadView)
        menuUploadView.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:[$view0]-20-[$self]|"],
                                      views: [photoUploadView])
        
        
        
        let submitButton = UIButton(type: .custom)
        submitButton.setTitleColor(KPColorPalette.KPMainColor_v2.grayColor_level4,
                                   for: .disabled)
        submitButton.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor,
                                   for: .normal)
        submitButton.setTitle("確認新增", for: .normal)
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 4.0
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.borderColor = KPColorPalette.KPMainColor_v2.grayColor_level4?.cgColor
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        buttonContainer.addSubview(submitButton)
        submitButton.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                    "V:|-12-[$self(40)]-12-|"])
        submitButton.addTarget(self, action: #selector(KPNewStoreDetailInfoViewController.handleSubmitButtonOnTap(_:)), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleBackButtonOnTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc func handleSubmitButtonOnTap(_ sender: UIButton) {
        
        uploadData.photos = photoUploadView.contentView.photos
        uploadData.menuPhotos = menuUploadView.contentView.photos
        
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    @objc func handleCancelButtonOnTap(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleInfoButtonOnTap(_ sender: KPNewStoreDetailCheckButton) {
        if sender == comsumptionInfoButton {
            let consumptionController = KPConsumptionInfoViewController(uploadData)
            navigationController?.pushViewController(consumptionController, animated: true)
        } else if sender == businessTimeButton {
            let businessHoursController = KPBusinessHoursEditorController(uploadData)
            navigationController?.pushViewController(businessHoursController, animated: true)
        } else if sender == additionalInfoButton {
            let otherOptionController = KPOtherOptionViewController(uploadData)
            navigationController?.pushViewController(otherOptionController, animated: true)
        }
    }

}
