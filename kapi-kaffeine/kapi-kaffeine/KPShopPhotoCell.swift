//
//  KPShopPhotoCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/18.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopPhotoCell: UICollectionViewCell {
    
    var shopPhoto: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        alpha = 0.4
        
        shopPhoto = UIImageView()
        shopPhoto.contentMode = .scaleAspectFit
        shopPhoto.layer.cornerRadius = 2.0
        shopPhoto.layer.masksToBounds = true
        shopPhoto.image = R.image.demo_1()
        shopPhoto.contentMode = .scaleAspectFill
        addSubview(shopPhoto)
        shopPhoto.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:|[$self]|"])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
