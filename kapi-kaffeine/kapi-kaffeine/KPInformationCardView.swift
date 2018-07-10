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
    var hashTagLabel: UILabel!
    
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
        locationInfoLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent,
                                                   weight: UIFont.Weight.regular)
        locationInfoLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_hint
        locationInfoLabel.text = "台北, 大安區"
        container.addSubview(locationInfoLabel)
        locationInfoLabel.addConstraints(fromStringArray: ["V:|-24-[$self]",
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
        
        hashTagLabel = UILabel()
        hashTagLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent,
                                                weight: UIFont.Weight.regular)
        hashTagLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        hashTagLabel.text = "#Wifi 穩定 #店員很正 #價格便宜"
        hashTagLabel.textAlignment = .left
        hashTagLabel.numberOfLines = 0
        container.addSubview(hashTagLabel)
        hashTagLabel.addConstraints(fromStringArray: ["V:[$view0]-12-[$self]",
                                                      "H:|-($metric0)-[$self]-($metric0)-|"],
                                      metrics:[KPLayoutConstant.information_horizontal_offset],
                                      views:[titleInfoLabel])
        hashTagLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
        rateContainer = UIView()
        container.addSubview(rateContainer)
        rateContainer.addConstraints(fromStringArray: ["V:[$view0]-48-[$self]-32-|",
                                                       "H:|-($metric0)-[$self]"],
                                     metrics:[KPLayoutConstant.information_horizontal_offset],
                                     views: [hashTagLabel])

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
        rateLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent,
                                           weight: UIFont.Weight.regular)
        rateLabel.textColor = KPColorPalette.KPMainColor_v2.starColor
        rateLabel.text = "4.8"
        rateLabel.isOpaque = true
        rateLabel.layer.masksToBounds = true
        rateContainer.addSubview(rateLabel)
        rateLabel.addConstraints(fromStringArray: ["H:[$view0]-6-[$self]|"],
                                 metrics:[KPLayoutConstant.information_horizontal_offset],
                                 views: [starIcons[starIcons.count-1]])
        rateLabel.addConstraintForCenterAligning(to: starIcons[starIcons.count-1],
                                                 in: .vertical,
                                                 constant: 0)
        
        commentCountLabel = KPLayerLabel()
        commentCountLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        commentCountLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        commentCountLabel.isOpaque = true
        commentCountLabel.layer.masksToBounds = true
        
        shopStatusHint = UIView()
        shopStatusHint.backgroundColor = KPColorPalette.KPMainColor_v2.greenColor
        shopStatusHint.layer.cornerRadius = 4.0
        shopStatusHint.isOpaque = true
        container.addSubview(shopStatusHint)
        shopStatusHint.addConstraints(fromStringArray: ["H:[$view0]-($metric0)-[$self(8)]",
                                                        "V:[$self(8)]"],
                                      metrics:[KPLayoutConstant.information_horizontal_offset+4],
                                      views: [rateContainer])
        shopStatusHint.addConstraintForCenterAligning(to: rateContainer,
                                                      in: .vertical)
        
        shopStatusLabel = KPLayerLabel()
        shopStatusLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        shopStatusLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        shopStatusLabel.text = "營業中"
        shopStatusLabel.isOpaque = true
        shopStatusLabel.layer.masksToBounds = true
        container.addSubview(shopStatusLabel)
        shopStatusLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]"],
                                       views: [shopStatusHint])
        shopStatusLabel.addConstraintForCenterAligning(to: shopStatusHint,
                                                       in: .vertical,
                                                       constant: -2)
        
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
