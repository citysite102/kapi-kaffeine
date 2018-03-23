//
//  KPMainMapViewCollectionCell.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 15/04/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit
import CoreLocation

class KPMainMapViewCollectionCell: UICollectionViewCell {
    
    
    var dataModel: KPDataModel! {
        didSet {
            
            DispatchQueue.main.async {
                self.shopNameLabel.text = self.dataModel.name ?? "未命名"
                self.featureContainer.featureContents = self.dataModel.featureContents
                self.scoreLabel.score = String(format: "%.1f",
                                               (self.dataModel.averageRate?.doubleValue) ?? 0)
            }
            
            if let photoURL = dataModel.covers?["kapi_s"] ?? dataModel.covers?["google_s"],
                let url = URL(string: photoURL) {
                self.shopImageView.af_setImage(withURL: url,
                                               placeholderImage: drawImage(image: R.image.icon_loading()!,
                                                                           rectSize: CGSize(width: 56, height: 56),
                                                                           roundedRadius: 2),
                                               filter: nil,
                                               progress: nil,
                                               progressQueue: DispatchQueue.global(),
                                               imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                               runImageTransitionIfCached: true,
                                               completion: { response in
                                                if let responseImage = response.result.value {
                                                    self.shopImageView.image =  drawImage(image: responseImage,
                                                                                          rectSize: CGSize(width: 56, height: 56),
                                                                                          roundedRadius: 2)
                                                } else {
                                                    self.shopImageView.image =  drawImage(image: R.image.icon_noImage()!,
                                                                                          rectSize: CGSize(width: 56, height: 56),
                                                                                          roundedRadius: 2)
                                                }
                })
            } else {
                self.shopImageView.image = drawImage(image: R.image.icon_noImage()!,
                                                     rectSize: CGSize(width: 56, height: 56),
                                                     roundedRadius: 2)
            }
            
            locationDidUpdate()
            
            if dataModel.businessHour != nil {
                let shopStatus = dataModel.businessHour!.shopStatus
                shopStatusLabel.textColor = KPColorPalette.KPTextColor.grayColor
                shopStatusLabel.text = shopStatus.status
                shopStatusHint.backgroundColor = shopStatus.isOpening ?
                    KPColorPalette.KPShopStatusColor.opened :
                    KPColorPalette.KPShopStatusColor.closed
            } else {
                shopStatusLabel.textColor = KPColorPalette.KPTextColor.grayColor_level5
                shopStatusHint.backgroundColor = KPColorPalette.KPTextColor.grayColor_level5
                shopStatusLabel.text = "暫無資料"
            }
        }
    }
    
    var shopImageView: UIImageView!
    var shopNameLabel: KPLayerLabel!
    var shopDistanceLabel: KPLayerLabel!
    
    var scoreLabel: KPMainListCellScoreLabel!
    
    var starIcon: UIImageView!
    var rateLabel: KPLayerLabel!
    
    var shopLocationIcon: UIImageView!
    var shopLocationLabel: KPLayerLabel!
    
    private var shopStatusHint: UIView!
    private var shopStatusLabel: UILabel!
    private var featureContainer: KPMainListCellFeatureContainer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = UIColor.white
        
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 4.0
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = KPColorPalette.KPMainColor_v2.shadow_darkColor?.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3
        
        
        shopImageView = UIImageView(image: UIImage(named: "demo_6"))
        shopImageView.contentMode = .scaleAspectFill
        shopImageView.clipsToBounds = true
        contentView.addSubview(shopImageView)
        shopImageView.addConstraints(fromStringArray: ["H:|-16-[$self(76)]",
                                                       "V:|-16-[$self(76)]-16-|"])
        
        shopNameLabel = KPLayerLabel()
        shopNameLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        shopNameLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor
        shopNameLabel.lineBreakMode = .byTruncatingTail
        shopNameLabel.text = "覺旅咖啡"
        shopNameLabel.isOpaque = true
        shopNameLabel.layer.masksToBounds = true
        contentView.addSubview(self.shopNameLabel)
        
        shopNameLabel.addConstraints(fromStringArray: ["H:[$view0]-12-[$self($metric0)]",
                                                       "V:|-15-[$self]"],
                                     metrics: [UIScreen.main.bounds.size.width/2 - 40],
                                     views: [shopImageView])
        
        shopStatusHint = UIView()
        shopStatusHint.backgroundColor = KPColorPalette.KPMainColor_v2.greenColor
        shopStatusHint.layer.cornerRadius = 4.0
        shopStatusHint.isOpaque = true
        contentView.addSubview(shopStatusHint)
        shopStatusHint.addConstraints(fromStringArray: ["H:[$view0]-12-[$self(8)]",
                                                        "V:[$view1]-16-[$self(8)]"],
                                      views: [shopImageView,
                                              shopNameLabel])
        
