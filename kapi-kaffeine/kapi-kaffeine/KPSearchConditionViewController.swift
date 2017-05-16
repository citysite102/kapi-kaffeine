//
//  KPSearchConditionViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit


struct KPSearchConditionViewControllerConstants{
    static let leftPadding = 168
}

class KPSearchConditionViewController: UIViewController {

    var dismissButton:UIButton!
    var scrollView: UIScrollView!
    var containerView: UIView!
    
    
    var ratingTitles = ["Wifi穩定", "安靜程度",
                        "價格實惠", "座位數量",
                        "咖啡品質", "餐點美味", "環境舒適"]
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
        button.setBackgroundImage(UIImage.init(color: UIColor.white),
                                  for: .normal)
        button.setBackgroundImage(UIImage.init(color: KPColorPalette.KPMainColor.mainColor!),
                                  for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 18.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = KPColorPalette.KPMainColor.mainColor?.cgColor
        return button
    }
    
    func titleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPMainColor.mainColor
        label.text = title
        return label;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white;
        self.navigationController?.navigationBar.topItem?.title = "篩選偏好設定";
        
        self.dismissButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24));
        self.dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        self.dismissButton.setImage(UIImage.init(named: "icon_close")?.withRenderingMode(.alwaysTemplate),
                                    for: .normal);
        self.dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        self.dismissButton.addTarget(self,
                                     action: #selector(KPSearchConditionViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside);
        
        let barItem = UIBarButtonItem.init(customView: self.dismissButton);
        self.navigationItem.leftBarButtonItem = barItem;
        
        self.dismissButton.addTarget(self,
                                     action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside);
        
        self.scrollView = UIScrollView();
        self.scrollView.showsVerticalScrollIndicator = false;
        self.view.addSubview(self.scrollView);
        self.scrollView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                         "H:|[$self]|"]);
        self.scrollView.addConstraintForCenterAligningToSuperview(in: .horizontal);
        
        
        self.containerView = UIView();
        self.scrollView.addSubview(self.containerView);
        self.containerView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"]);
        self.containerView.addConstraintForHavingSameWidth(with: self.view);
        
        
        // Section 1
        self.quickSettingLabel = titleLabel("使用快速設定")
        self.containerView.addSubview(self.quickSettingLabel)
        self.quickSettingLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                "V:|-16-[$self]"])
        
        self.quickSettingButtonOne = buttonWithTitle(title: "適合讀書工作")
        self.quickSettingButtonTwo = buttonWithTitle(title: "C/P值高")
        self.quickSettingButtonThree = buttonWithTitle(title: "平均四分")
        self.containerView.addSubview(self.quickSettingButtonOne)
        self.containerView.addSubview(self.quickSettingButtonTwo)
        self.containerView.addSubview(self.quickSettingButtonThree)
        
        self.quickSettingButtonOne.addConstraints(fromStringArray: ["H:|-16-[$self(110)]",
                                                                    "V:[$view0]-8-[$self(36)]"],
                                                  views: [self.quickSettingLabel])
        self.quickSettingButtonTwo.addConstraints(fromStringArray: ["H:[$view1]-8-[$self(80)]",
                                                                    "V:[$view0]-8-[$self(36)]"],
                                                  views: [self.quickSettingLabel, self.quickSettingButtonOne])
        self.quickSettingButtonThree.addConstraints(fromStringArray: ["H:[$view1]-8-[$self(80)]",
                                                                      "V:[$view0]-8-[$self(36)]"],
                                                    views: [self.quickSettingLabel, self.quickSettingButtonTwo])
        self.containerView.addSubview(self.seperator_one)
        self.seperator_one.addConstraints(fromStringArray: ["H:|[$self]|",
                                                            "V:[$view0]-16-[$self(1)]"],
                                          views: [self.quickSettingButtonOne])
        
        
        // Section 2
        self.adjustPointLabel = titleLabel("調整分數至你的需求")
        self.containerView.addSubview(self.adjustPointLabel)
        self.adjustPointLabel.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                               "V:[$view0]-16-[$self]"],
                                             views: [self.seperator_one])
        
        for (index, title) in ratingTitles.enumerated() {
            let ratingView = KPRatingView.init(.button,
                                               R.image.icon_map()!,
                                               title)
            self.ratingViews.append(ratingView)
            self.containerView.addSubview(ratingView)
            
            if index == 0 {
                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                            "V:[$view0]-24-[$self]"],
                                          views: [self.adjustPointLabel])
            } else {
                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                            "V:[$view0]-24-[$self]"],
                                          views: [self.ratingViews[index-1]])
            }
        }
        
        self.containerView.addSubview(self.seperator_two)
        self.seperator_two.addConstraints(fromStringArray: ["H:|[$self]|",
                                                            "V:[$view0]-16-[$self(1)]"],
                                          views: [self.ratingViews.last!])
        
        
        // Section 3
        self.timeLimitLabel = titleLabel("有無時間限制")
        self.containerView.addSubview(self.timeLimitLabel)
        self.timeLimitLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                             "V:[$view0]-16-[$self]"],
                                           views: [self.seperator_two])
        self.timeRadioBoxOne = KPCheckView.init(.radio, "不設定")
        self.containerView.addSubview(self.timeRadioBoxOne)
        self.timeRadioBoxOne.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                              "V:[$view0]-16-[$self]"],
                                            views: [self.timeLimitLabel])
        self.timeRadioBoxTwo = KPCheckView.init(.radio, "客滿/人多限時")
        self.containerView.addSubview(self.timeRadioBoxTwo)
        self.timeRadioBoxTwo.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                              "V:[$view0]-8-[$self]"],
                                            views: [self.timeRadioBoxOne])
        self.timeRadioBoxThree = KPCheckView.init(.radio, "不限時")
        self.containerView.addSubview(self.timeRadioBoxThree)
        self.timeRadioBoxThree.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                "V:[$view0]-8-[$self]"],
                                              views: [self.timeRadioBoxTwo])
        
        self.socketLabel = titleLabel("插座數量")
        self.containerView.addSubview(self.socketLabel)
        self.socketLabel.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                          "V:[$view0]-16-[$self]"],
                                        metrics:[KPSearchConditionViewControllerConstants.leftPadding],
                                           views: [self.seperator_two])
        
        self.socketRadioBoxOne = KPCheckView.init(.radio, "不設定")
        self.containerView.addSubview(self.socketRadioBoxOne)
        self.socketRadioBoxOne.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                                "V:[$view0]-16-[$self]"],
                                              metrics:[KPSearchConditionViewControllerConstants.leftPadding],
                                              views: [self.socketLabel])
        self.socketRadioBoxTwo = KPCheckView.init(.radio, "部分座位有")
        self.containerView.addSubview(self.socketRadioBoxTwo)
        self.socketRadioBoxTwo.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                                "V:[$view0]-8-[$self]"],
                                              metrics:[KPSearchConditionViewControllerConstants.leftPadding],
                                                views: [self.socketRadioBoxOne])
        self.socketRadioBoxThree = KPCheckView.init(.radio, "很多插座")
        self.containerView.addSubview(self.socketRadioBoxThree)
        self.socketRadioBoxThree.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                                  "V:[$view0]-8-[$self]"],
                                                metrics:[KPSearchConditionViewControllerConstants.leftPadding],
                                                views: [self.socketRadioBoxTwo])
        
        self.businessHourLabel = titleLabel("營業時間")
        self.containerView.addSubview(self.businessHourLabel)
        self.businessHourLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                "V:[$view0]-16-[$self]"],
                                              views: [self.timeRadioBoxThree])
        
        self.businessCheckBoxOne = KPCheckView.init(.checkmark, "目前營業中")
        self.containerView.addSubview(self.businessCheckBoxOne)
        self.businessCheckBoxOne.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                  "V:[$view0]-16-[$self]"],
                                                views: [self.businessHourLabel])
        
        self.businessCheckBoxTwo = KPCheckView.init(.checkmark, "特定營業時段")
        self.containerView.addSubview(self.businessCheckBoxTwo)
        self.businessCheckBoxTwo.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                  "V:[$view0]-8-[$self]"],
                                                views: [self.businessCheckBoxOne])
        
        
        self.othersLabel = titleLabel("其他選項")
        self.containerView.addSubview(self.othersLabel)
        self.othersLabel.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                          "V:[$view0]-16-[$self]"],
                                        metrics:[KPSearchConditionViewControllerConstants.leftPadding],
                                                views: [self.timeRadioBoxThree])
        self.othersCheckBoxOne = KPCheckView.init(.checkmark, "可站立工作")
        self.containerView.addSubview(self.othersCheckBoxOne)
        self.othersCheckBoxOne.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                                "V:[$view0]-16-[$self]"],
                                              metrics:[KPSearchConditionViewControllerConstants.leftPadding],
                                              views: [self.othersLabel])
        
        self.containerView.addSubview(self.seperator_three)
        self.seperator_three.addConstraints(fromStringArray: ["H:|[$self]|",
                                                            "V:[$view0]-16-[$self(1)]"],
                                          views: [self.businessCheckBoxTwo])
        
        self.searchButton = UIButton()
        self.searchButton.setTitle("開始搜尋", for: .normal)
        self.searchButton.setTitleColor(UIColor.white, for: .normal)
        self.searchButton.setBackgroundImage(UIImage.init(color: KPColorPalette.KPMainColor.mainColor!),
                                             for: .normal)
        self.searchButton.layer.cornerRadius = 4.0
        self.searchButton.layer.masksToBounds = true
        self.searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        self.containerView.addSubview(self.searchButton)
        self.searchButton.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(40)]-16-|",
                                                           "H:|-16-[$self]-16-|"],
                                         views: [self.seperator_three])
        self.searchButton.addTarget(self, action: #selector(showTimePicker), for: .touchUpInside)
    }
    
    func showTimePicker() {
        let controller = KPModalViewController()
        controller.edgeInset = UIEdgeInsets.init(top: 50,
                                                 left: 0,
                                                 bottom: 0,
                                                 right: 0);
        let timePickerController = KPTimePickerViewController()
        controller.contentController = timePickerController
        controller.presentModalView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleDismissButtonOnTapped() {
        self.appModalController()?.dismissControllerWithDefaultDuration();
    }

}
