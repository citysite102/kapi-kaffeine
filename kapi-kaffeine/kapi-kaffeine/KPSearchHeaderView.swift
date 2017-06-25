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
    var searchButton: KPBounceButton!
    var menuButton: KPBounceButton!
    var styleButton: KPBounceButton!
    var searchTagView: KPSearchTagView!
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        backgroundColor = KPColorPalette.KPMainColor.mainColor_light;
        
        titleLabel = UILabel();
        titleLabel.font = UIFont.systemFont(ofSize: 18.0);
        titleLabel.textColor = KPColorPalette.KPTextColor.whiteColor;
        titleLabel.text = "找咖啡";
        addSubview(titleLabel);
        titleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal);
        titleLabel.addConstraint(from: "V:|-32-[$self]");
        
        styleButton = KPBounceButton.init(frame: .zero, image: R.image.icon_map()!);
        addSubview(styleButton);
        styleButton.addConstraints(fromStringArray: ["H:[$self(24)]-8-|",
                                                     "V:[$self(24)]"]);
        styleButton.addConstraintForCenterAligning(to: titleLabel, in: .vertical);
        styleButton.tintColor = UIColor.white;
        
        searchButton = KPBounceButton.init(frame: .zero, image: R.image.icon_search()!);
        addSubview(searchButton);
        searchButton.addConstraints(fromStringArray: ["H:[$self(24)]-8-[$view0]",
                                                      "V:[$self(24)]"],
                                         views: [styleButton]);
        searchButton.addConstraintForCenterAligning(to: titleLabel, in: .vertical);
        searchButton.tintColor = UIColor.white;
        
        menuButton = KPBounceButton.init(frame: .zero, image: R.image.icon_menu()!);
        addSubview(menuButton);
        menuButton.addConstraints(fromStringArray: ["H:|-8-[$self(24)]",
                                                    "V:[$self(24)]"]);
        menuButton.addConstraintForCenterAligning(to: titleLabel, in: .vertical);
        menuButton.tintColor = UIColor.white;
        
        
        searchTagView = KPSearchTagView();
        addSubview(searchTagView);
        searchTagView.addConstraints(fromStringArray: ["V:[$self(40)]|",
                                                       "H:|[$self]|"]);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
