//
//  KPPhotoDisplayCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/9.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPPhotoDisplayCell: UICollectionViewCell {
    
    var shopPhoto: UIImageView!
    
    var longPressGesture: UILongPressGestureRecognizer!
    var panGesture: UIPanGestureRecognizer!
    
    var draggable: Bool = false
    var startAnchorPoint: CGPoint!
    var lastMovePoint: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        shopPhoto = UIImageView()
        shopPhoto.layer.cornerRadius = 2.0
        shopPhoto.layer.masksToBounds = true
        shopPhoto.contentMode = .scaleAspectFit
        shopPhoto.isUserInteractionEnabled = true
        addSubview(shopPhoto)
        shopPhoto.addConstraintForCenterAligningToSuperview(in:.vertical)
        shopPhoto.addConstraintForCenterAligningToSuperview(in:.horizontal)
        shopPhoto.addConstraint(from: "H:|[$self]|")
        shopPhoto.addConstraint(from: "V:|[$self]|")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
