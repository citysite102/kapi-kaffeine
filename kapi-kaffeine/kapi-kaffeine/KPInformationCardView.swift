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
    var commentCountLabel: KPLayerLabel!
    var businessInfoIcon: UIImageView!
    var businessInfoLabel: UILabel!
    var distanceIcon: UIImageView!
    var distanceLabel: UILabel!
    
    var shopStatusHint: UIView!
    var shopStatusLabel: UILabel!
    
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
        
        
        locationInfoLabel = UILabel()
        locationInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        locationInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        locationInfoLabel.text = "台北, 大安區"
        container.addSubview(locationInfoLabel)
        locationInfoLabel.addConstraints(fromStringArray: ["V:|-32-[$self]",
                                                           "H:|-($metric0)-[$self]-($metric0)-|"],
                                         metrics:[KPLayoutConstant.information_horizontal_offset+2])
        locationInfoLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
        titleInfoLabel = UILabel()
        titleInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.storeHeader,
                                                weight: UIFont.Weight.medium)
        titleInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_title
        titleInfoLabel.text = "西雅圖極品咖啡 台大店"
        titleInfoLabel.textAlignment = .left
        titleInfoLabel.numberOfLines = 0
        container.addSubview(titleInfoLabel)
        titleInfoLabel.addConstraints(fromStringArray: ["V:[$view0]-12-[$self]",
                                                        "H:|-($metric0)-[$self]-($metric0)-|"],
                                      metrics:[KPLayoutConstant.information_horizontal_offset],
                                      views:[locationInfoLabel])
        titleInfoLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
        rateContainer = UIView()
        container.addSubview(rateContainer)
        rateContainer.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]",
                                                       "H:|-($metric0)-[$self]"],
                                     metrics:[KPLayoutConstant.information_horizontal_offset+2],
                                     views: [titleInfoLabel])

        starIcons = [UIImageView]()

        for index in 0...0 {
            let starIcon = UIImageView(image: R.image.icon_star_filled())
            starIcons.append(starIcon)
            rateContainer.addSubview(starIcon)

            if index == 0 {
                starIcon.tintColor = KPColorPalette.KPMainColor_v2.starColor
                starIcon.addConstraints(fromStringArray: ["H:|[$self(16)]",
                                                          "V:|[$self(16)]|"])
            } else if index == 4 {
                starIcon.tintColor = KPColorPalette.KPMainColor_v2.grayColor_level5
                starIcon.addConstraints(fromStringArray: ["H:[$view0]-6-[$self(16)]",
                                                          "V:|[$self(16)]|"],
                                        views:[starIcons[index-1]])
            } else {
                starIcon.tintColor = KPColorPalette.KPMainColor_v2.starColor
                starIcon.addConstraints(fromStringArray: ["H:[$view0]-6-[$self(16)]",
                                                          "V:|[$self(16)]|"],
                                        views:[starIcons[index-1]])
            }
        }

        rateLabel = KPLayerLabel()
        rateLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        rateLabel.textColor = KPColorPalette.KPMainColor_v2.starColor
        rateLabel.text = "4.8"
        rateLabel.isOpaque = true
        rateLabel.layer.masksToBounds = true
        rateContainer.addSubview(rateLabel)
        rateLabel.addConstraints(fromStringArray: ["H:[$view0]-6-[$self]"],
                                 metrics:[KPLayoutConstant.information_horizontal_offset],
                                 views: [starIcons[starIcons.count-1]])
        rateLabel.addConstraintForCenterAligning(to: starIcons[starIcons.count-1],
                                                 in: .vertical,
                                                 constant: 0)
        
        commentCountLabel = KPLayerLabel()
        commentCountLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        commentCountLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        commentCountLabel.text = "(查看 24 則評論)"
        commentCountLabel.isOpaque = true
        commentCountLabel.layer.masksToBounds = true
        rateContainer.addSubview(commentCountLabel)
        commentCountLabel.addConstraints(fromStringArray: ["H:[$view0]-2-[$self]|"],
                                 views: [rateLabel])
        commentCountLabel.addConstraintForCenterAligning(to: starIcons[starIcons.count-1],
                                                         in: .vertical,
                                                         constant: -2)
        
        
//        shopLocationIcon = UIImageView(image: R.image.icon_pin())
//        shopLocationIcon.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
//        container.addSubview(shopLocationIcon)
//        shopLocationIcon.addConstraints(fromStringArray: ["V:[$view0]-40-[$self(18)]-24-|",
//                                                          "H:|-($metric0)-[$self(18)]"],
//                                         metrics:[KPLayoutConstant.information_horizontal_offset],
//                                         views: [rateLabel])
        
