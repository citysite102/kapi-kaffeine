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
    lazy var photoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        return label
    }()
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.black;
        self.alpha = 0.4;
        
        addSubview(photoTitleLabel)
        photoTitleLabel.text = "覺旅咖啡 Journey Cafe"
        photoTitleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        photoTitleLabel.addConstraint(from: "V:|-16-[$self]")
        
        addSubview(countLabel)
        countLabel.text = "6 of 104"
        countLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        countLabel.addConstraint(from: "V:[$self]-32-|")
        
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
