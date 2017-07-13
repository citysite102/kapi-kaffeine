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
    var defaultRateModel: KPSimpleRateModel?
    var scoreLabel: KPMainListCellScoreLabel!
    var averageRate: CGFloat!
    var isRemote: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "店家各項評分"
        scrollView.isScrollEnabled = true
        
        scoreLabel = KPMainListCellScoreLabel()
        scoreLabel.score = "0.0"
        view.addSubview(scoreLabel)
        scoreLabel.addConstraints(fromStringArray: ["H:[$self(32)]-16-|",
                                                    "V:[$self(24)]"])
        scoreLabel.addConstraintForCenterAligning(to: titleLabel, in: .vertical)
        
        for (index, title) in ratingTitles.enumerated() {
            let ratingView = KPRatingView.init(.star,
                                               ratingImages[index]!,
                                               title)
            ratingView.delegate = self
            ratingView.tag = index
            ratingViews.append(ratingView)
            containerView.addSubview(ratingView)
            
            if index == 0 {
                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                            "V:|-24-[$self]"])
            } else {
                ratingView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                            "V:[$view0]-12-[$self]"],
                                          views: [self.ratingViews[index-1]])
            }
        }
        ratingViews.last!.addConstraint(from: "V:[$self]-16-|")
        
        
        if defaultRateModel != nil {
            ratingViews[0].currentRate = defaultRateModel?.wifi?.intValue ?? 0
            ratingViews[1].currentRate = defaultRateModel?.quiet?.intValue ?? 0
            ratingViews[2].currentRate = defaultRateModel?.cheap?.intValue ?? 0
            ratingViews[3].currentRate = defaultRateModel?.seat?.intValue ?? 0
            ratingViews[4].currentRate = defaultRateModel?.tasty?.intValue ?? 0
            ratingViews[5].currentRate = defaultRateModel?.food?.intValue ?? 0
            ratingViews[6].currentRate = defaultRateModel?.music?.intValue ?? 0
        }
        
        sendButton.setTitle("送出評分", for: .normal)
        sendButton.addTarget(self,
                             action: #selector(KPRatingViewController.handleSendButtonOnTapped),
                             for: .touchUpInside)
        
        
    }
    
    func handleSendButtonOnTapped() {
        setValue = averageRate
        delegate?.sendButtonTapped(self)
        if isRemote {
            KPServiceHandler.sharedHandler.addRating(NSNumber(value: ratingViews[0].currentRate),
                                                     NSNumber(value: ratingViews[3].currentRate),
                                                     NSNumber(value: ratingViews[5].currentRate),
                                                     NSNumber(value: ratingViews[1].currentRate),
                                                     NSNumber(value: ratingViews[4].currentRate),
                                                     NSNumber(value: ratingViews[2].currentRate),
                                                     NSNumber(value: ratingViews[6].currentRate),
                                                     true) { (successed) in
                                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                                                                      execute: {
                                                                                        self.appModalController()?.dismissControllerWithDefaultDuration()
                                                        })
            }
        } else {
            appModalController()?.dismissControllerWithDefaultDuration()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension KPRatingViewController: KPRatingViewDelegate {
    
    func rateValueDidChanged(_ ratingView: KPRatingView) {
        
        var totalRate: CGFloat = 0
        var availableRateCount: CGFloat = 0
        
        for rateView in ratingViews {
            totalRate += CGFloat(rateView.currentRate)
            availableRateCount = availableRateCount + ((rateView.currentRate != 0) ? 1 : 0)
        }
        averageRate = totalRate/availableRateCount
        scoreLabel.score = String(format: "%.1f", averageRate)
    }
}