        shopStatusLabel = KPLayerLabel()
        shopStatusLabel.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        shopStatusLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        shopStatusLabel.text = "營業時間 未知"
        shopStatusLabel.isOpaque = true
        shopStatusLabel.layer.masksToBounds = true
        contentView.addSubview(shopStatusLabel)
        shopStatusLabel.addConstraints(fromStringArray: ["H:[$view0]-9-[$self($metric0)]"],
                                       metrics: [UIScreen.main.bounds.size.width/2],
                                       views: [shopStatusHint,
                                               shopNameLabel])
        shopStatusLabel.addConstraintForCenterAligning(to: shopStatusHint,
                                                       in: .vertical,
                                                       constant: -1)
        
        
        shopLocationIcon = UIImageView(image: R.image.icon_pin_fill())
        shopLocationIcon.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        contentView.addSubview(shopLocationIcon)
        shopLocationIcon.addConstraints(fromStringArray: ["H:[$view0]-9-[$self(14)]",
                                                          "V:[$self(14)]-19-|"],
                                        views: [shopImageView])
        
        shopLocationLabel = KPLayerLabel()
        shopLocationLabel.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        shopLocationLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        shopLocationLabel.text = "台北市, 萬華區"
        shopLocationLabel.isOpaque = true
        shopLocationLabel.layer.masksToBounds = true
        contentView.addSubview(shopLocationLabel)
        shopLocationLabel.addConstraints(fromStringArray: ["H:[$view0]-6-[$self]",
                                                           "V:[$self(17)]-20-|"],
                                         views: [shopLocationIcon])
        
        
        shopDistanceLabel = KPLayerLabel()
        shopDistanceLabel.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        shopDistanceLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        shopDistanceLabel.isOpaque = true
        shopDistanceLabel.layer.masksToBounds = true
        contentView.addSubview(shopDistanceLabel)
        shopDistanceLabel.addConstraints(fromStringArray: ["H:[$view0]-16-[$self]",
                                                           "V:[$self(17)]-20-|"],
                                         views: [shopLocationLabel])
        
//        shopDistanceLabel = KPLayerLabel()
//        shopDistanceLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
//        shopDistanceLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
//        shopDistanceLabel.isOpaque = true
//        shopDistanceLabel.layer.masksToBounds = true
//        contentView.addSubview(shopDistanceLabel)
//        shopDistanceLabel.addConstraints(fromStringArray: ["H:[$view0]-10-[$self]",
//                                                           "V:[$self]-16-|"],
//                                         views: [self.shopImageView,
//                                                 self.shopStatusLabel])
        
        
        
        starIcon = UIImageView(image: R.image.icon_star_filled())
        starIcon.tintColor = KPColorPalette.KPMainColor_v2.starColor
        contentView.addSubview(starIcon)
        starIcon.addConstraints(fromStringArray: ["H:[$self(18)]-12-|",
                                                  "V:[$self(18)]"])
        starIcon.addConstraintForCenterAligning(to: shopNameLabel,
                                                in: .vertical,
                                                constant: 1)
        
        
        rateLabel = KPLayerLabel()
        rateLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        rateLabel.textColor = KPColorPalette.KPMainColor_v2.starColor
        rateLabel.text = "4.8"
        rateLabel.isOpaque = true
        rateLabel.layer.masksToBounds = true
        contentView.addSubview(rateLabel)
        rateLabel.addConstraints(fromStringArray: ["H:[$self(28)]-1-[$view0]"],
                                 views: [starIcon])
        rateLabel.addConstraintForCenterAligning(to: starIcon,
                                                 in: .vertical,
                                                 constant: 0)
        
        self.scoreLabel = KPMainListCellScoreLabel()
//        self.scoreLabel.contentBackgroundColor = KPColorPalette.KPBackgroundColor.mainColor
//        self.scoreLabel.score = "4.3"
//        self.addSubview(self.scoreLabel)
//        self.scoreLabel.addConstraints(fromStringArray: ["H:|-[$self(30)]",
//                                                         "V:[$self(22)]-|"],
//                                       views:[shopStatusLabel])
        
        self.featureContainer = KPMainListCellFeatureContainer()
//        self.featureContainer.featureContents = ["燈光美", "氣氛佳"]
//        self.addSubview(self.featureContainer)
//        self.featureContainer.addConstraints(fromStringArray: ["H:[$self]-8-|",
//                                                               "V:[$self]-|"])
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidUpdate), name: .KPLocationDidUpdate, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func locationDidUpdate() {
        if let distanceInMeter = dataModel.distanceInMeter {
            var distance = distanceInMeter
            var unit = "m"
            if distance > 1000 {
                unit = "km"
                distance = distance/1000
            }
//            self.shopDistanceLabel.text = String(format: "%.1f%@", distance, unit)
        } else {
//            self.shopDistanceLabel.text = "-"
        }
    }
}
