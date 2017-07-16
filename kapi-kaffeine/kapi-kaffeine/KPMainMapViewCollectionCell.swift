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
                                               self.dataModel.averageRate?.floatValue ?? 0)
            }
            
            let randomImageArray = [R.image.demo_1(),
                                    R.image.demo_2(),
                                    R.image.demo_3(),
                                    R.image.demo_4(),
                                    R.image.demo_5(),
                                    R.image.demo_6(),
                                    R.image.demo_7(),
                                    R.image.demo_8(),
                                    R.image.demo_9(),
                                    R.image.demo_10(),
                                    R.image.demo_11(),
                                    R.image.icon_noImage()]
            
            let index: Int = Int(arc4random()%12)
            self.shopImageView.image = drawImage(image: randomImageArray[index]!,
                                                 rectSize: CGSize(width: 64, height: 64),
                                                 roundedRadius: 2)
            
            
//            if let photoURL = dataModel.covers?["google_s"] {
//                self.shopImageView.af_setImage(withURL: URL(string: photoURL)!,
//                                               placeholderImage: R.image.icon_loading())
//            } else {
//                self.shopImageView.image = R.image.icon_noImage()
//            }
            
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
    
    private var shopStatusHint: UIView!
    private var shopStatusLabel: UILabel!
    private var featureContainer: KPMainListCellFeatureContainer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.layer.cornerRadius = 4
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 2.0, height: 4.0)
        
        shopImageView = UIImageView(image: UIImage(named: "demo_6"))
        shopImageView.contentMode = .scaleAspectFill
        addSubview(shopImageView)
        shopImageView.addConstraints(fromStringArray: ["H:|-8-[$self(64)]",
                                                       "V:|-8-[$self(64)]-8-|"])
        
        self.shopNameLabel = KPLayerLabel()
        self.shopNameLabel.font = UIFont.systemFont(ofSize: 14.0)
        self.shopNameLabel.textColor = KPColorPalette.KPTextColor.grayColor
        self.shopNameLabel.lineBreakMode = .byTruncatingTail
        self.shopNameLabel.text = "覺旅咖啡"
        self.addSubview(self.shopNameLabel)
        
        self.shopNameLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
                                                            "V:|-[$self]"],
                                          metrics: [UIScreen.main.bounds.size.width/2],
                                          views: [self.shopImageView])
        
        self.shopStatusHint = UIView()
        self.shopStatusHint.backgroundColor = KPColorPalette.KPShopStatusColor.opened
        self.shopStatusHint.layer.cornerRadius = 3.0
        self.addSubview(self.shopStatusHint)
        self.shopStatusHint.addConstraints(fromStringArray: ["H:[$view0]-9-[$self(6)]",
                                                             "V:[$view1]-9-[$self(6)]"],
                                           views: [self.shopImageView,
                                                   self.shopNameLabel])
        
        self.shopStatusLabel = KPLayerLabel()
        self.shopStatusLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.shopStatusLabel.textColor = KPColorPalette.KPTextColor.mainColor
        self.shopStatusLabel.text = "營業中 12:00-21:00"
        self.addSubview(self.shopStatusLabel)
        self.shopStatusLabel.addConstraints(fromStringArray: ["H:[$view0]-5-[$self($metric0)]"],
                                            metrics: [UIScreen.main.bounds.size.width/2],
                                            views: [self.shopStatusHint,
                                                    self.shopNameLabel])
        self.shopStatusLabel.addConstraintForCenterAligning(to: self.shopStatusHint, in: .vertical)
        
        self.shopDistanceLabel = KPLayerLabel()
        self.shopDistanceLabel.font = UIFont.systemFont(ofSize: 20.0)
        self.shopDistanceLabel.textColor = KPColorPalette.KPTextColor.mainColor
        self.shopDistanceLabel.text = "-"
        self.shopDistanceLabel.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        self.addSubview(self.shopDistanceLabel)
        self.shopDistanceLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
                                                                "V:[$self]-|"],
                                              views: [self.shopImageView,
                                                      self.shopStatusLabel])
        
        self.scoreLabel = KPMainListCellScoreLabel()
        self.scoreLabel.contentBackgroundColor = KPColorPalette.KPBackgroundColor.mainColor
        self.scoreLabel.score = "4.3"
        self.addSubview(self.scoreLabel)
        self.scoreLabel.addConstraints(fromStringArray: ["H:[$view0]-4-[$self(30)]-8-|",
                                                         "V:|-(-4)-[$self(22)]"],
                                       views:[shopNameLabel])
        
        self.featureContainer = KPMainListCellFeatureContainer()
        self.featureContainer.featureContents = ["燈光美", "氣氛佳"]
        self.addSubview(self.featureContainer)
        self.featureContainer.addConstraints(fromStringArray: ["H:[$self]-8-|",
                                                               "V:[$self]-|"])
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidUpdate), name: .KPLocationDidUpdate, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func locationDidUpdate() {
        if let distanceInMeter = dataModel.distanceInMeter {
            var distance = distanceInMeter
            var unit = "m"
            if distance > 1000 {
                unit = "km"
                distance = distance/1000
            }
            self.shopDistanceLabel.text = "\(Int(distance))\(unit)"
        } else {
            self.shopDistanceLabel.text = "-"
        }
    }
}
