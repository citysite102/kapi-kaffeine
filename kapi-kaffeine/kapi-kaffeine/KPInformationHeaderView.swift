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

    var shopPhotoContainer: UIView!
    var shopPhoto: UIImageView!
    var photoLongPressGesture: UILongPressGestureRecognizer!
    
    var scoreContainer: UIView!;
    var facebookButton: UIButton!;
    var otherPhotoContainer: UIView!;
    
    var collectButton: KPInformationHeaderButton!;
    var checkButton: KPInformationHeaderButton!;
    var rateButton: KPInformationHeaderButton!;
    var commentButton: KPInformationHeaderButton!;
    
    weak open var delegate: KPInformationHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.shopPhotoContainer = UIView()
        self.addSubview(self.shopPhotoContainer)
        self.shopPhotoContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                 "V:|[$self]"])
        
        self.shopPhoto = UIImageView(image: UIImage(named: "demo_1"))
        self.shopPhoto.contentMode = .scaleToFill
        self.shopPhoto.isUserInteractionEnabled = true
        self.shopPhotoContainer.addSubview(shopPhoto)
        self.shopPhoto.addConstraints(fromStringArray: ["H:|[$self]|",
                                                        "V:|[$self(240)]|"])

        self.photoLongPressGesture = UILongPressGestureRecognizer.init(target: self,
                                                                       action: #selector(handleShopPhotoLongPressed(_:)))
        self.photoLongPressGesture.minimumPressDuration = 0
        self.shopPhoto.addGestureRecognizer(self.photoLongPressGesture)
        
        self.collectButton = KPInformationHeaderButton();
        self.collectButton.buttonInfo = HeaderButtonInfo(title: "收藏",
                                                         info: "0人已收藏",
                                                         icon: UIImage.init(named: "icon_clock")!,
                                                         handler: { (headerButton) -> () in print("Test Handler");
        });
        self.addSubview(self.collectButton);
        self.collectButton.addConstraints(fromStringArray: ["H:|[$self($metric0)]", "V:[$view0][$self(90)]|"],
                                          metrics: [UIScreen.main.bounds.size.width/4],
            views: [self.shopPhoto]);
        
        
        self.checkButton = KPInformationHeaderButton();
        self.checkButton.buttonInfo = HeaderButtonInfo(title: "我要打卡",
                                                         info: "194人來做",
                                                         icon: UIImage.init(named: "icon_clock")!,
                                                         handler: { (headerButton) -> () in print("Test Handler");
        });
        self.addSubview(self.checkButton);
        self.checkButton.addConstraints(fromStringArray: ["H:[$view0]-(-1)-[$self($metric0)]", "V:[$view1][$self(90)]|"],
                                          metrics: [UIScreen.main.bounds.size.width/4+1],
                                          views: [self.collectButton, self.shopPhoto]);
        
        
        self.rateButton = KPInformationHeaderButton();
        self.rateButton.buttonInfo = HeaderButtonInfo(title: "我要評分",
                                                       info: "尚無評分",
                                                       icon: UIImage.init(named: "icon_clock")!,
                                                       handler: { (headerButton) -> () in print("Test Handler");
        });
        self.addSubview(self.rateButton);
        self.rateButton.addConstraints(fromStringArray: ["H:[$view0]-(-1)-[$self($metric0)]", "V:[$view1][$self(90)]|"],
                                        metrics: [UIScreen.main.bounds.size.width/4+1],
                                        views: [self.checkButton, self.shopPhoto]);
        
        
        self.commentButton = KPInformationHeaderButton();
        self.commentButton.buttonInfo = HeaderButtonInfo(title: "已評價",
                                                       info: "29人已留言",
                                                       icon: UIImage.init(named: "icon_clock")!,
                                                       handler: { (headerButton) -> () in print("Test Handler");
        });
        self.addSubview(self.commentButton);
        self.commentButton.addConstraints(fromStringArray: ["H:[$view0]-(-1)-[$self($metric0)]", "V:[$view1][$self(90)]|"],
                                        metrics: [UIScreen.main.bounds.size.width/4+1],
                                        views: [self.rateButton, self.shopPhoto]);
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
