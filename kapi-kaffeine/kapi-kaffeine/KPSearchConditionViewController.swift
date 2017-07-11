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
        view.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
        return view
    }()
    
    // Section 2
    var adjustPointLabel: UILabel!
    
    lazy var seperator_two: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
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
        view.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
        return view
    }()
    
    var searchButton: UIButton!
    
    func buttonWithTitle(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(KPColorPalette.KPMainColor.mainColor!,
                             for: .normal)
        button.setTitleColor(UIColor.white,
                             for: .selected)
        button.setBackgroundImage(UIImage(color: UIColor.white),
                                  for: .normal)
        button.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor.mainColor!),
                                  for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 18.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = KPColorPalette.KPMainColor.mainColor?.cgColor
        return button
    }
    
    func titleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPMainColor.mainColor
        label.text = title
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = "篩選偏好設定"

        dismissButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30),
                                       image: R.image.icon_close()!)
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7)
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
        quickSettingButtonTwo = buttonWithTitle(title: "C/P值高")
        quickSettingButtonThree = buttonWithTitle(title: "平均四分")
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
        
        socketLabel = titleLabel("插座數量")
        containerView.addSubview(socketLabel)
        socketLabel.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                          "V:[$view0]-16-[$self]"],
                                        metrics:[KPSearchConditionViewControllerConstants.leftPadding],
                                        views: [seperator_two])
        
        socketRadioBoxOne = KPCheckView(.radio, "不設定")
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
        
        businessHourLabel = titleLabel("營業時間")
        containerView.addSubview(businessHourLabel)
        businessHourLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                "V:[$view0]-24-[$self]"],
                                              views: [timeRadioBoxThree])
        
        businessCheckBoxOne = KPCheckView(.checkmark, "目前營業中")
        containerView.addSubview(businessCheckBoxOne)
        businessCheckBoxOne.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                  "V:[$view0]-16-[$self]"],
                                                views: [businessHourLabel])
        
        businessCheckBoxTwo = KPCheckView(.checkmark, "特定營業時段")
        containerView.addSubview(businessCheckBoxTwo)
        businessCheckBoxTwo.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                  "V:[$view0]-16-[$self]"],
                                                views: [businessCheckBoxOne])
        
        
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
        
        containerView.addSubview(seperator_three)
        seperator_three.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:[$view0]-16-[$self(1)]"],
                                            views: [businessCheckBoxTwo])
        
        searchButton = UIButton()
        searchButton.setTitle("開始搜尋", for: .normal)
        searchButton.setTitleColor(UIColor.white, for: .normal)
        searchButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor.mainColor!),
                                             for: .normal)
        searchButton.layer.cornerRadius = 4.0
        searchButton.layer.masksToBounds = true
        searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        containerView.addSubview(searchButton)
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

}
