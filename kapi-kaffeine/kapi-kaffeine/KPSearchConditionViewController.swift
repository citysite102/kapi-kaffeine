//
//  KPSearchConditionViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchConditionViewController: UIViewController {

    var dismissButton:UIButton!
    var scrollView: UIScrollView!
    var containerView: UIView!
    
    
    var ratingTitles = ["Wifi穩定", "安靜程度",
                        "價格實惠", "座位數量",
                        "咖啡品質", "餐點美味", "環境舒適"]
    var ratingViews = [KPRatingView]()
    
    // 快速設定
    lazy var quickSettingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPTextColor.grayColor
        label.text = "使用快速設定"
        return label
    }()
    
    var quickSettingButtonOne: UIButton!
    var quickSettingButtonTwo: UIButton!
    var quickSettingButtonThree: UIButton!
    
    lazy var seperator_one: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
        return view
    }()
    
    lazy var seperator_two: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
        return view
    }()
    
    func buttonWithTitle(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(KPColorPalette.KPMainColor.buttonColor!,
                             for: .normal)
        button.setTitleColor(UIColor.white,
                             for: .selected)
        button.setBackgroundImage(UIImage.init(color: UIColor.white),
                                  for: .normal)
        button.setBackgroundImage(UIImage.init(color: KPColorPalette.KPMainColor.buttonColor!),
                                  for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 18.0
        button.layer.borderWidth = 2.0
        button.layer.borderColor = KPColorPalette.KPMainColor.buttonColor?.cgColor
        return button
    }
    
    // 分數區
    lazy var adjustPointLabel: UILabel = {
        let label = UILabel();
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPTextColor.grayColor
        label.text = "調整分數至你的需求"
        return label;
    }()
    
    
    
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
        self.containerView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self(500)]|"]);
        self.containerView.addConstraintForHavingSameWidth(with: self.view);
        
        
        // Section 1
        self.containerView.addSubview(self.quickSettingLabel)
        self.quickSettingLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                                "V:|-16-[$self]"])
        
        self.quickSettingButtonOne = self.buttonWithTitle(title: "適合讀書工作")
        self.quickSettingButtonTwo = self.buttonWithTitle(title: "C/P值高")
        self.quickSettingButtonThree = self.buttonWithTitle(title: "平均四分")
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleDismissButtonOnTapped() {
        self.appModalController()?.dismissControllerWithDefaultDuration();
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
