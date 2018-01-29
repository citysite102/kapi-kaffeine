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
    
//    var searchBar: UISearchBar!
    var searchContainer: UIView!
    var searchIcon: UIImageView!
    var searchLabel: UILabel!
    var filterButton: KPBounceButton!
    
    var searchButton: KPBounceButton!
    var menuButton: KPBounceButton!
    var styleButton: KPBounceButton!
    
    var searchTagView: KPSearchTagView!
    var separator: UIView!

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView = UIView()
        containerView.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        addSubview(containerView)
        containerView.addConstraints(fromStringArray: ["V:|[$self]",
                                                       "H:|[$self]|"],
                                     views: [])
        searchContainer = UIView()
        searchContainer.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        searchContainer.layer.cornerRadius = 6.0
        searchContainer.layer.masksToBounds = true
        containerView.addSubview(searchContainer)
        searchContainer.addConstraints(fromStringArray: ["H:|-12-[$self]-56-|",
                                                         "V:|-28-[$self(36)]|"])
        
        searchIcon = UIImageView(image: R.image.icon_search())
        searchIcon.tintColor = KPColorPalette.KPMainColor_v2.textColor_level4
        searchContainer.addSubview(searchIcon)
        searchIcon.addConstraints(fromStringArray: ["V:[$self(20)]",
                                                    "H:|-10-[$self(20)]"])
        searchIcon.addConstraintForCenterAligning(to: searchContainer,
                                                  in: .vertical,
                                                  constant: 0)
        
        searchLabel = UILabel()
        searchLabel.font = UIFont.systemFont(ofSize: 14.0)
        searchLabel.text = "地點..."
        searchLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        searchContainer.addSubview(searchLabel)
        searchLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]"],
                                   views:[searchIcon])
        searchLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        
        
//        searchBar = UISearchBar()
//        searchBar.searchBarStyle = .minimal
//        searchBar.barTintColor = KPColorPalette.KPBackgroundColor.whiteColor
//        containerView.addSubview(searchBar)
//        searchBar.addConstraints(fromStringArray: ["H:|-8-[$self]-48-|",
//                                                   "V:|-24-[$self]|"])
//
//        if let txfSearchField = searchBar.value(forKey: "_searchField") as? UITextField {
//            txfSearchField.subviews.first?.isHidden = true
//            txfSearchField.layer.cornerRadius = 6.0
//            txfSearchField.layer.masksToBounds = true
//            txfSearchField.layer.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7?.cgColor
//        }
        
        filterButton = KPBounceButton.init(frame: .zero,
                                           image: R.image.icon_filter()!)
        filterButton.tintColor = KPColorPalette.KPMainColor_v2.textColor_level4
        containerView.addSubview(filterButton)
        filterButton.addConstraints(fromStringArray: ["V:[$self(30)]",
                                                      "H:[$self(30)]-16-|"])
        filterButton.addConstraintForCenterAligning(to: searchContainer,
                                                    in: .vertical,
                                                    constant: 0)
        
        titleLabel = UILabel()
//        titleLabel.font = UIFont.systemFont(ofSize: 20.0)
//        titleLabel.textColor = KPColorPalette.KPTextColor.whiteColor
//        titleLabel.text = "找咖啡"
//        containerView.addSubview(titleLabel)
//        titleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
//        titleLabel.addConstraint(from: "V:|-32-[$self]")
        
        styleButton = KPBounceButton.init(frame: .zero, image: R.image.icon_list()!)
//        containerView.addSubview(styleButton)
//        styleButton.addConstraints(fromStringArray: ["H:[$self(30)]-5-|",
//                                                     "V:[$self(30)]"])
//        styleButton.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
//        styleButton.addConstraintForCenterAligning(to: titleLabel, in: .vertical)
//        styleButton.tintColor = UIColor.white
//
        searchButton = KPBounceButton.init(frame: .zero, image: R.image.icon_search()!)
//        containerView.addSubview(searchButton)
//        searchButton.addConstraints(fromStringArray: ["H:[$self(30)]-5-[$view0]",
//                                                      "V:[$self(30)]"],
//                                         views: [styleButton])
//        searchButton.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
//        searchButton.addConstraintForCenterAligning(to: titleLabel, in: .vertical)
//        searchButton.tintColor = UIColor.white
//        searchButton.imageView?.tintColor = UIColor.white
        
        menuButton = KPBounceButton.init(frame: .zero, image: R.image.icon_menu()!)
//        containerView.addSubview(menuButton)
//        menuButton.addConstraints(fromStringArray: ["H:|-5-[$self(30)]",
//                                                    "V:[$self(30)]"])
//        menuButton.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
//        menuButton.addConstraintForCenterAligning(to: titleLabel, in: .vertical)
//        menuButton.tintColor = UIColor.white
        
        
        searchTagView = KPSearchTagView()
        addSubview(searchTagView)
        searchTagView.addConstraints(fromStringArray: ["V:[$view0][$self]|",
                                                       "H:|[$self]|"],
                                     views:[searchContainer])
        
        separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        searchTagView.addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:[$self(1)]|",
                                                   "H:|[$self]|"])
        
        bringSubview(toFront: containerView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
