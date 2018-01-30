//
//  KPSearchViewHeaderLabel.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/6/22.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchViewHeaderLabel: UIView {

    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        label.text = "搜尋結果"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        backgroundColor = UIColor.white
        
        addSubview(headerLabel)
        headerLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        headerLabel.addConstraint(from: "H:|-16-[$self]")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
