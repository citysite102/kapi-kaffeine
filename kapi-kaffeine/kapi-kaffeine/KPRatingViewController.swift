//
//  KPRatingViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPRatingViewController: KPViewController {
    
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
    var averageRate: CGFloat = 0
    var isRemote: Bool = true
    var sendButtonItem: UIBarButtonItem!
    var scrollContainer: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "新增評分"
        navigationItem.hidesBackButton = true
        
        let backButton = KPBounceButton(frame: CGRect.zero,
                                        image: R.image.icon_back()!)
        backButton.widthAnchor.constraint(equalToConstant: CGFloat(KPLayoutConstant.dismissButton_size)).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: CGFloat(KPLayoutConstant.dismissButton_size)).isActive = true
        backButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        backButton.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        backButton.addTarget(self,
                             action: #selector(KPRatingViewController.handleDismissButtonOnTapped),
                             for: UIControlEvents.touchUpInside)
        
        let barItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItems = [barItem]
        
        
        sendButtonItem = UIBarButtonItem(title: "發佈",
                                         style: .plain,
                                         target: self,
                                         action: #selector(KPRatingViewController.handleDismissButtonOnTapped))
        sendButtonItem.setTitleTextAttributes([NSAttributedStringKey.font:
            UIFont.systemFont(ofSize: KPFontSize.mainContent)], for: .normal)
        
        sendButtonItem.isEnabled = false
        navigationItem.rightBarButtonItems = [sendButtonItem]
        
        scrollContainer = UIScrollView()
        scrollContainer.delaysContentTouches = true
        scrollContainer.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        scrollContainer.canCancelContentTouches = false
        scrollContainer.backgroundColor = UIColor.white 
        view.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self]|"])
        
        scoreLabel = KPMainListCellScoreLabel()
//        scoreLabel.score = "0.0"
//        view.addSubview(scoreLabel)
//        scoreLabel.addConstraints(fromStringArray: ["H:[$self(32)]-16-|",
//                                                    "V:[$self(24)]"])
//        scoreLabel.addConstraintForCenterAligning(to: titleLabel, in: .vertical)
        
        for (index, title) in ratingTitles.enumerated() {
            let ratingView = KPRatingView.init()
            ratingView.delegate = self
            ratingView.tag = index
            ratingViews.append(ratingView)
            scrollContainer.addSubview(ratingView)
            
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
        
//        sendButton.setTitle("送出評分", for: .normal)
//        sendButton.addTarget(self,
//                             action: #selector(KPRatingViewController.handleSendButtonOnTapped),
//                             for: .touchUpInside)
        
        
    }
    
    func setRating(_ rating: (Int, Int, Int, Int, Int, Int, Int, CGFloat)?) {
        if let rating = rating {
            ratingViews[0].currentRate = rating.0
            ratingViews[1].currentRate = rating.1
            ratingViews[2].currentRate = rating.2
            ratingViews[3].currentRate = rating.3
            ratingViews[4].currentRate = rating.4
            ratingViews[5].currentRate = rating.5
            ratingViews[6].currentRate = rating.6
            averageRate = rating.7
        } else {
            if ratingViews.count >= 7 {
                ratingViews[0].currentRate = 0
                ratingViews[1].currentRate = 0
                ratingViews[2].currentRate = 0
                ratingViews[3].currentRate = 0
                ratingViews[4].currentRate = 0
                ratingViews[5].currentRate = 0
                ratingViews[6].currentRate = 0
                averageRate = 0
                scoreLabel.score = "0.0"
            }
        }
    }
    
    @objc func handleDismissButtonOnTapped() {
        navigationController?.popViewController(animated: true)
//        self.setRating(returnValue as? (Int, Int, Int, Int, Int, Int, Int, CGFloat))
//        super.handleDismissButtonOnTapped()
    }

//    @objc func handleSendButtonOnTapped() {
//        returnValue = (ratingViews[0].currentRate,
//                       ratingViews[1].currentRate,
//                       ratingViews[2].currentRate,
//                       ratingViews[3].currentRate,
//                       ratingViews[4].currentRate,
//                       ratingViews[5].currentRate,
//                       ratingViews[6].currentRate,
//                       averageRate)
//        delegate?.returnValueSet(self)
//        if isRemote {
//            if defaultRateModel != nil {
//                KPServiceHandler.sharedHandler.updateRating(NSNumber(value: ratingViews[0].currentRate),
//                                                            NSNumber(value: ratingViews[3].currentRate),
//                                                            NSNumber(value: ratingViews[5].currentRate),
//                                                            NSNumber(value: ratingViews[1].currentRate),
//                                                            NSNumber(value: ratingViews[4].currentRate),
//                                                            NSNumber(value: ratingViews[2].currentRate),
//                                                            NSNumber(value: ratingViews[6].currentRate)) { (successed) in
//                                                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
//                                                                                              execute: {
//                                                                                                self.appModalController()?.dismissControllerWithDefaultDuration()
//                                                                })
//                }
//            } else {
//                KPServiceHandler.sharedHandler.addRating(NSNumber(value: ratingViews[0].currentRate),
//                                                         NSNumber(value: ratingViews[3].currentRate),
//                                                         NSNumber(value: ratingViews[5].currentRate),
//                                                         NSNumber(value: ratingViews[1].currentRate),
//                                                         NSNumber(value: ratingViews[4].currentRate),
//                                                         NSNumber(value: ratingViews[2].currentRate),
//                                                         NSNumber(value: ratingViews[6].currentRate)) { (successed) in
//                                                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
//                                                                                          execute: {
//                                                                                            self.appModalController()?.dismissControllerWithDefaultDuration()
//                                                            })
//                }
//            }
//        } else {
//            appModalController()?.dismissControllerWithDefaultDuration()
//        }
//    }
    
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
