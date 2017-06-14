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

class KPInformationHeaderView: UIView {

    
    var cafeID: String!
    var container: UIView!
    var shopPhotoContainer: UIView!
    var shopPhoto: UIImageView!
    var morePhotoButton: UIButton!;
    var photoLongPressGesture: UILongPressGestureRecognizer!
    
    var scoreContainer: UIView!;
    var facebookButton: UIButton!;
    var otherPhotoContainer: UIView!;
    
    var collectButton: KPInformationHeaderButton!;
    var checkButton: KPInformationHeaderButton!;
    var rateButton: KPInformationHeaderButton!;
    var commentButton: KPInformationHeaderButton!;
    
    weak open var delegate: KPInformationHeaderViewDelegate?
    
    convenience init (frame: CGRect,
                      cafeIdentifier: String) {
        self.init(frame: frame);
        self.cafeID = cafeIdentifier
        collectButton.buttonInfo = HeaderButtonInfo(title: "收藏",
                                                    info: "0人已收藏",
                                                    icon: R.image.icon_collect()!,
                                                    handler: { (headerButton) -> () in
                                                        print("Test Handler");
                                                        
                                                        headerButton.selected = !(headerButton.selected)
                                                        
                                                        if headerButton.selected {
                                                            KPUserManager.sharedManager.addFavoriteCafe(self.cafeID)
                                                        } else {
                                                            KPUserManager.sharedManager.removeFavoriteCafe(self.cafeID)
                                                        }
        });
        
        checkButton.buttonInfo = HeaderButtonInfo(title: "我要打卡",
                                                  info: "194人來做",
                                                  icon: R.image.icon_map()!,
                                                  handler: { (headerButton) -> () in
                                                    print("Test Handler");
        });
        
        rateButton.buttonInfo = HeaderButtonInfo(title: "我要評分",
                                                 info: "尚無評分",
                                                 icon: R.image.icon_star()!,
                                                 handler: { (headerButton) -> () in
                                                    print("Test Handler");
        });
        
        commentButton.buttonInfo = HeaderButtonInfo(title: "已評價",
                                                    info: "29人已留言",
                                                    icon: R.image.icon_comment()!,
                                                    handler: { (headerButton) -> () in
                                                        print("Test Handler");
        });
    }
    
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
                                                            "V:|[$self]"])
        
        shopPhoto = UIImageView(image: UIImage(named: "demo_1"))
        shopPhoto.contentMode = .scaleToFill
        shopPhoto.isUserInteractionEnabled = true
        shopPhotoContainer.addSubview(shopPhoto)
        shopPhoto.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:|[$self(240)]|"])

        photoLongPressGesture = UILongPressGestureRecognizer.init(target: self,
                                                                       action: #selector(handleShopPhotoLongPressed(_:)))
        photoLongPressGesture.minimumPressDuration = 0.0
        shopPhoto.addGestureRecognizer(photoLongPressGesture)
        
        collectButton = KPInformationHeaderButton();
        
        container.addSubview(collectButton);
        collectButton.addConstraints(fromStringArray: ["H:|[$self($metric0)]", "V:[$view0][$self(90)]|"],
                                     metrics: [UIScreen.main.bounds.size.width/4],
                                     views: [shopPhotoContainer]);
        
        
        checkButton = KPInformationHeaderButton();
        container.addSubview(checkButton);
        checkButton.addConstraints(fromStringArray: ["H:[$view0]-(-1)-[$self($metric0)]", "V:[$view1][$self(90)]|"],
                                   metrics: [UIScreen.main.bounds.size.width/4+1],
                                   views: [collectButton, shopPhotoContainer]);
        
        
        rateButton = KPInformationHeaderButton();
        container.addSubview(rateButton);
        rateButton.addConstraints(fromStringArray: ["H:[$view0]-(-1)-[$self($metric0)]", "V:[$view1][$self(90)]|"],
                                        metrics: [UIScreen.main.bounds.size.width/4+1],
                                        views: [checkButton, shopPhotoContainer]);
        
        
        commentButton = KPInformationHeaderButton();
        container.addSubview(commentButton);
        commentButton.addConstraints(fromStringArray: ["H:[$view0]-(-1)-[$self($metric0)]",
                                                       "V:[$view1][$self(90)]|"],
                                        metrics: [UIScreen.main.bounds.size.width/4+1],
                                        views: [rateButton, shopPhotoContainer]);
        
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
                                                         "V:[$self(48)]-16-[$view0]"],
                                       views:[commentButton])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleShopPhotoLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.began {
            UIView.animate(withDuration: 0.2,
                           animations: { 
                            self.shopPhoto.transform = CGAffineTransform.init(scaleX: 0.97,
                                                                              y: 0.97)
            })
        } else if sender.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.1,
                           animations: { 
                            self.shopPhoto.transform = CGAffineTransform.identity
            }, completion: { (success) in
                self.delegate?.headerPhotoTapped(self);
            })
        }
        
    }
    
    
}
