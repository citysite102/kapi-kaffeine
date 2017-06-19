//
//  KPRatingViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPRatingViewController: KPSharedSettingViewController {
    
    var ratingTitles = ["Wifi穩定", "安靜程度",
                        "價格實惠", "座位數量",
                        "咖啡品質", "餐點美味", "環境舒適"]
    var ratingImages = [R.image.icon_wifi(), R.image.icon_sleep(),
                        R.image.icon_money(), R.image.icon_seat(),
                        R.image.icon_cup(), R.image.icon_cutlery(),
                        R.image.icon_pic()]
    var ratingViews = [KPRatingView]()

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "店家各項評分"
        
        containerView.addSubview(scoreLabel)
        scoreLabel.addConstraints(fromStringArray: ["H:[$self(26)]-16-|", "V:[$self(20)]"])
        scoreLabel.addConstraintForCenterAligning(to: titleLabel, in: .vertical)
        
        for (index, title) in ratingTitles.enumerated() {
            let ratingView = KPRatingView.init(.star,
                                               ratingImages[index]!,
                                               title)
            ratingViews.append(ratingView)
            containerView.addSubview(ratingView)
            
            if index == 0 {
                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                            "V:|-24-[$self]"])
            } else {
                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                            "V:[$view0]-24-[$self]"],
                                          views: [self.ratingViews[index-1]])
            }
        }
        
        ratingViews.last!.addConstraint(from: "V:[$self]-16-|")
        sendButton.setTitle("送出評分", for: .normal)
        sendButton.addTarget(self,
                             action: #selector(KPRatingViewController.handleSendButtonOnTapped),
                             for: .touchUpInside)
        
        
    }
    
    func handleSendButtonOnTapped() {
        KPServiceHandler.sharedHandler.addNewRating(NSNumber(value: ratingViews[0].currentStarIndex),
                                                    NSNumber(value: ratingViews[3].currentStarIndex),
                                                    NSNumber(value: ratingViews[5].currentStarIndex),
                                                    NSNumber(value: ratingViews[1].currentStarIndex),
                                                    NSNumber(value: ratingViews[4].currentStarIndex),
                                                    NSNumber(value: ratingViews[2].currentStarIndex),
                                                    NSNumber(value: ratingViews[6].currentStarIndex)) { (successed) in
                                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                                                                      execute: {
                                                                                        self.appModalController()?.dismissControllerWithDefaultDuration()
                                                        })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
