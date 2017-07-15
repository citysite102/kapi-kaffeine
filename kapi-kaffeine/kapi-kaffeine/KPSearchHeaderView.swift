//
//  KPSearchHeaderView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchHeaderView: UIView {

    
    var containerView: UIView!
    var titleLabel: UILabel!
    var searchButton: KPBounceButton!
    var menuButton: KPBounceButton!
    var styleButton: KPBounceButton!
    var searchTagView: KPSearchTagView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView = UIView()
        containerView.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor_light
        addSubview(containerView)
        containerView.addConstraints(fromStringArray: ["V:|[$self(60)]",
                                                       "H:|[$self]|"],
                                     views: [])
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 18.0)
        titleLabel.textColor = KPColorPalette.KPTextColor.whiteColor
        titleLabel.text = "找咖啡"
        containerView.addSubview(titleLabel)
        titleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        titleLabel.addConstraint(from: "V:|-32-[$self]")
        
        styleButton = KPBounceButton.init(frame: .zero, image: R.image.icon_map()!)
        containerView.addSubview(styleButton)
        styleButton.addConstraints(fromStringArray: ["H:[$self(30)]-5-|",
                                                     "V:[$self(30)]"])
        styleButton.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
        styleButton.addConstraintForCenterAligning(to: titleLabel, in: .vertical)
        styleButton.tintColor = UIColor.white
        
        searchButton = KPBounceButton.init(frame: .zero, image: R.image.icon_search()!)
        containerView.addSubview(searchButton)
        searchButton.addConstraints(fromStringArray: ["H:[$self(30)]-5-[$view0]",
                                                      "V:[$self(30)]"],
                                         views: [styleButton])
        searchButton.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
        searchButton.addConstraintForCenterAligning(to: titleLabel, in: .vertical)
        searchButton.tintColor = UIColor.white
        searchButton.imageView?.tintColor = UIColor.white
        
        menuButton = KPBounceButton.init(frame: .zero, image: R.image.icon_menu()!)
        containerView.addSubview(menuButton)
        menuButton.addConstraints(fromStringArray: ["H:|-5-[$self(30)]",
                                                    "V:[$self(30)]"])
        menuButton.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
        menuButton.addConstraintForCenterAligning(to: titleLabel, in: .vertical)
        menuButton.tintColor = UIColor.white
        
        
        searchTagView = KPSearchTagView()
        addSubview(searchTagView)
        searchTagView.addConstraints(fromStringArray: ["V:[$self(40)]|",
                                                       "H:|[$self]|"])
        
        bringSubview(toFront: containerView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
