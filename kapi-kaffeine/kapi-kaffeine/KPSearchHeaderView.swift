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
    var styleButton: KPBounceButton!
    
    var searchTagView: KPSearchTagView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.0
        layer.shadowColor = KPColorPalette.KPMainColor_v2.shadow_darkColor?.cgColor
        
        containerView = UIView()
        containerView.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        addSubview(containerView)
        containerView.addConstraints(fromStringArray: ["V:|[$self]",
                                                       "H:|[$self]|"],
                                     views: [])
        
        let longPressGesture_location = UILongPressGestureRecognizer(target: self,
                                                                     action: #selector(handleLocationContainerLongPressed(_:)))
        longPressGesture_location.minimumPressDuration = 0
        
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                      action: #selector(handleSearchContainerLongPressed(_:)))
        longPressGesture.minimumPressDuration = 0
        
//        locationSelectView = KPLocationSelect()
//        containerView.addSubview(locationSelectView)
//        locationSelectView.addGestureRecognizer(longPressGesture_location)
//        locationSelectView.addConstraints(fromStringArray: ["H:|-20-[$self]",
//                                                            "V:|-40-[$self(36)]-12-|"])
        
        searchContainer = UIView()
        searchContainer.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        searchContainer.layer.cornerRadius = 5
        searchContainer.layer.masksToBounds = true
        searchContainer.layer.borderWidth = 1.0
        searchContainer.layer.borderColor = KPColorPalette.KPMainColor_v2.grayColor_level4?.cgColor
        containerView.addSubview(searchContainer)
        searchContainer.addGestureRecognizer(longPressGesture)
        searchContainer.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]",
                                                         "V:|-40-[$self(40)]-8-|"],
                                       metrics:[KPLayoutConstant.information_horizontal_offset])
        
        searchIcon = UIImageView(image: R.image.icon_search())
        searchIcon.tintColor = KPColorPalette.KPMainColor_v2.grayColor_level4
        searchContainer.addSubview(searchIcon)
        searchIcon.addConstraints(fromStringArray: ["V:[$self(16)]",
                                                    "H:|-12-[$self(16)]"])
        searchIcon.addConstraintForCenterAligning(to: searchContainer,
                                                  in: .vertical,
                                                  constant: 0)
        
        searchLabel = UILabel()
        searchLabel.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        searchLabel.text = "搜尋店家名稱、標籤..."
        searchLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        searchContainer.addSubview(searchLabel)
        searchLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]"],
                                   views:[searchIcon])
        searchLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        
        
        filterButton = KPBounceButton.init(frame: .zero,
                                           image: R.image.icon_filter()!)
        filterButton.tintColor = KPColorPalette.KPMainColor_v2.mainColor
        filterButton.selectedTintColor = KPColorPalette.KPMainColor_v2.mainColor
        containerView.addSubview(filterButton)
        filterButton.addConstraints(fromStringArray: ["V:[$self(30)]",
                                                      "H:[$view0]-12-[$self(30)]-12-|"], views:[searchContainer])
        filterButton.addConstraintForCenterAligning(to: searchContainer,
                                                    in: .vertical,
                                                    constant: 0)
        
        titleLabel = UILabel()
        styleButton = KPBounceButton.init(frame: .zero, image: R.image.icon_list()!)

        
        searchTagView = KPSearchTagView()
        addSubview(searchTagView)
        searchTagView.addConstraints(fromStringArray: ["V:[$view0][$self]|",
                                                       "H:|[$self]|"],
                                     views:[containerView])
        
        bringSubview(toFront: containerView)
        
    }
    
    @objc func handleLocationContainerLongPressed(_ gesture: UILongPressGestureRecognizer) {
        if (gesture.state == .began) {
            UIView.animate(withDuration: 0.1,
                           animations: {
                            self.locationSelectView.transform = CGAffineTransform(scaleX: 0.98,
                                                                                  y: 0.98)
            }) { (_) in
            }
        } else if (gesture.state == .ended) {
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
            let locationController = KPLocationSelectViewController()
            let navigationController = UINavigationController(rootViewController: locationController)
            controller.contentController = navigationController
            controller.presentModalView()
            self.locationSelectView.transform = CGAffineTransform.identity
        }
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
