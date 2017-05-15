//
//  KPRatingViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPRatingViewController: UIViewController {

    var dismissButton:UIButton!
    var scrollView: UIScrollView!
    var containerView: UIView!
    var sendButton: UIButton!
    
    var ratingTitles = ["Wifi穩定", "安靜程度",
                        "價格實惠", "座位數量",
                        "咖啡品質", "餐點美味", "環境舒適"]
    var ratingViews = [KPRatingView]()
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.text = "店家各項評分"
        return label
    }()
    
    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        label.text = "4.3"
        label.backgroundColor = KPColorPalette.KPBackgroundColor.cellScoreBgColor;
        label.layer.cornerRadius = 2.0;
        label.layer.masksToBounds = true;
        label.textAlignment = .center
        return label
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        scrollView = UIScrollView();
        scrollView.showsVerticalScrollIndicator = false;
        view.addSubview(self.scrollView);
        scrollView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                    "H:|[$self]|"]);
        
        
        containerView = UIView();
        scrollView.addSubview(self.containerView);
        containerView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"]);
        containerView.addConstraintForHavingSameWidth(with: self.view);
        
        dismissButton = UIButton.init()
        dismissButton.setImage(UIImage.init(named: "icon_close")?.withRenderingMode(.alwaysTemplate),
                               for: .normal)
        dismissButton.tintColor = KPColorPalette.KPMainColor.mainColor
        dismissButton.addTarget(self,
                                action: #selector(KPRatingViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        containerView.addSubview(dismissButton)
        dismissButton.addConstraints(fromStringArray: ["H:|-16-[$self(24)]",
                                                       "V:|-16-[$self(24)]"])
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        
        
        containerView.addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["V:[$view0]-24-[$self]",
                                                    "H:|-16-[$self]"],
                                  views:[dismissButton])
        
        containerView.addSubview(scoreLabel)
        scoreLabel.addConstraints(fromStringArray: ["H:[$self(26)]-16-|", "V:[$self(20)]"])
        scoreLabel.addConstraintForCenterAligning(to: titleLabel, in: .vertical)
        
        containerView.addSubview(seperator_one)
        seperator_one.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                       "V:[$view0]-16-[$self(1)]"],
                                     views: [titleLabel])
        
        for (index, title) in ratingTitles.enumerated() {
            let ratingView = KPRatingView.init(.star,
                                               R.image.icon_map()!,
                                               title)
            ratingViews.append(ratingView)
            containerView.addSubview(ratingView)
            
            if index == 0 {
                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                            "V:[$view0]-24-[$self]"],
                                          views: [self.seperator_one])
            } else {
                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                            "V:[$view0]-24-[$self]"],
                                          views: [self.ratingViews[index-1]])
            }
        }
        
        containerView.addSubview(seperator_two)
        seperator_two.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                       "V:[$view0]-16-[$self(1)]"],
                                     views: [ratingViews.last!])
        
        sendButton = UIButton.init(type: .custom)
        sendButton.setTitle("送出評分", for: .normal)
        sendButton.setTitleColor(KPColorPalette.KPTextColor.mainColor,
                                 for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        containerView.addSubview(sendButton)
        sendButton.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(30)]-16-|"],
                                  views: [seperator_two])
        sendButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
    }

    
    
    func handleDismissButtonOnTapped() {
        self.dismiss(animated: true, completion: nil);
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
