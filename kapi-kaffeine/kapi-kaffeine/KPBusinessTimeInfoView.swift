//
//  KPBusinessTimeInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/7.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPBusinessTimeInfoView: UIView {

    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "星期未知"
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = KPColorPalette.KPTextColor.grayColor_level1
        return label
    }()
    
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "11:30-21:30"
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.textAlignment = .right
        return label
    }()
    
    
    //----------------------------
    // MARK: - Initalization
    //----------------------------
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ dayTitle: String,
                     _ timeContent: String) {
        self.init(frame: .zero)
        
        addSubview(dayLabel)
        dayLabel.text = dayTitle
        dayLabel.addConstraints(fromStringArray: ["V:|[$self]|",
                                                  "H:|[$self]"])
        
        addSubview(timeLabel)
        timeLabel.text = timeContent
        timeLabel.addConstraints(fromStringArray: ["V:|[$self]|",
                                                   "H:[$self]|"])
        
    }
    
    
}
