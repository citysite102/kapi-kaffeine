//
//  KPInformationHeaderView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

protocol KPInformationHeaderViewDelegate: NSObjectProtocol {
    func headerPhotoTapped(_ headerView: KPInformationHeaderView)
}

class KPInformationHeaderButtonBar: UIView {
    
    weak open var informationController: KPInformationViewController?
    var collectButton: KPInformationHeaderButton!
    var visitButton: KPInformationHeaderButton!
    var rateButton: KPInformationHeaderButton!
    var commentButton: KPInformationHeaderButton!
    var informationDataModel: KPDetailedDataModel! {
        didSet {
            if let favoriteValue = informationDataModel.favoriteCount?.intValue {
                collectButton.numberValue = favoriteValue
            }
            
            if let visitValue = informationDataModel.visitCount?.intValue {
                visitButton.numberValue = visitValue
            }
            
            if let rateValue = informationDataModel.rateCount?.intValue {
                rateButton.numberValue = rateValue
            }
            
            if let commentValue = informationDataModel.commentCount?.intValue {
                commentButton.numberValue = commentValue
            }
            
            collectButton.selected = (KPUserManager.sharedManager.currentUser?.hasFavorited(informationDataModel.identifier)) ?? false
            visitButton.selected = (KPUserManager.sharedManager.currentUser?.hasVisited(informationDataModel.identifier)) ?? false
            rateButton.selected = (KPUserManager.sharedManager.currentUser?.hasRated(informationDataModel.identifier)) ?? false
            commentButton.selected = (KPUserManager.sharedManager.currentUser?.hasReviewed(informationDataModel.identifier)) ?? false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectButton = KPInformationHeaderButton()
        addSubview(collectButton)
        collectButton.addConstraints(fromStringArray: ["H:|[$self(56)]",
                                                       "V:|[$self]|"])
        
        
        visitButton = KPInformationHeaderButton()
        addSubview(visitButton)
        visitButton.addConstraints(fromStringArray: ["H:[$view0][$self(56)]",
                                                     "V:|[$self]|"],
                                   views: [collectButton])
        
        
        rateButton = KPInformationHeaderButton()
        addSubview(rateButton)
        rateButton.addConstraints(fromStringArray: ["H:[$view0][$self(56)]",
                                                    "V:|[$self]|"],
                                  views: [visitButton])
        
        
        commentButton = KPInformationHeaderButton()
        addSubview(commentButton)
        commentButton.addConstraints(fromStringArray: ["H:[$view0][$self(56)]|",
                                                       "V:|[$self]|"],
                                     views: [rateButton])
        
        collectButton.buttonInfo = HeaderButtonInfo(title: "收藏",
                                                    info: "%d人已收藏",
                                                    defaultInfo: "無人收藏",
                                                    icon: R.image.icon_collect_border()!,
                                                    handler: { [unowned self] (headerButton) -> () in
                                                        if headerButton.selected == false {
                                                            headerButton.selected = true
                                                            headerButton.numberValue = headerButton.numberValue + 1
                                                            KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.store_favorite_button)
                                                            KPServiceHandler.sharedHandler.addFavoriteCafe()
                                                        } else {
                                                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                                KPPopoverView.popoverDefaultStyleContent (
                                                                    "移除收藏",
                                                                    "確定要改變心意移除收藏這間優秀到不行再優秀的咖啡廳嗎？",
                                                                    "我確定", { (content) in
                                                                        content.popoverView.dismiss()
                                                                        headerButton.selected = false
                                                                        headerButton.numberValue = headerButton.numberValue - 1
                                                                        KPServiceHandler.sharedHandler.removeFavoriteCafe(self.informationDataModel.identifier, { (successed) in
                                                                        })
                                                                })
                                                            }
                                                            
                                                        }
        })
        
