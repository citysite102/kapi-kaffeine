//
//  KPLocationSelect.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2018/1/31.
//  Copyright © 2018年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPLocationSelect: UIView {

    var dropDownIcon: UIImageView!
    var locationLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        locationLabel = UILabel()
        locationLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        locationLabel.text = "台北"
        locationLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor
        addSubview(locationLabel)
        locationLabel.addConstraints(fromStringArray: ["H:|[$self]"])
        locationLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        
        dropDownIcon = UIImageView(image: R.image.icon_dropdown())
        dropDownIcon.tintColor = KPColorPalette.KPMainColor_v2.mainColor
        addSubview(dropDownIcon)
        dropDownIcon.addConstraints(fromStringArray: ["V:[$self(18)]",
                                                      "H:[$view0]-4-[$self(18)]|"], views:[locationLabel])
        dropDownIcon.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        
    }

}