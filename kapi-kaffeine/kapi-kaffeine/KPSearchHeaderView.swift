//
//  KPSearchHeaderView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchHeaderView: UIView {

    var titleLabel: UILabel!
    var searchButton: UIButton!
    var styleButton: UIButton!
    var searchTagView: KPSearchTagView!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = KPColorPalette.KPMainColor.mainColor;
        
        self.titleLabel = UILabel();
        self.titleLabel.font = UIFont.systemFont(ofSize: 18.0);
        self.titleLabel.textColor = KPColorPalette.KPTextColor.whiteColor;
        self.titleLabel.text = "找咖啡";
        self.addSubview(self.titleLabel);
        self.titleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal);
        self.titleLabel.addConstraint(from: "V:|-32-[$self]");
        
        self.styleButton = UIButton(type: .system);
        self.addSubview(self.styleButton);
        self.styleButton.addConstraints(fromStringArray: ["H:[$self(24)]-8-|",
                                                          "V:[$self(24)]"]);
        self.styleButton.addConstraintForCenterAligning(to: self.titleLabel, in: .vertical);
        self.styleButton.setImage(UIImage.init(named: "icon_map")?.withRenderingMode(.alwaysTemplate),
                                  for: .normal);
        self.styleButton.tintColor = UIColor.white;
        self.searchTagView = KPSearchTagView();
        self.addSubview(self.searchTagView);
        self.searchTagView.addConstraints(fromStringArray: ["V:[$self(40)]|",
                                                            "H:|[$self]|"]);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