//        locationInfoLabel = UILabel()
//        locationInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
//        locationInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
//        locationInfoLabel.text = "台北 大安區"
//        container.addSubview(locationInfoLabel)
//        locationInfoLabel.addConstraints(fromStringArray: ["V:[$view0]-40-[$self]-24-|",
//                                                           "H:|-($metric0)-[$self]"],
//                                         metrics:[KPLayoutConstant.information_horizontal_offset],
//                                         views: [rateLabel])
        
//        locationInfoLabel.addConstraintForCenterAligning(to: shopLocationIcon,
//                                                         in: .vertical)
//        locationInfoLabel.addConstraints(fromStringArray: ["H:[$view1]-8-[$self]"],
//                                         metrics:[KPLayoutConstant.information_horizontal_offset],
//                                         views: [rateLabel,
//                                                 shopLocationIcon])
        
        

//        businessInfoIcon = UIImageView(image: R.image.icon_clock())
//        businessInfoIcon.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
//        container.addSubview(businessInfoIcon)
//        businessInfoIcon.addConstraintForCenterAligning(to: shopLocationIcon,
//                                                        in: .vertical)
//        businessInfoIcon.addConstraints(fromStringArray: ["V:[$self(18)]",
//                                                          "H:[$view0]-32-[$self(18)]"],
//                                        metrics:[KPLayoutConstant.information_horizontal_offset],
//                                        views: [locationInfoLabel])
//
//        businessInfoLabel = UILabel()
//        businessInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
//        businessInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
//        businessInfoLabel.text = "營業中"
//        container.addSubview(businessInfoLabel)
//        businessInfoLabel.addConstraintForCenterAligning(to: locationInfoLabel,
//                                                         in: .vertical)
//        businessInfoLabel.addConstraints(fromStringArray: ["H:[$view0]-32-[$self]"],
//                                         metrics:[KPLayoutConstant.information_horizontal_offset],
//                                         views: [locationInfoLabel])
        
//        businessInfoLabel.addConstraints(fromStringArray: ["V:[$view0]-12-[$self]-32-|",
//                                                           "H:|-($metric0)-[$self]"],
//                                         metrics:[KPLayoutConstant.information_horizontal_offset],
//                                         views: [locationInfoLabel])

//        businessInfoLabel.addConstraintForCenterAligning(to: businessInfoIcon,
//                                                         in: .vertical)
//        businessInfoLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]"],
//                                         metrics:[KPLayoutConstant.information_horizontal_offset],
//                                         views: [businessInfoIcon])
        
        
        shopStatusHint = UIView()
        shopStatusHint.backgroundColor = KPColorPalette.KPMainColor_v2.greenColor
        shopStatusHint.layer.cornerRadius = 4.0
        shopStatusHint.isOpaque = true
        container.addSubview(shopStatusHint)
        shopStatusHint.addConstraintForCenterAligning(to: rateContainer,
                                                      in: .vertical,
                                                      constant: -1)
        shopStatusHint.addConstraints(fromStringArray: ["H:[$view0]-16-[$self(8)]",
                                                        "V:[$self(8)]"],
                                      views: [rateContainer])
        
        shopStatusLabel = KPLayerLabel()
        shopStatusLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        shopStatusLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        shopStatusLabel.text = "營業中"
        shopStatusLabel.isOpaque = true
        shopStatusLabel.layer.masksToBounds = true
        container.addSubview(shopStatusLabel)
        shopStatusLabel.addConstraints(fromStringArray: ["H:[$view0]-6-[$self]"],
                                       views: [shopStatusHint])
        shopStatusLabel.addConstraintForCenterAligning(to: shopStatusHint,
                                                       in: .vertical,
                                                       constant: -2)
        
        distanceLabel = UILabel()
        distanceLabel.font = UIFont.systemFont(ofSize: KPFontSize.header)
        distanceLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        distanceLabel.text = "再 300 公尺就到囉！"
        container.addSubview(distanceLabel)
    
        distanceLabel.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]-($metric0)-|",
                                                       "V:[$view0]-72-[$self]-24-|"],
                                         metrics:[KPLayoutConstant.information_horizontal_offset],
                                         views: [rateContainer])
        
        
        distanceIcon = UIImageView(image: R.image.icon_locate())
        distanceIcon.isHidden = true
        distanceIcon.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        container.addSubview(distanceIcon)
        distanceIcon.addConstraintForCenterAligning(to: distanceLabel,
                                                        in: .vertical)
        distanceIcon.addConstraints(fromStringArray: ["V:[$self(24)]",
                                                      "H:[$self(20)]-8-[$view0]"],
                                        views: [distanceLabel])

        
        
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
