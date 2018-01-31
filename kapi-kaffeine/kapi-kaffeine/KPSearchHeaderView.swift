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
    
    var locationSelectView: KPLocationSelect!
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
        
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                      action: #selector(handleSearchContainerLongPressed(_:)))
        longPressGesture.minimumPressDuration = 0
        
        locationSelectView = KPLocationSelect()
        containerView.addSubview(locationSelectView)
        locationSelectView.addConstraints(fromStringArray: ["H:|-20-[$self]",
                                                            "V:|-40-[$self(36)]|"])
        
        searchContainer = UIView()
        searchContainer.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        searchContainer.layer.cornerRadius = 4.0
        searchContainer.layer.masksToBounds = true
        searchContainer.layer.borderWidth = 1.0
        searchContainer.layer.borderColor = KPColorPalette.KPMainColor_v2.grayColor_level5?.cgColor
        containerView.addSubview(searchContainer)
        searchContainer.addGestureRecognizer(longPressGesture)
        searchContainer.addConstraints(fromStringArray: ["H:[$view0]-16-[$self]-12-|",
                                                         "V:|-40-[$self(36)]"],
                                       views:[locationSelectView])
        
        searchIcon = UIImageView(image: R.image.icon_search())
        searchIcon.tintColor = KPColorPalette.KPTextColor_v2.mainColor_hint
        searchContainer.addSubview(searchIcon)
        searchIcon.addConstraints(fromStringArray: ["V:[$self(18)]",
                                                    "H:|-10-[$self(18)]"])
        searchIcon.addConstraintForCenterAligning(to: searchContainer,
                                                  in: .vertical,
                                                  constant: 0)
        
        searchLabel = UILabel()
        searchLabel.font = UIFont.systemFont(ofSize: 14.0)
        searchLabel.text = "搜尋店家名稱、標籤、地點"
        searchLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_hint
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
//        filterButton.tintColor = KPColorPalette.KPMainColor_v2.textColor_level4
//        containerView.addSubview(filterButton)
//        filterButton.addConstraints(fromStringArray: ["V:[$self(30)]",
//                                                      "H:[$self(30)]-16-|"])
//        filterButton.addConstraintForCenterAligning(to: searchContainer,
//                                                    in: .vertical,
//                                                    constant: 0)
        
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
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level5_5
        searchTagView.addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:[$self(1)]|",
                                                   "H:|[$self]|"])
        
        bringSubview(toFront: containerView)
        
    }
    
    @objc func handleSearchContainerLongPressed(_ gesture: UILongPressGestureRecognizer) {
        
        if (gesture.state == .began) {
            UIView.animate(withDuration: 0.1,
                           animations: {
                            self.searchContainer.transform = CGAffineTransform(scaleX: 0.98,
                                                                               y: 0.98)
            }) { (_) in
            }
        } else if (gesture.state == .ended) {
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
            let searchController = KPSearchViewController()
            let navigationController = UINavigationController(rootViewController: searchController)
            controller.contentController = navigationController
            controller.presentModalView()
            self.searchContainer.transform = CGAffineTransform.identity
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
