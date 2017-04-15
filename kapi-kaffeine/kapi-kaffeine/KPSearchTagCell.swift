//
//  KPSearchTagCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchTagCell: UICollectionViewCell {
    
    var tagTitle:UILabel!
    var tagIcon:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.backgroundColor = UIColor.white;
        
        self.tagIcon = UIImageView();
        self.addSubview(self.tagIcon);
        self.tagIcon.addConstraints(fromStringArray: ["H:|-6-[$self(20)]",
                                                      "V:|-6-[$self(20)]-6-|"]);
        
        self.tagTitle = UILabel();
        self.tagTitle.font = UIFont.systemFont(ofSize: 13.0);
        self.tagTitle.textColor = KPColorPalette.KPMainColor.mainColor;
        self.addSubview(self.tagTitle);
        self.tagTitle.addConstraints(fromStringArray: ["H:[$view0]-4-[$self]-6-|"],
                                     views: [self.tagIcon]);
        self.tagTitle.addConstraintForCenterAligningToSuperview(in: .vertical);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
