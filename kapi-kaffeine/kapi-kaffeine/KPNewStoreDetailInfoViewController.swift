//
//  KPNewStoreDetailInfoViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 25/01/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPNewStoreDetailInfoViewController: KPViewController {
    
    fileprivate var scrollView: UIScrollView!
    fileprivate var scrollContainerView: UIView!
    
    fileprivate var comsumptionInfoButton: KPNewStoreDetailCheckButton!
    fileprivate var businessTimeButton: KPNewStoreDetailCheckButton!
    fileprivate var additionalInfoButton: KPNewStoreDetailCheckButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        //        navigationController?.navigationBar.shadowImage = UIImage()
        
        let barLeftItem = UIBarButtonItem(title: "取消",
                                          style: .plain,
                                          target: self,
                                          action: #selector(handleCancelButtonOnTap(_:)))
        barLeftItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.gray],
                                           for: .normal)
        
        navigationItem.leftBarButtonItem = barLeftItem
        
        let buttonContainer = UIView()
        buttonContainer.backgroundColor = UIColor.white
        view.addSubview(buttonContainer)
        
        buttonContainer.addConstraints(fromStringArray: ["H:|-(-1)-[$self]-(-1)-|", "V:[$self(60)]"])
        buttonContainer.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        buttonContainer.layer.borderColor = KPColorPalette.KPBackgroundColor.grayColor_level6?.cgColor
        buttonContainer.layer.borderWidth = 1
        
        
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        scrollView.addConstraint(from: "V:[$self][$view0]", views:[buttonContainer])
        if #available(iOS 11.0, *) {
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        } else {
            scrollView.addConstraint(from: "H:|[$self]|")
        }

        
        
        scrollContainerView = UIView()
        scrollView.addSubview(scrollContainerView)
        scrollContainerView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        scrollContainerView.addConstraintForHavingSameWidth(with: scrollView)
        
        
        let detailTitleLabel = UILabel()
        detailTitleLabel.text = "提供店家相關資訊"
        detailTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        scrollContainerView.addSubview(detailTitleLabel)
        detailTitleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]|", "V:|-20-[$self]"])
        
        
        comsumptionInfoButton = KPNewStoreDetailCheckButton("消費體驗資訊")
        comsumptionInfoButton.addTarget(self,
                                        action: #selector(KPNewStoreDetailInfoViewController.handleInfoButtonOnTap(_:)),
                                        for: .touchUpInside)
        scrollContainerView.addSubview(comsumptionInfoButton)
        comsumptionInfoButton.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0]-20-[$self(70)]"],
                                           views: [detailTitleLabel])
        
        businessTimeButton = KPNewStoreDetailCheckButton("店家營業時間")
        businessTimeButton.addTarget(self,
                                    action: #selector(KPNewStoreDetailInfoViewController.handleInfoButtonOnTap(_:)),
                                    for: .touchUpInside)
        scrollContainerView.addSubview(businessTimeButton)
        businessTimeButton.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self(70)]"],
                                          views: [comsumptionInfoButton])
        
        additionalInfoButton = KPNewStoreDetailCheckButton("提供設備")
        additionalInfoButton.addTarget(self,
                                       action: #selector(KPNewStoreDetailInfoViewController.handleInfoButtonOnTap(_:)),
                                       for: .touchUpInside)
        scrollContainerView.addSubview(additionalInfoButton)
        additionalInfoButton.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self(70)]"],
                                        views: [businessTimeButton])
        
        
        
        let photoUploadView = KPPhotoUploadView("上傳照片")
        scrollContainerView.addSubview(photoUploadView)
        photoUploadView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self]"],
                                       views: [additionalInfoButton])
        
        let menuUploadView = KPPhotoUploadView("上傳菜單")
        scrollContainerView.addSubview(menuUploadView)
        menuUploadView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self]|"],
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
            
        } else if sender == additionalInfoButton {
            
        }
    }

}
