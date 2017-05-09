//
//  KPPhotoDisplayCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/9.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPPhotoDisplayCell: UICollectionViewCell {
    
    var shopPhoto:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.black;
        self.alpha = 0.4;
        
        self.shopPhoto = UIImageView();
        self.shopPhoto.layer.cornerRadius = 2.0;
        self.shopPhoto.layer.masksToBounds = true;
        self.shopPhoto.contentMode = .scaleAspectFit;
        self.addSubview(self.shopPhoto);
        self.shopPhoto.addConstraintForCenterAligningToSuperview(in:.vertical)
        self.shopPhoto.addConstraintForCenterAligningToSuperview(in:.horizontal)
        self.shopPhoto.addConstraint(from: "H:|[$self]|")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
