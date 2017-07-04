//
//  KPSatisficationView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/6/30.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSatisficationView: UIView {

    var icon: UIImageView!
    
    var container: UIView!
    var contentContainer: UIView!
    var titleLabel: KPLayerLabel!
    var descriptionLabel: KPLayerLabel!
    var dislikeButton: UIButton!
    var likeButton: UIButton!
    var dismissButton: KPBounceButton!
    
    struct Constants {
        static let viewHeight: CGFloat = UIDevice().isSuperCompact ? 150 : 160
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = KPColorPalette.KPMainColor.mainColor
        
        container = UIView()
        addSubview(container)
        container.addConstraints(fromStringArray: ["V:|[$self]|"])
        container.addConstraint(forWidth: UIDevice().isSuperCompact ? 320 : 360)
        container.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        dismissButton = KPBounceButton()
        dismissButton.setImage(R.image.icon_close(),
                               for: .normal)
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.addTarget(self,
                                action: #selector(KPSatisficationView.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        addSubview(dismissButton)
        dismissButton.addConstraints(fromStringArray: ["V:|-12-[$self(24)]",
                                                       "H:[$self(24)]-12-|"])
        
        icon = UIImageView(image: R.image.image_icon_login())
        icon.contentMode = .scaleAspectFit
        container.addSubview(icon)
        let _ = icon.addConstraintForCenterAligningToSuperview(in: .vertical)
        let _ = icon.addConstraint(from: "H:|-24-[$self(80)]")
        
        contentContainer = UIView()
        container.addSubview(contentContainer)
        contentContainer.addConstraints(fromStringArray: ["H:[$view0]-($metric0)-[$self]"],
                                        metrics :[UIDevice().isSuperCompact ? 20.0 : 30.0],
                                        views: [icon])
        contentContainer.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        titleLabel = KPLayerLabel();
        titleLabel.font = UIFont.systemFont(ofSize: UIDevice().isSuperCompact ? 18.0 : 21.0);
        titleLabel.textColor = KPColorPalette.KPTextColor.whiteColor;
        titleLabel.text = "找咖啡滿意度調查"
        titleLabel.isOpaque = true
        titleLabel.layer.masksToBounds = true
        contentContainer.addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["V:|[$self]",
                                                    "H:|[$self]"])
        
        
        descriptionLabel = KPLayerLabel();
        descriptionLabel.font = UIFont.systemFont(ofSize: UIDevice().isSuperCompact ? 13.0 : 15.0);
        descriptionLabel.textColor = KPColorPalette.KPTextColor.whiteColor;
        descriptionLabel.text = "請問你喜歡我們的產品嗎"
        descriptionLabel.isOpaque = true
        descriptionLabel.layer.masksToBounds = true
        contentContainer.addSubview(descriptionLabel);
        descriptionLabel.addConstraints(fromStringArray: ["V:[$view0]-6-[$self]",
                                                          "H:|[$self]"],
                                        views: [titleLabel])
        
        dislikeButton = UIButton(type: .custom)
        dislikeButton.setTitle("不喜歡", for: .normal)
        dislikeButton.layer.cornerRadius = 2.0
        dislikeButton.layer.masksToBounds = true
        dislikeButton.titleLabel?.font = UIFont.systemFont(ofSize: UIDevice().isSuperCompact ? 13.0 : 15.0)
        dislikeButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.cellScoreBgColor!),
                                         for: .normal)
        contentContainer.addSubview(dislikeButton)
        dislikeButton.addConstraints(fromStringArray:
            ["V:[$view0]-24-[$self(36)]|",
             "H:|[$self($metric0)]"],
                                     metrics :[UIDevice().isSuperCompact ? 68.0 : 80.0],
                                     views: [descriptionLabel])
        
        likeButton = UIButton(type: .custom)
        likeButton.setTitle("很喜歡", for: .normal)
        likeButton.layer.cornerRadius = 2.0
        likeButton.layer.masksToBounds = true
        likeButton.titleLabel?.font = UIFont.systemFont(ofSize: UIDevice().isSuperCompact ? 13.0 : 15.0)
        likeButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor.mainColor_light!),
        for: .normal)
        contentContainer.addSubview(likeButton)
        likeButton.addConstraints(fromStringArray:
            ["V:[$view0]-24-[$self(36)]|",
             "H:[$view1]-8-[$self($metric0)]|"],
                                  metrics :[UIDevice().isSuperCompact ? 68.0 : 80.0],
                                  views: [descriptionLabel, dislikeButton])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleDismissButtonOnTapped() {
        hideSatisfication()
    }
    
    func showSatisfication() {
        UIApplication.shared.topView?.addSubview(self)
        
        removeAllRelatedConstraintsInSuperView()
        addConstraints(fromStringArray: ["H:|[$self]|",
                                         "V:[$self($metric0)]-($metric1)-|"],
                       metrics:[Constants.viewHeight, -Constants.viewHeight])
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.7,
                       options: .curveEaseOut,
                       animations: { 
                        self.transform = CGAffineTransform(translationX: 0, y: -Constants.viewHeight
                        )
        }) { (_) in
            
        }
    }
    
    func hideSatisfication() {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.7,
                       options: .curveEaseOut,
                       animations: {
                        self.transform = .identity
        }) { (_) in
            
        }
    }
    

}