        visitButton.buttonInfo = HeaderButtonInfo(title: "有誰來過",
                                                  info: "%d人來過",
                                                  defaultInfo: "無人打卡",
                                                  icon: R.image.icon_pin()!,
                                                  handler: { [unowned self] (headerButton) -> () in
                                                    
                                                    if headerButton.selected == false {
                                                        KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.store_visit_button)
                                                        if let visitedMembers = self.informationDataModel.visitedMembers {
                                                            var photoArray: [String] = [String]()
                                                            for member in visitedMembers {
                                                                photoArray.append(member.photoURL!)
                                                            }
                                                            
                                                            if photoArray.count > 0 {
                                                                KPPopoverView.popoverVisitedView(photoArray, { (content) in
                                                                    content.popoverView.dismiss()
                                                                    headerButton.selected = true
                                                                    headerButton.numberValue = headerButton.numberValue + 1
                                                                    KPServiceHandler.sharedHandler.addVisitedCafe()
                                                                })
                                                            } else {
                                                                headerButton.selected = true
                                                                headerButton.numberValue = headerButton.numberValue + 1
                                                                KPServiceHandler.sharedHandler.addVisitedCafe()
                                                            }
                                                        }
                                                        
                                                    } else {
                                                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                            KPPopoverView.popoverDefaultStyleContent(
                                                                "移除打卡",
                                                                "確定要改變心意說你沒有去過這間超棒的咖啡廳嗎？",
                                                                "我確定", { (content) in
                                                                    content.popoverView.dismiss()
                                                                    headerButton.selected = false
                                                                    headerButton.numberValue = headerButton.numberValue - 1
                                                                    KPServiceHandler.sharedHandler.removeVisitedCafe(self.informationDataModel.identifier, { (successed) in
                                                                    })
                                                                    
                                                                    if let visitedMembers = self.informationDataModel.visitedMembers {
                                                                        let memberIndex = visitedMembers.index(where: { (memberModel) -> Bool in
                                                                            return memberModel.memberID == KPUserManager.sharedManager.currentUser?.identifier
                                                                        })
                                                                        
                                                                        if memberIndex != nil {
                                                                            self.informationDataModel.visitedMembers?.remove(at: memberIndex!)
                                                                        }
                                                                    }
                                                            })
                                                        }
                                                        
                                                    }
        })
        
        rateButton.buttonInfo = HeaderButtonInfo(title: "我要評分",
                                                 info: "%d人已評分",
                                                 defaultInfo: "尚無評分",
                                                 icon: R.image.icon_star_border()!,
                                                 handler: { [unowned self] (headerButton) -> () in
                                                    
                                                    KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.store_rate_button)
                                                    let controller = KPModalViewController()
                                                    controller.edgeInset = UIEdgeInsets(top: UIDevice().isSuperCompact ? 32 : 72,
                                                                                        left: 0,
                                                                                        bottom: 0,
                                                                                        right: 0)
                                                    controller.cornerRadius = [.topRight, .topLeft]
                                                    let ratingViewController = KPRatingViewController()
                                                    if self.informationController?.hasRatedDataModel != nil {
                                                        ratingViewController.defaultRateModel = self.informationController?.hasRatedDataModel
                                                    }
                                                    
                                                    controller.contentController = ratingViewController
                                                    controller.presentModalView()
        })
        
        commentButton.buttonInfo = HeaderButtonInfo(title: "我要評論",
                                                    info: "%d人已評論",
                                                    defaultInfo: "尚無評論",
                                                    icon: R.image.icon_comment_border()!,
                                                    handler: { [unowned self] (headerButton) -> () in
                                                        KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.store_comment_button)
                                                        let newCommentViewController = KPNewCommentController()
                                                        if self.informationController != nil {
                                                            
                                                            if self.informationController?.hasRatedDataModel != nil {
                                                                DispatchQueue.main.async {
                                                                    newCommentViewController.hideRatingViews = true
                                                                }
                                                            }

                                                            if let comment = self.informationController?.hasCommentDataModel {
                                                                let editCommentViewController = KPEditCommentController()
                                                                editCommentViewController.defaultCommentModel =  comment
                                                                self.informationController?.navigationController?.pushViewController(viewController: editCommentViewController,
                                                                                                                                     animated: true,
                                                                                                                                     completion: {})
                                                            } else {
                                                                self.informationController?.navigationController?.pushViewController(viewController:
                                                                    newCommentViewController,
                                                                                                                                     animated: true,
                                                                                                                                     completion: {})

                                                            }
                                                        }
        })
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class KPInformationHeaderView: UIView {

    var container: UIView!
    var shopPhotoContainer: UIView!
    var shopPhoto: UIImageView!
    var shopSelectView: UIView!
    
    var morePhotoButton: UIButton!
    var photoLongPressGesture: UILongPressGestureRecognizer!
    
    var scoreContainer: UIView!
    var scoreIcon: UIImageView!
    var scoreLabel: UILabel!
    var facebookButton: UIButton!
    var otherPhotoContainer: UIView!
    var scoreTapGesture: UITapGestureRecognizer!
    var scoreHandler: (() -> Void)?

    weak open var delegate: KPInformationHeaderViewDelegate?
    weak open var informationController: KPInformationViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        container = UIView()
        addSubview(container)
        container.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:|[$self]|"])
        
        shopPhotoContainer = UIView()
        shopPhotoContainer.clipsToBounds = true
        container.addSubview(shopPhotoContainer)
        shopPhotoContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                            "V:|[$self]|"])
        
        shopPhoto = UIImageView(image: UIImage(color: KPColorPalette.KPBackgroundColor.grayColor_level6!))
        shopPhoto.contentMode = .scaleAspectFill
        shopPhoto.isUserInteractionEnabled = true
        shopPhotoContainer.addSubview(shopPhoto)
        shopPhoto.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:|[$self(260)]|"])
        
        shopSelectView = UIView()
        shopSelectView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level5
        shopSelectView.isUserInteractionEnabled = false
        shopSelectView.alpha = 0
        shopPhoto.addSubview(shopSelectView)
        shopSelectView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                        "H:|[$self]|"])

        photoLongPressGesture = UILongPressGestureRecognizer(target: self,
                                                             action: #selector(handleShopPhotoLongPressed(_:)))
        photoLongPressGesture.minimumPressDuration = 0.0
        shopPhoto.addGestureRecognizer(photoLongPressGesture)
        
        
        scoreContainer = UIView()
        scoreContainer.backgroundColor = UIColor.white
        scoreContainer.layer.cornerRadius = 2.0
        scoreContainer.layer.masksToBounds = true
        container.addSubview(scoreContainer)
        scoreContainer.addConstraints(fromStringArray: ["H:|-12-[$self(56)]",
                                                        "V:[$self(28)]-16-|"])
        
        scoreIcon = UIImageView(image: R.image.icon_star())
        scoreIcon.tintColor = KPColorPalette.KPMainColor_v2.starColor
        scoreContainer.addSubview(scoreIcon)
        scoreIcon.addConstraints(fromStringArray: ["H:|-4-[$self(18)]",
                                                   "V:|-5-[$self]-5-|"])
        
        scoreLabel = UILabel()
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        scoreLabel.textColor = KPColorPalette.KPTextColor.mainColor
        scoreLabel.text = "0.0"
        scoreContainer.addSubview(scoreLabel)
        scoreLabel.addConstraints(fromStringArray: ["H:[$view0]-2-[$self]-|"],
                                  views:[scoreIcon])
        scoreLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        scoreTapGesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(KPInformationHeaderView.handleScoreContainerOnTapped(_:)))
        scoreContainer.addGestureRecognizer(scoreTapGesture)
        
        facebookButton = UIButton(type: .custom)
        facebookButton.setBackgroundImage(UIImage(color: UIColor.white),
                                          for: .normal)
        facebookButton.setImage(R.image.icon_fb(),
                                for: .normal)
        facebookButton.layer.cornerRadius = 2.0
        facebookButton.layer.masksToBounds = true
        facebookButton.imageView?.tintColor = KPColorPalette.KPMainColor_v2.mainColor
        container.addSubview(facebookButton)
        facebookButton.addConstraints(fromStringArray: ["H:[$view0]-8-[$self(28)]",
                                                        "V:[$self(28)]-16-|"],
                                      views:[scoreContainer])
        
        
        morePhotoButton = UIButton(type: .custom)
        morePhotoButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.grayColor_level5!),
                                           for: .normal)
        morePhotoButton.layer.cornerRadius = 2.0
        morePhotoButton.layer.masksToBounds = true
        morePhotoButton.layer.borderWidth = 1.0
        morePhotoButton.layer.borderColor = KPColorPalette.KPMainColor_v2.whiteColor_level1?.cgColor
        morePhotoButton.setTitle("上傳\n照片", for: .normal)
        morePhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        morePhotoButton.titleLabel?.numberOfLines = 0
        morePhotoButton.titleLabel?.textAlignment = NSTextAlignment.center
        morePhotoButton.setTitleColor(UIColor.white, for: .normal)
        container.addSubview(morePhotoButton)
        morePhotoButton.addConstraints(fromStringArray: ["H:[$self(48)]-16-|",
                                                         "V:[$self(48)]-16-|"])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleShopPhotoLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.shopSelectView.alpha = 1
            })
        } else if sender.state == .ended {
            UIView.animate(withDuration: 0.1,
                           animations: {
                            self.shopSelectView.alpha = 0
            }, completion: { (success) in
                self.delegate?.headerPhotoTapped(self)
            })
        }
    }
    
    @objc func handleScoreContainerOnTapped(_ sender: UITapGestureRecognizer) {
        scoreHandler?()
    }
    
    
}
