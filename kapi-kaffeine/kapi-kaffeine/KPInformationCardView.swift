//
//  KPInformationCardView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2018/2/9.
//  Copyright © 2018年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPInformationCardView: UIView {

    var container: UIView!
    var shopLocationIcon: UIImageView!
    var locationInfoLabel: UILabel!
    var titleInfoLabel: UILabel!
    
    var rateContainer: UIView!
    var starIcons: [UIImageView]!
    var starIcon: UIImageView!
    var rateLabel: KPLayerLabel!
    var businessInfoIcon: UIImageView!
    var businessInfoLabel: UILabel!
    
    private var shopStatusHint: UIView!
    private var shopStatusLabel: UILabel!
    
    var userContainer: UIView!
    var userProfileImages: [UIImage]! = [R.image.demo_p1()!,
                                         R.image.demo_p2()!,
                                         R.image.demo_p3()!,
                                         R.image.demo_p4()!,
                                         R.image.demo_p5()!]
    var userProfileImageViews: [UIView]!
    var userVisitedLabel: UILabel!
    
    
    var separator: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        container = UIView()
        container.layer.cornerRadius = 2.0
        container.layer.masksToBounds = true
        addSubview(container)
        container.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        container.addConstraints(fromStringArray: ["V:|[$self]|",
                                                   "H:|[$self]|"])
        
        titleInfoLabel = UILabel()
        titleInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.storeHeader,
                                                weight: UIFont.Weight.medium)
        titleInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_title
        titleInfoLabel.text = "西雅圖極品咖啡 台大店"
        titleInfoLabel.textAlignment = .left
        titleInfoLabel.numberOfLines = 0
        container.addSubview(titleInfoLabel)
        titleInfoLabel.addConstraints(fromStringArray: ["V:|-32-[$self]",
                                                        "H:|-($metric0)-[$self]-80-|"],
                                      metrics:[KPLayoutConstant.information_horizontal_offset])
        titleInfoLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
//        starIcon = UIImageView(image: R.image.icon_star_filled())
//        starIcon.tintColor = KPColorPalette.KPMainColor_v2.starColor
//        container.addSubview(starIcon)
//        starIcon.addConstraints(fromStringArray: ["H:[$self(24)]-($metric0)-|",
//                                                  "V:|-24-[$self(24)]"], metrics:[KPLayoutConstant.information_horizontal_offset])
//
//        rateLabel = KPLayerLabel()
//        rateLabel.font = UIFont.boldSystemFont(ofSize: KPFontSize.mainContent)
//        rateLabel.textColor = KPColorPalette.KPMainColor_v2.starColor
//        rateLabel.text = "0.0"
//        rateLabel.isOpaque = true
//        rateLabel.layer.masksToBounds = true
//        container.addSubview(rateLabel)
        
//        rateLabel.addConstraints(fromStringArray: ["H:[$self(28)]-1-[$view0]"],
//                                 views: [starIcon])
//        rateLabel.addConstraintForCenterAligning(to: starIcon,
//                                                 in: .vertical,
//                                                 constant: 0)
        
        rateContainer = UIView()
        container.addSubview(rateContainer)
        rateContainer.addConstraints(fromStringArray: ["V:[$view0]-24-[$self]",
                                                       "H:|-($metric0)-[$self]"],
                                     metrics:[KPLayoutConstant.information_horizontal_offset],
                                     views: [titleInfoLabel])

        starIcons = [UIImageView]()

        for index in 0...4 {
            let starIcon = UIImageView(image: R.image.icon_star_filled())
            starIcon.tintColor = KPColorPalette.KPMainColor_v2.starColor
            starIcons.append(starIcon)
            rateContainer.addSubview(starIcon)

            if index == 0 {
                starIcon.addConstraints(fromStringArray: ["H:|[$self(18)]",
                                                          "V:|[$self(18)]|"])
            } else {
                starIcon.addConstraints(fromStringArray: ["H:[$view0]-6-[$self(18)]",
                                                          "V:|[$self(18)]|"],
                                        views:[starIcons[index-1]])
            }
        }

        rateLabel = KPLayerLabel()
        rateLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        rateLabel.textColor = KPColorPalette.KPMainColor_v2.starColor
        rateLabel.text = "4.8"
        rateLabel.isOpaque = true
        rateLabel.layer.masksToBounds = true
        rateContainer.addSubview(rateLabel)
        rateLabel.addConstraints(fromStringArray: ["H:[$view0]-6-[$self]|"],
                                 metrics:[KPLayoutConstant.information_horizontal_offset],
                                 views: [starIcons[4]])
        rateLabel.addConstraintForCenterAligning(to: starIcons[4],
                                                 in: .vertical,
                                                 constant: 0)
        
        
//        shopLocationIcon = UIImageView(image: R.image.icon_pin())
//        shopLocationIcon.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
//        container.addSubview(shopLocationIcon)
//        shopLocationIcon.addConstraints(fromStringArray: ["V:[$view0]-13-[$self(20)]",
//                                                          "H:|-($metric0)-[$self(20)]"],
//                                         metrics:[KPLayoutConstant.information_horizontal_offset],
//                                         views: [rateLabel])
        
        locationInfoLabel = UILabel()
        locationInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        locationInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        locationInfoLabel.text = "台北 大安區"
        container.addSubview(locationInfoLabel)
        locationInfoLabel.addConstraints(fromStringArray: ["V:[$view0]-13-[$self]",
                                                           "H:|-($metric0)-[$self]"],
                                         metrics:[KPLayoutConstant.information_horizontal_offset],
                                            views: [rateLabel])
        
//        locationInfoLabel.addConstraintForCenterAligning(to: shopLocationIcon,
//                                                         in: .vertical)
//        locationInfoLabel.addConstraints(fromStringArray: ["H:[$view1]-8-[$self]-($metric0)-|"],
//                                         metrics:[KPLayoutConstant.information_horizontal_offset],
//                                         views: [rateLabel,
//                                                 shopLocationIcon])
        
        

//        businessInfoIcon = UIImageView(image: R.image.icon_clock())
//        businessInfoIcon.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
//        container.addSubview(businessInfoIcon)
//        businessInfoIcon.addConstraints(fromStringArray: ["V:[$view0]-12-[$self(20)]-22-|",
//                                                          "H:|-($metric0)-[$self(20)]"],
//                                        metrics:[KPLayoutConstant.information_horizontal_offset],
//                                        views: [locationInfoLabel])
        
        businessInfoLabel = UILabel()
        businessInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        businessInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        businessInfoLabel.text = "營業時間：平日：12:00 - 19:30"
        container.addSubview(businessInfoLabel)
        businessInfoLabel.addConstraints(fromStringArray: ["V:[$view0]-12-[$self]-32-|",
                                                           "H:|-($metric0)-[$self]"],
                                         metrics:[KPLayoutConstant.information_horizontal_offset],
                                         views: [locationInfoLabel])

//        businessInfoLabel.addConstraintForCenterAligning(to: businessInfoIcon,
//                                                         in: .vertical)
//        businessInfoLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]-($metric0)-|"],
//                                         metrics:[KPLayoutConstant.information_horizontal_offset],
//                                         views: [businessInfoIcon])
        
        
        separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        container.addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:[$self(1)]|",
                                                   "H:|-($metric0)-[$self]-($metric0)-|"],
                                 metrics:[KPLayoutConstant.information_horizontal_offset])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
