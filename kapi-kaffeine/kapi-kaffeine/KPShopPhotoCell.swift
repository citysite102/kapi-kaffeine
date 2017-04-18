//
//  KPShopPhotoCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/18.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopPhotoCell: UICollectionViewCell {
    
    var shopPhoto:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.white;
        self.alpha = 0.4;
        
        self.shopPhoto = UIImageView();
        self.shopPhoto.image = UIImage.init(named: "image_shop_demo");
        self.shopPhoto.contentMode = .scaleToFill;
        self.addSubview(self.shopPhoto);
        self.shopPhoto.addConstraints(fromStringArray: ["H:|[$self(96)]|",
                                                      "V:|[$self(96)]|"]);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
