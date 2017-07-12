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
    
    var collectButton: KPInformationHeaderButton!
    var visitButton: KPInformationHeaderButton!
    var rateButton: KPInformationHeaderButton!
    var commentButton: KPInformationHeaderButton!
    var informationDataModel: KPDataModel! {
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
        }
    }
    weak open var informationController: KPInformationViewController?
    
    convenience init (frame: CGRect,
                      informationDataModel: KPDataModel) {
        self.init(frame: frame)
        self.informationDataModel = informationDataModel
        
        collectButton = KPInformationHeaderButton()
        addSubview(collectButton)
        collectButton.addConstraints(fromStringArray: ["H:|[$self($metric0)]", "V:|[$self(90)]|"],
                                     metrics: [UIScreen.main.bounds.size.width/4])
        
        
        visitButton = KPInformationHeaderButton()
        addSubview(visitButton)
        visitButton.addConstraints(fromStringArray: ["H:[$view0]-(-1)-[$self($metric0)]",
                                                     "V:|[$self(90)]|"],
                                   metrics: [UIScreen.main.bounds.size.width/4+1],
                                   views: [collectButton])
        
        
        rateButton = KPInformationHeaderButton()
        addSubview(rateButton)
        rateButton.addConstraints(fromStringArray: ["H:[$view0]-(-1)-[$self($metric0)]",
                                                    "V:|[$self(90)]|"],
                                  metrics: [UIScreen.main.bounds.size.width/4+1],
                                  views: [visitButton])
        
        
        commentButton = KPInformationHeaderButton()
        addSubview(commentButton)
        commentButton.addConstraints(fromStringArray: ["H:[$view0]-(-1)-[$self($metric0)]",
                                                       "V:|[$self(90)]|"],
                                     metrics: [UIScreen.main.bounds.size.width/4+1],
                                     views: [rateButton])
        
        collectButton.buttonInfo = HeaderButtonInfo(title: "收藏",
                                                    info: "%d人已收藏",
                                                    defaultInfo: "無人收藏",
                                                    icon: R.image.icon_collect()!,
                                                    handler: { (headerButton) -> () in
                                                        if headerButton.selected == false {
                                                            headerButton.selected = true
                                                            headerButton.numberValue = headerButton.numberValue + 1
                                                            KPServiceHandler.sharedHandler.addFavoriteCafe()
                                                        } else {
                                                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                                KPPopoverView.popoverDefaultStyleContent(
                                                                    "移除收藏",
                                                                    "請問你這傢伙確定要移除收藏這間超級無敵優秀的咖啡廳嗎？",
                                                                    "我慚愧", { (content) in
                                                                        content.popoverView.dismiss()
                                                                        headerButton.selected = false
                                                                        headerButton.numberValue = headerButton.numberValue - 1
                                                                        KPServiceHandler.sharedHandler.removeFavoriteCafe(self.informationDataModel.identifier, { (successed) in
                                                                        })
                                                                })
                                                            }
                                                            
                                                        }
        })
        
        visitButton.buttonInfo = HeaderButtonInfo(title: "我要打卡",
                                                  info: "%d人來做",
                                                  defaultInfo: "無人打卡",
                                                  icon: R.image.icon_map()!,
                                                  handler: { (headerButton) -> () in
                                                    
                                                    if headerButton.selected == false {
                                                        headerButton.selected = true
                                                        headerButton.numberValue = headerButton.numberValue + 1
                                                        KPServiceHandler.sharedHandler.addVisitedCafe()
                                                    } else {
                                                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                            KPPopoverView.popoverDefaultStyleContent(
                                                                "移除打卡",
                                                                "請問你這傢伙確定要說你沒有去過這間超級無敵優秀的咖啡廳嗎？",
                                                                "我慚愧", { (content) in
                                                                    content.popoverView.dismiss()
                                                                    headerButton.selected = false
                                                                    headerButton.numberValue = headerButton.numberValue - 1
                                                                    KPServiceHandler.sharedHandler.removeVisitedCafe(self.informationDataModel.identifier, { (successed) in
                                                                    })
                                                            })
                                                        }
                                                        
                                                    }
        })
        
        rateButton.buttonInfo = HeaderButtonInfo(title: "我要評分",
                                                 info: "%d人已評分",
                                                 defaultInfo: "尚無評分",
                                                 icon: R.image.icon_star()!,
                                                 handler: { (headerButton) -> () in
                                                    let controller = KPModalViewController()
                                                    controller.edgeInset = UIEdgeInsets(top: UIDevice().isCompact ? 32 : 40,
                                                                                        left: 0,
                                                                                        bottom: 0,
                                                                                        right: 0)
                                                    controller.cornerRadius = [.topRight, .topLeft, .bottomLeft, .bottomRight]
                                                    let ratingViewController = KPRatingViewController()
                                                    if ((KPUserManager.sharedManager.currentUser?.hasRated) != nil) {
                                                        if let rate = self.informationDataModel.rates?.rates?.first(where: {$0.memberID == KPUserManager.sharedManager.currentUser?.identifier}) {
                                                            ratingViewController.defaultRateModel = rate
                                                        }
                                                    }
                                                    controller.contentController = ratingViewController
                                                    controller.presentModalView()
        })
        
        commentButton.buttonInfo = HeaderButtonInfo(title: "我要評價",
                                                    info: "%d人已評價",
                                                    defaultInfo: "尚無評價",
                                                    icon: R.image.icon_comment()!,
                                                    handler: { (headerButton) -> () in
                                                        let newCommentViewController = KPNewCommentController()
                                                        if self.informationController != nil {
                                                            self.informationController?.navigationController?.pushViewController(viewController:
                                                                newCommentViewController,
                                                                                                                                 animated: true,
                                                                                                                                 completion: {})
                                                        }
        })
        
        collectButton.selected = (KPUserManager.sharedManager.currentUser?.hasFavorited(self.informationDataModel.identifier)) ?? false
        visitButton.selected = (KPUserManager.sharedManager.currentUser?.hasVisited(self.informationDataModel.identifier)) ?? false
        rateButton.selected = (KPUserManager.sharedManager.currentUser?.hasRated(self.informationDataModel.identifier)) ?? false
        commentButton.selected = (KPUserManager.sharedManager.currentUser?.hasReviewed(self.informationDataModel.identifier)) ?? false
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    var facebookButton: UIButton!
    var otherPhotoContainer: UIView!

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
        
//        shopPhoto = UIImageView(image: UIImage(color:KPColorPalette.KPMainColor.borderColor!))
        shopPhoto = UIImageView(image: R.image.demo_2())
        shopPhoto.contentMode = .scaleAspectFill
        shopPhoto.isUserInteractionEnabled = true
        shopPhotoContainer.addSubview(shopPhoto)
        shopPhoto.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:|[$self(240)]|"])
        
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
        
        morePhotoButton = UIButton(type: .custom)
        morePhotoButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.grayColor_level5!),
                                           for: .normal)
        morePhotoButton.layer.cornerRadius = 2.0
        morePhotoButton.layer.masksToBounds = true
        morePhotoButton.layer.borderWidth = 1.0
        morePhotoButton.layer.borderColor = KPColorPalette.KPMainColor.whiteColor_level1?.cgColor
        morePhotoButton.setTitle("99+\n張照片", for: .normal)
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
    
    func handleShopPhotoLongPressed(_ sender: UILongPressGestureRecognizer) {
        
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
    
    
}
