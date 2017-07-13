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
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        alpha = 0.4
        
        tagIcon = UIImageView()
        addSubview(tagIcon)
        tagIcon.addConstraints(fromStringArray: ["H:|-6-[$self(20)]",
                                                      "V:|-6-[$self(20)]-6-|"])
        tagIcon.tintColor = KPColorPalette.KPMainColor.mainColor
        
        tagTitle = UILabel()
        tagTitle.font = UIFont.systemFont(ofSize: 13.0)
        tagTitle.textColor = KPColorPalette.KPTextColor.mainColor
        addSubview(tagTitle)
        tagTitle.addConstraints(fromStringArray: ["H:[$view0]-4-[$self]-6-|"],
                                     views: [tagIcon])
        tagTitle.addConstraintForCenterAligningToSuperview(in: .vertical)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
