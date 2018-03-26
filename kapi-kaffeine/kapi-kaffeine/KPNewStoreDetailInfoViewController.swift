//
//  KPNewStoreDetailInfoViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 25/01/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPNewStoreDetailInfoViewController: KPNewStoreBasicController {
    
//    fileprivate var scrollView: UIScrollView!
//    fileprivate var scrollContainer: UIView!
    
    fileprivate var comsumptionInfoButton: KPNewStoreDetailCheckButton!
    fileprivate var businessTimeButton: KPNewStoreDetailCheckButton!
    fileprivate var additionalInfoButton: KPNewStoreDetailCheckButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let barLeftItem = UIBarButtonItem(title: "取消",
                                          style: .plain,
                                          target: self,
                                          action: #selector(handleCancelButtonOnTap(_:)))
        barLeftItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.mainContent), NSAttributedStringKey.foregroundColor: UIColor.gray],
                                           for: .normal)
        
        navigationItem.leftBarButtonItem = barLeftItem
        
        
        let detailTitleLabel = UILabel()
        detailTitleLabel.text = "提供店家相關資訊"
        detailTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
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
        
        
        
        let photoUploadView = KPTitleEditorView<KPPhotoUploadView>("上傳照片")
        scrollContainer.addSubview(photoUploadView)
        photoUploadView.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:[$view0]-20-[$self]"],
                                       views: [additionalInfoButton])
        
        let menuUploadView = KPTitleEditorView<KPPhotoUploadView>("上傳菜單")
        scrollContainer.addSubview(menuUploadView)
        menuUploadView.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:[$view0]-20-[$self]|"],
                                      views: [photoUploadView])
        
        
        
        let submitButton = UIButton(type: .custom)
        submitButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.greenColor!), for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("確認新增", for: .normal)
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 3
        buttonContainer.addSubview(submitButton)
        submitButton.addConstraints(fromStringArray: ["H:[$self]-16-|", "V:|-10-[$self]-10-|"])
        submitButton.addTarget(self, action: #selector(KPNewStoreDetailInfoViewController.handleSubmitButtonOnTap(_:)), for: .touchUpInside)
        
        let backButton = UIButton(type: .custom)
        backButton.setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_description!, for: .normal)
        backButton.setTitle("上一步", for: .normal)
        buttonContainer.addSubview(backButton)
        backButton.addConstraints(fromStringArray: ["H:|-16-[$self]-[$view0]", "V:|-10-[$self]-10-|"],
                                  views: [submitButton])
        backButton.addConstraintForHavingSameWidth(with: submitButton)
        backButton.addTarget(self, action: #selector(KPNewStoreDetailInfoViewController.handleBackButtonOnTap(_:)), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleBackButtonOnTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @objc func handleSubmitButtonOnTap(_ sender: UIButton) {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    @objc func handleCancelButtonOnTap(_ sender: UIBarButtonItem) {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    @objc func handleInfoButtonOnTap(_ sender: KPNewStoreDetailCheckButton) {
        if sender == comsumptionInfoButton {
            let consumption = KPConsumptionInfoViewController()
            consumption.title = title
            navigationController?.pushViewController(consumption, animated: true)
        } else if sender == businessTimeButton {
            let businessHours = KPBusinessHoursEditorController()
            businessHours.title = title
            navigationController?.pushViewController(businessHours, animated: true)
        } else if sender == additionalInfoButton {
            let controller = KPOtherOptionViewController()
            controller.title = title
            navigationController?.pushViewController(controller, animated: true)
        }
    }

}
