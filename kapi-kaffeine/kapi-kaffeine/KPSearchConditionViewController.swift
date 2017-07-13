//
//  KPSearchConditionViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit


struct KPSearchConditionViewControllerConstants {
    static let leftPadding = 168
}

class KPSearchConditionViewController: KPViewController {

    var dismissButton: UIButton!
    var scrollView: UIScrollView!
    var containerView: UIView!
    
    
    var ratingTitles = ["Wifi穩定", "安靜程度",
                        "價格實惠", "座位數量",
                        "咖啡品質", "餐點美味", "環境舒適"]
    
    var ratingImages = [R.image.icon_wifi(), R.image.icon_sleep(),
                        R.image.icon_money(), R.image.icon_seat(),
                        R.image.icon_cup(), R.image.icon_cutlery(),
                        R.image.icon_pic()]
    
    var ratingViews = [KPRatingView]()
    
    // Section 1
    var quickSettingLabel: UILabel!
    var quickSettingButtonOne: UIButton!
    var quickSettingButtonTwo: UIButton!
    var quickSettingButtonThree: UIButton!
    
    lazy var seperator_one: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    // Section 2
    var adjustPointLabel: UILabel!
    
    lazy var seperator_two: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    // Section 3
    var timeLimitLabel: UILabel!
    var timeRadioBoxOne: KPCheckView!
    var timeRadioBoxTwo: KPCheckView!
    var timeRadioBoxThree: KPCheckView!
    
    var socketLabel: UILabel!
    var socketRadioBoxOne: KPCheckView!
    var socketRadioBoxTwo: KPCheckView!
    var socketRadioBoxThree: KPCheckView!
    
    var businessHourLabel: UILabel!
    var businessCheckBoxOne: KPCheckView!
    var businessCheckBoxTwo: KPCheckView!
    
    var othersLabel: UILabel!
    var othersCheckBoxOne: KPCheckView!
    
