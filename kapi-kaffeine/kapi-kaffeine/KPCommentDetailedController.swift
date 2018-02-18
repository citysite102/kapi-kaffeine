//
//  KPCommentDetailedController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/22.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPCommentDetailedController: KPViewController {

    var backButton: KPBounceButton!
    var editButton: KPBounceButton!
    
    var scrollContainer: UIScrollView!
    var containerView: UIView!
    var rateContainerView: UIView!
    var shopRateInfoView: KPShopRateInfoView!
    var userPicture: UIImageView!
    var userNameLabel: UILabel!
    var timeHintLabel: UILabel!
    var userCommentLabel: UILabel!
    var separator: UIView!
    var voteUpCount: NSNumber! {
        didSet {
            self.voteUpButton.currentCount = voteUpCount.intValue
        }
    }
    
    var voteDownCount: NSNumber! {
        didSet {
            self.voteDownButton.currentCount = voteDownCount.intValue
        }
    }
    
    private var voteUpButton: KPShopCommentCellButton!
    private var voteDownButton: KPShopCommentCellButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "評論"
        navigationItem.hidesBackButton = true
        
        backButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24),
                                    image: R.image.icon_back()!)
        backButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        backButton.addTarget(self,
                             action: #selector(KPAllCommentController.handleBackButtonOnTapped),
                             for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: backButton)
        
        editButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24),
                                    image: R.image.icon_edit()!)
        editButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        editButton.addTarget(self,
                             action: #selector(KPAllCommentController.handleEditButtonOnTapped),
                             for: .touchUpInside)
        
        let rightbarItem = UIBarButtonItem(customView: editButton)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        navigationItem.rightBarButtonItems = [negativeSpacer, rightbarItem]
        

        
        scrollContainer = UIScrollView()
        scrollContainer.delaysContentTouches = true
        scrollContainer.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        scrollContainer.canCancelContentTouches = false
        view.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self]|"])
        
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        scrollContainer.addSubview(containerView)
        containerView.addConstraints(fromStringArray: ["V:|[$self(160)]",
                                                       "H:|[$self]|"])
        
        containerView.addConstraintForHavingSameWidth(with: view)
        
        userPicture = UIImageView(image: R.image.demo_profile())
        userPicture.contentMode = .scaleAspectFit
        userPicture.layer.cornerRadius = 10.0
        userPicture.layer.borderWidth = 1.0
        userPicture.layer.borderColor = KPColorPalette.KPMainColor_v2.grayColor_level5?.cgColor
        userPicture.layer.masksToBounds = true
        containerView.addSubview(userPicture)
        userPicture.addConstraints(fromStringArray: ["H:|-16-[$self(32)]",
                                                     "V:|-16-[$self(32)]"])
        
        
        userNameLabel = UILabel()
        userNameLabel.font = UIFont.systemFont(ofSize: 14.0)
        userNameLabel.text = "程式裡的蟲"
        userNameLabel.textColor = KPColorPalette.KPTextColor.grayColor_level1
        containerView.addSubview(userNameLabel)
        userNameLabel.addConstraints(fromStringArray: ["H:|-16-[$self(190)]",
                                                       "V:[$view0]-16-[$self]"],
                                     metrics: [UIScreen.main.bounds.size.width/2],
                                     views: [userPicture])
        
        timeHintLabel = UILabel()
        timeHintLabel.text = "一個世紀前"
        timeHintLabel.font = UIFont.systemFont(ofSize: 12.0)
        timeHintLabel.textColor = KPColorPalette.KPTextColor.grayColor_level4
        containerView.addSubview(timeHintLabel)
        timeHintLabel.addConstraints(fromStringArray: ["H:[$self]-16-|",
                                                       "V:|-16-[$self]"],
                                     metrics: [UIScreen.main.bounds.size.width/2],
                                     views: [userPicture])
        
        userCommentLabel = UILabel()
        userCommentLabel.font = UIFont.systemFont(ofSize: 14.0)
        userCommentLabel.numberOfLines = 0
        userCommentLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3
        userCommentLabel.setText(text: "我是蟲！！你不應該看到這個評論才對，快回報給開發者們吧(´・ω・`)",
                                 lineSpacing: 3.0)
        containerView.addSubview(userCommentLabel)
        userCommentLabel.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                          "V:[$view1]-4-[$self]-16-|"],
                                        metrics: [UIScreen.main.bounds.size.width/2],
                                        views: [userPicture, userNameLabel])
        
        voteUpButton = KPShopCommentCellButton.init(frame: .zero,
                                                    icon: R.image.icon_upvote()!,
                                                    count: 0)
        voteUpButton.iconButton.addTarget(self,
                                          action: #selector(KPShopCommentCell.handleVoteUpButtonOnTapped),
                                          for: .touchUpInside);
        
//        containerView.addSubview(voteUpButton)
//        voteUpButton.addConstraints(fromStringArray: ["H:|-12-[$self]",
//                                                      "V:[$view1]-12-[$self]-8-|"],
//                                    metrics: [UIScreen.main.bounds.size.width/2],
//                                    views: [userPicture, userCommentLabel])
        
        
        voteDownButton = KPShopCommentCellButton(frame: .zero,
                                                 icon: R.image.icon_downvote()!,
                                                 count: 0)
        voteDownButton.iconButton.addTarget(self,
                                            action: #selector(KPShopCommentCell.handleVoteDownButtonOnTapped),
                                            for: .touchUpInside);
//        containerView.addSubview(voteDownButton)
//        voteDownButton.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
//                                                        "V:[$view1]-12-[$self]"],
//                                      metrics: [UIScreen.main.bounds.size.width/2],
//                                      views: [voteUpButton, userCommentLabel])
        
//        separator = UIView()
//        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
//        containerView.addSubview(separator)
//        separator.addConstraints(fromStringArray: ["V:[$self(1)]|",
//                                                   "H:|[$self]|"])
        
        rateContainerView = UIView()
        rateContainerView.backgroundColor = UIColor.white
        scrollContainer.addSubview(rateContainerView)
        rateContainerView.addConstraints(fromStringArray: ["V:[$view0][$self]",
                                                           "H:|[$self]|"],
                                         views: [containerView])
        
        shopRateInfoView = KPShopRateInfoView()
        rateContainerView.addSubview(shopRateInfoView)
        shopRateInfoView.addConstraints(fromStringArray: ["V:|-4-[$self]-4-|",
                                                          "H:|[$self]|"],
                                        views: [containerView])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleBackButtonOnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleEditButtonOnTapped() {
        let newCommentViewController = KPNewCommentController()
        navigationController?.pushViewController(viewController: newCommentViewController,
                                                 animated: true,
                                                 completion: {})
    }
    
}
