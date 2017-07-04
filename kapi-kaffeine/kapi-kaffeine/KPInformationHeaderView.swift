//
//  KPInformationHeaderView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

protocol KPInformationHeaderViewDelegate: NSObjectProtocol {
    func headerPhotoTapped(_ headerView: KPInformationHeaderView);
}

class KPInformationHeaderButtonBar: UIView {
    
    var collectButton: KPInformationHeaderButton!;
    var checkButton: KPInformationHeaderButton!;
    var rateButton: KPInformationHeaderButton!;
    var commentButton: KPInformationHeaderButton!;
    var cafeID: String!
    weak open var informationController: KPInformationViewController?
    
    convenience init (frame: CGRect,
                      cafeIdentifier: String) {
        self.init(frame: frame);
        self.cafeID = cafeIdentifier
        
        collectButton = KPInformationHeaderButton();
        
        addSubview(collectButton);
        collectButton.addConstraints(fromStringArray: ["H:|[$self($metric0)]", "V:|[$self(90)]|"],
                                     metrics: [UIScreen.main.bounds.size.width/4]);
        
        
        checkButton = KPInformationHeaderButton();
        addSubview(checkButton);
        checkButton.addConstraints(fromStringArray: ["H:[$view0]-(-1)-[$self($metric0)]",
                                                     "V:|[$self(90)]|"],
                                   metrics: [UIScreen.main.bounds.size.width/4+1],
                                   views: [collectButton]);
        
        
        rateButton = KPInformationHeaderButton();
        addSubview(rateButton);
        rateButton.addConstraints(fromStringArray: ["H:[$view0]-(-1)-[$self($metric0)]",
                                                    "V:|[$self(90)]|"],
                                  metrics: [UIScreen.main.bounds.size.width/4+1],
                                  views: [checkButton]);
        
        
        commentButton = KPInformationHeaderButton();
        addSubview(commentButton);
        commentButton.addConstraints(fromStringArray: ["H:[$view0]-(-1)-[$self($metric0)]",
                                                       "V:|[$self(90)]|"],
                                     metrics: [UIScreen.main.bounds.size.width/4+1],
                                     views: [rateButton]);
        
        collectButton.buttonInfo = HeaderButtonInfo(title: "收藏",
                                                    info: "%d人已收藏",
                                                    defaultInfo: "無人收藏",
                                                    icon: R.image.icon_collect()!,
                                                    handler: { (headerButton) -> () in
                                                        if headerButton.selected == false {
                                                            headerButton.selected = true
                                                            KPUserManager.sharedManager.addFavoriteCafe(self.cafeID)
                                                        } else {
                                                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                                KPPopoverView.popoverDefaultStyleContent("移除收藏",
                                                                                                         "請問你這傢伙確定要移除收藏這間超級無敵優秀的咖啡廳嗎？",
                                                                                                         "我慚愧", { (content) in
                                                                                                            print("Test Content")
                                                                                                            content.popoverView.dismiss()
                                                                                                            headerButton.selected = false
                                                                                                            KPUserManager.sharedManager.removeFavoriteCafe(self.cafeID)
                                                                })
                                                            }
                                                            
                                                        }
        });
        
        checkButton.buttonInfo = HeaderButtonInfo(title: "我要打卡",
                                                  info: "%d人來做",
                                                  defaultInfo: "無人打卡",
                                                  icon: R.image.icon_map()!,
                                                  handler: { (headerButton) -> () in
                                                    
                                                    if headerButton.selected == false {
                                                        headerButton.selected = true
                                                        KPUserManager.sharedManager.addVisitedCafe(self.cafeID)
                                                    } else {
                                                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                            KPPopoverView.popoverDefaultStyleContent("移除打卡",
                                                                                                     "請問你這傢伙確定要說你沒有去過這間超級無敵優秀的咖啡廳嗎？",
                                                                                                     "我慚愧", { (content) in
                                                                                                        print("Test Content")
                                                                                                        content.popoverView.dismiss()
                                                                                                        headerButton.selected = false
                                                                                                        KPUserManager.sharedManager.removeVisitedCafe(self.cafeID)
                                                            })
                                                        }
                                                        
                                                    }
        });
        
        rateButton.buttonInfo = HeaderButtonInfo(title: "我要評分",
                                                 info: "%d人已評分",
                                                 defaultInfo: "尚無評分",
                                                 icon: R.image.icon_star()!,
                                                 handler: { (headerButton) -> () in
                                                    let controller = KPModalViewController()
//                                                    controller.edgeInset = UIEdgeInsets.init(top: 0,
//                                                                                             left: 0,
//                                                                                             bottom: 0,
//                                                                                             right: 0)
                                                    controller.edgeInset = UIEdgeInsets.init(top: UIDevice().isCompact ? 32 : 40,
                                                                                             left: 0,
                                                                                             bottom: 0,
                                                                                             right: 0)
                                                    controller.cornerRadius = [.topRight, .topLeft, .bottomLeft, .bottomRight]
                                                    let ratingViewController = KPRatingViewController()
                                                    controller.contentController = ratingViewController
                                                    controller.presentModalView()
        });
        
        commentButton.buttonInfo = HeaderButtonInfo(title: "我要評價",
                                                    info: "%d人已留言",
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
        });
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class KPInformationHeaderView: UIView {

    
//    var cafeID: String!
    var container: UIView!
    var shopPhotoContainer: UIView!
    var shopPhoto: UIImageView!
    var shopSelectView: UIView!
    var morePhotoButton: UIButton!;
    var photoLongPressGesture: UILongPressGestureRecognizer!
    
    var scoreContainer: UIView!;
    var facebookButton: UIButton!;
    var otherPhotoContainer: UIView!;

    weak open var delegate: KPInformationHeaderViewDelegate?
    weak open var informationController: KPInformationViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        container = UIView()
        addSubview(container)
        container.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:|[$self]|"])
        
        shopPhotoContainer = UIView()
        shopPhotoContainer.clipsToBounds = true
        container.addSubview(shopPhotoContainer)
        shopPhotoContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                            "V:|[$self]|"])
        
        shopPhoto = UIImageView(image: UIImage(named: "demo_1"))
        shopPhoto.contentMode = .scaleToFill
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

        photoLongPressGesture = UILongPressGestureRecognizer.init(target: self,
                                                                       action: #selector(handleShopPhotoLongPressed(_:)))
        photoLongPressGesture.minimumPressDuration = 0.0
        shopPhoto.addGestureRecognizer(photoLongPressGesture)
        
        morePhotoButton = UIButton.init(type: .custom)
        morePhotoButton.setBackgroundImage(UIImage.init(color: UIColor.clear), for: .normal)
        morePhotoButton.layer.cornerRadius = 2.0
        morePhotoButton.layer.borderWidth = 1.0
        morePhotoButton.layer.borderColor = UIColor.white.cgColor
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
        
        if sender.state == UIGestureRecognizerState.began {
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.shopSelectView.alpha = 1
//                            self.shopPhoto.transform = CGAffineTransform.init(scaleX: 0.97,
//                                                                              y: 0.97)
            })
        } else if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.1,
                           animations: {
                            self.shopSelectView.alpha = 0
//                            self.shopPhoto.transform = CGAffineTransform.identity
            }, completion: { (success) in
                self.delegate?.headerPhotoTapped(self);
            })
        }
        
    }
    
    
}