    lazy var seperator_three: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        return view
    }()
    
    var searchButtonContainer: UIView!
    var searchButton: UIButton!
    
    func buttonWithTitle(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(KPColorPalette.KPTextColor.mainColor!,
                             for: .normal)
        button.setTitleColor(UIColor.white,
                             for: .selected)
        button.setBackgroundImage(UIImage(color: UIColor.white),
                                  for: .normal)
        button.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.mainColor!),
                                  for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 18.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = KPColorPalette.KPMainColor.mainColor?.cgColor
        button.layer.masksToBounds = true
        return button
    }
    
    func titleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.text = title
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = "篩選偏好設定"

        dismissButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30),
                                       image: R.image.icon_close()!)
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        dismissButton.addTarget(self,
                                     action: #selector(KPSearchConditionViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside)
        
        let barItem = UIBarButtonItem(customView: dismissButton)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        
        dismissButton.addTarget(self,
                                action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                         "H:|[$self]|"])
        scrollView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
        containerView = UIView()
        scrollView.addSubview(containerView)
        containerView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        containerView.addConstraintForHavingSameWidth(with: view)
        
        
        // Section 1
        quickSettingLabel = titleLabel("使用快速設定")
        containerView.addSubview(quickSettingLabel)
        quickSettingLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                           "V:|-16-[$self]"])
        
        quickSettingButtonOne = buttonWithTitle(title: "適合讀書工作")
        quickSettingButtonOne.addTarget(self,
                                        action: #selector(handleQuickSettingButtonOnTap(_:)),
                                        for: .touchUpInside)
        quickSettingButtonTwo = buttonWithTitle(title: "C/P值高")
        quickSettingButtonTwo.addTarget(self,
                                        action: #selector(handleQuickSettingButtonOnTap(_:)),
                                        for: .touchUpInside)
        quickSettingButtonThree = buttonWithTitle(title: "平均四分")
        quickSettingButtonThree.addTarget(self,
                                          action: #selector(handleQuickSettingButtonOnTap(_:)),
                                          for: .touchUpInside)
        containerView.addSubview(quickSettingButtonOne)
        containerView.addSubview(quickSettingButtonTwo)
        containerView.addSubview(quickSettingButtonThree)
        
        quickSettingButtonOne.addConstraints(fromStringArray: ["H:|-16-[$self(110)]",
                                                               "V:[$view0]-8-[$self(36)]"],
                                                  views: [quickSettingLabel])
        quickSettingButtonTwo.addConstraints(fromStringArray: ["H:[$view1]-8-[$self(80)]",
                                                               "V:[$view0]-8-[$self(36)]"],
                                                  views: [quickSettingLabel, quickSettingButtonOne])
        quickSettingButtonThree.addConstraints(fromStringArray: ["H:[$view1]-8-[$self(80)]",
                                                                 "V:[$view0]-8-[$self(36)]"],
                                                    views: [quickSettingLabel, quickSettingButtonTwo])
        containerView.addSubview(seperator_one)
        seperator_one.addConstraints(fromStringArray: ["H:|[$self]|",
                                                       "V:[$view0]-16-[$self(1)]"],
                                          views: [quickSettingButtonOne])
        
        
        // Section 2
        adjustPointLabel = titleLabel("調整分數至你的需求")
        containerView.addSubview(adjustPointLabel)
        adjustPointLabel.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                          "V:[$view0]-16-[$self]"],
                                             views: [seperator_one])
        
        for (index, title) in ratingTitles.enumerated() {
            let ratingView = KPRatingView(.button,
                                               ratingImages[index]!,
                                               title)
            ratingViews.append(ratingView)
            containerView.addSubview(ratingView)
            
            if index == 0 {
                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                            "V:[$view0]-24-[$self]"],
                                          views: [adjustPointLabel])
            } else {
                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                            "V:[$view0]-24-[$self]"],
                                          views: [ratingViews[index-1]])
            }
            
            ratingView.currentRate = 3
        }
        
        containerView.addSubview(seperator_two)
        seperator_two.addConstraints(fromStringArray: ["H:|[$self]|",
                                                       "V:[$view0]-16-[$self(1)]"],
                                          views: [ratingViews.last!])
        
        
        // Section 3
        timeLimitLabel = titleLabel("有無時間限制")
        containerView.addSubview(timeLimitLabel)
        timeLimitLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                        "V:[$view0]-16-[$self]"],
                                           views: [seperator_two])
        timeRadioBoxOne = KPCheckView(.radio, "不設定")
        timeRadioBoxOne.checkBox.checkState = .checked
        containerView.addSubview(timeRadioBoxOne)
        timeRadioBoxOne.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                         "V:[$view0]-16-[$self]"],
                                            views: [timeLimitLabel])
        timeRadioBoxTwo = KPCheckView(.radio, "客滿/人多限時")
        containerView.addSubview(timeRadioBoxTwo)
        timeRadioBoxTwo.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                         "V:[$view0]-16-[$self]"],
                                            views: [timeRadioBoxOne])
        timeRadioBoxThree = KPCheckView(.radio, "不限時")
        containerView.addSubview(timeRadioBoxThree)
        timeRadioBoxThree.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                           "V:[$view0]-16-[$self]"],
                                              views: [timeRadioBoxTwo])
        
        timeRadioBoxOne.checkBox.deselectCheckBoxs = [timeRadioBoxTwo.checkBox,
                                                      timeRadioBoxThree.checkBox]
        timeRadioBoxTwo.checkBox.deselectCheckBoxs = [timeRadioBoxOne.checkBox,
                                                      timeRadioBoxThree.checkBox]
        timeRadioBoxThree.checkBox.deselectCheckBoxs = [timeRadioBoxTwo.checkBox,
                                                        timeRadioBoxOne.checkBox]
        
        socketLabel = titleLabel("插座數量")
        containerView.addSubview(socketLabel)
        socketLabel.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                     "V:[$view0]-16-[$self]"],
                                        metrics:[KPSearchConditionViewControllerConstants.leftPadding],
                                        views: [seperator_two])
        
        socketRadioBoxOne = KPCheckView(.radio, "不設定")
        socketRadioBoxOne.checkBox.checkState = .checked
        containerView.addSubview(socketRadioBoxOne)
        socketRadioBoxOne.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                           "V:[$view0]-16-[$self]"],
                                              metrics:[KPSearchConditionViewControllerConstants.leftPadding],
                                              views: [socketLabel])
        socketRadioBoxTwo = KPCheckView(.radio, "部分座位有")
        containerView.addSubview(socketRadioBoxTwo)
        socketRadioBoxTwo.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                           "V:[$view0]-16-[$self]"],
                                              metrics:[KPSearchConditionViewControllerConstants.leftPadding],
                                              views: [socketRadioBoxOne])
        socketRadioBoxThree = KPCheckView(.radio, "很多插座")
        containerView.addSubview(socketRadioBoxThree)
        socketRadioBoxThree.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                             "V:[$view0]-16-[$self]"],
                                                metrics:[KPSearchConditionViewControllerConstants.leftPadding],
                                                views: [socketRadioBoxTwo])
        
        socketRadioBoxOne.checkBox.deselectCheckBoxs = [socketRadioBoxTwo.checkBox,
                                                        socketRadioBoxThree.checkBox]
        socketRadioBoxTwo.checkBox.deselectCheckBoxs = [socketRadioBoxOne.checkBox,
                                                        socketRadioBoxThree.checkBox]
        socketRadioBoxThree.checkBox.deselectCheckBoxs = [socketRadioBoxTwo.checkBox,
                                                          socketRadioBoxOne.checkBox]
        
        businessHourLabel = titleLabel("營業時間")
        containerView.addSubview(businessHourLabel)
        businessHourLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                           "V:[$view0]-24-[$self]"],
                                              views: [timeRadioBoxThree])
        
        businessCheckBoxOne = KPCheckView(.radio, "目前營業中")
        businessCheckBoxOne.checkBox.checkState = .checked
        containerView.addSubview(businessCheckBoxOne)
        businessCheckBoxOne.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                             "V:[$view0]-16-[$self]"],
                                                views: [businessHourLabel])
        
        businessCheckBoxTwo = KPCheckView(.radio, "特定營業時段")
        containerView.addSubview(businessCheckBoxTwo)
        businessCheckBoxTwo.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                             "V:[$view0]-16-[$self]-88-|"],
                                                views: [businessCheckBoxOne])
        
        businessCheckBoxOne.checkBox.deselectCheckBoxs = [businessCheckBoxTwo.checkBox]
        businessCheckBoxTwo.checkBox.deselectCheckBoxs = [businessCheckBoxOne.checkBox]
        othersLabel = titleLabel("其他選項")
        containerView.addSubview(othersLabel)
        othersLabel.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                     "V:[$view0]-24-[$self]"],
                                        metrics:[KPSearchConditionViewControllerConstants.leftPadding],
                                        views: [timeRadioBoxThree])
        othersCheckBoxOne = KPCheckView(.checkmark, "可站立工作")
        containerView.addSubview(othersCheckBoxOne)
        othersCheckBoxOne.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                           "V:[$view0]-16-[$self]"],
                                              metrics:[KPSearchConditionViewControllerConstants.leftPadding],
                                              views: [othersLabel])
        
        
        searchButtonContainer = UIView()
        searchButtonContainer.backgroundColor = UIColor.white
        view.addSubview(searchButtonContainer)
        searchButtonContainer.addConstraints(fromStringArray: ["V:[$self]|",
                                                               "H:|[$self]|"])
        searchButtonContainer.addSubview(seperator_three)
        seperator_three.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self(1)]"],
                                       views: [businessCheckBoxTwo])
        
        searchButton = UIButton()
        searchButton.setTitle("開始搜尋", for: .normal)
        searchButton.setTitleColor(UIColor.white, for: .normal)
        searchButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.mainColor!),
                                                for: .normal)
        searchButton.layer.cornerRadius = 4.0
        searchButton.layer.masksToBounds = true
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        searchButtonContainer.addSubview(searchButton)
        searchButton.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(40)]-16-|",
                                                      "H:|-16-[$self]-16-|"],
                                         views: [seperator_three])
        searchButton.addTarget(self, action: #selector(showTimePicker), for: .touchUpInside)
    }
    
    func showTimePicker() {
        let controller = KPModalViewController()
        controller.edgeInset = UIEdgeInsets(top: 32,
                                            left: 0,
                                            bottom: 0,
                                            right: 0)
        let timePickerController = KPBusinessHourViewController()
        controller.contentController = timePickerController
        controller.cornerRadius = [.topRight, .topLeft]
        controller.presentModalView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleDismissButtonOnTapped() {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    func handleQuickSettingButtonOnTap(_ sender: UIButton) {
        if sender == quickSettingButtonOne {
            quickSettingButtonOne.isSelected = true
            quickSettingButtonTwo.isSelected = false
            quickSettingButtonThree.isSelected = false
            ratingViews[0].currentRate = 4
            ratingViews[1].currentRate = 3
            ratingViews[2].currentRate = 3
            ratingViews[3].currentRate = 4
            ratingViews[4].currentRate = 3
            ratingViews[5].currentRate = 3
            ratingViews[6].currentRate = 4
        } else if sender == quickSettingButtonTwo {
            quickSettingButtonOne.isSelected = false
            quickSettingButtonTwo.isSelected = true
            quickSettingButtonThree.isSelected = false
            ratingViews[0].currentRate = 3
            ratingViews[1].currentRate = 3
            ratingViews[2].currentRate = 4
            ratingViews[3].currentRate = 3
            ratingViews[4].currentRate = 4
            ratingViews[5].currentRate = 3
            ratingViews[6].currentRate = 4
        } else if sender == quickSettingButtonThree {
            quickSettingButtonOne.isSelected = false
            quickSettingButtonTwo.isSelected = false
            quickSettingButtonThree.isSelected = true
            ratingViews[0].currentRate = 4
            ratingViews[1].currentRate = 4
            ratingViews[2].currentRate = 4
            ratingViews[3].currentRate = 4
            ratingViews[4].currentRate = 4
            ratingViews[5].currentRate = 4
            ratingViews[6].currentRate = 4
        }
    }
    

}
