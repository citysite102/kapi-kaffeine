//
//  KPMainListTableViewCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import CoreLocation
import AlamofireImage

class KPMainListTableViewCell: UITableViewCell {
    
    let cellImageWidth: CGFloat = 76
    let cellCornerRadius: CGFloat = 3
    
    var dataModel: KPDataModel! {
        didSet {
            
            DispatchQueue.main.async {
                self.shopNameLabel.text = self.dataModel.name ?? "未命名"
                self.featureContainer.featureContents = self.dataModel.featureContents
                self.rateLabel.text = String(format: "%.1f",
                                             (self.dataModel.averageRate?.doubleValue) ?? 0)
                
                var distName: String = ""
                
                if let distIndex = self.dataModel.address?.index(of: "區"),
                    distIndex.encodedOffset > 2 {
                    let startIndex = self.dataModel.address!.index(distIndex, offsetBy:-2)
                    distName = String(self.dataModel.address![startIndex...distIndex])
                }
                
                self.shopLocationLabel.text =  (KPInfoMapping.citiesMapping[self.dataModel.city]
                    ?? "") +
                    (distName != "" ? ", \(distName)" : "")
                
                if self.dataModel.closed {
                    self.shopNameLabel.text = "(已歇業) " + (self.dataModel.name ?? "未命名")
                    self.shopStatusLabel.textColor = KPColorPalette.KPTextColor.grayColor_level5
                    self.shopStatusHint.backgroundColor = KPColorPalette.KPTextColor.grayColor_level5
                    self.shopStatusLabel.text = "已歇業"
                } else {
                    if self.dataModel.businessHour != nil {
                        let shopStatus = self.dataModel.businessHour!.shopStatus
                        self.shopStatusLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
                        self.shopStatusLabel.text = shopStatus.status
                        self.shopStatusHint.backgroundColor = shopStatus.isOpening ?
                                KPColorPalette.KPMainColor_v2.greenColor :
                                KPColorPalette.KPShopStatusColor.closed
                    } else {
                        self.shopStatusLabel.textColor = KPColorPalette.KPTextColor.grayColor_level5
                        self.shopStatusHint.backgroundColor = KPColorPalette.KPTextColor.grayColor_level5
                        self.shopStatusLabel.text = "暫無資料"
                    }
                }
                
            }
            
            if let photoURL = dataModel.imageURL_s ?? dataModel.googleURL_s  {
                self.shopImageView.af_setImage(withURL: photoURL,
                                               placeholderImage: drawImage(image: R.image.icon_loading()!,
                                                                           rectSize: CGSize(width: self.cellImageWidth, height: self.cellImageWidth),
                                                                           roundedRadius: self.cellCornerRadius),
                                               filter: nil,
                                               progress: nil,
                                               progressQueue: DispatchQueue.global(),
                                               imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                               runImageTransitionIfCached: true,
                                               completion: { response in
                                                if let responseImage = response.result.value {
                                                    self.shopImageView.image =  drawImage(image: responseImage,
                                                                                          rectSize: CGSize(width: self.cellImageWidth, height: self.cellImageWidth),
                                                                                          roundedRadius: self.cellCornerRadius)
                                                } else {
                                                    self.shopImageView.image =  drawImage(image: R.image.image_noPic()!,
                                                                                          rectSize: CGSize(width: self.cellImageWidth, height: self.cellImageWidth),
                                                                                          roundedRadius: self.cellCornerRadius)
                                                }
                })
            } else {
                self.shopImageView.image = drawImage(image: R.image.image_noPic()!,
                                                     rectSize: CGSize(width: self.cellImageWidth,
                                                                      height: self.cellImageWidth),
                                                     roundedRadius: self.cellCornerRadius)
            }
            
            locationDidUpdate()
        }
    }
    
    var shopImageView: UIImageView!
    var shopNameLabel: KPLayerLabel!
    
    var starIcon: UIImageView!
    var rateLabel: KPLayerLabel!
    
    var shopLocationIcon: UIImageView!
    var shopLocationLabel: KPLayerLabel!
    
    
    var shopDistanceLabel: KPLayerLabel!
    var scoreLabel: KPMainListCellScoreLabel!
    var separator: UIView!
    
    private var shopStatusHint: UIView!
    private var shopStatusLabel: UILabel!
    private var featureContainer: KPMainListCellFeatureContainer!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        shopImageView = UIImageView(image: drawImage(image: R.image.demo_6()!,
                                                     rectSize: CGSize(width: self.cellImageWidth,
                                                                      height: self.cellImageWidth),
                                                     roundedRadius: self.cellCornerRadius))
        shopImageView.contentMode = .scaleAspectFill
        shopImageView.clipsToBounds = true
        contentView.addSubview(shopImageView)
            
        shopImageView.addConstraints(fromStringArray: ["H:|-18-[$self(76)]",
                                                       "V:|-18-[$self(76)]-18-|"])
        
        shopNameLabel = KPLayerLabel()
        shopNameLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        shopNameLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor
        shopNameLabel.isOpaque = true
        shopNameLabel.layer.masksToBounds = true
        contentView.addSubview(shopNameLabel)

        shopNameLabel.addConstraints(fromStringArray: ["H:[$view0]-14-[$self($metric0)]",
                                                       "V:|-17-[$self]"],
                                          metrics: [UIScreen.main.bounds.size.width/2],
                                          views: [shopImageView])
        
        starIcon = UIImageView(image: R.image.icon_star_filled())
        starIcon.tintColor = KPColorPalette.KPMainColor_v2.starColor
        contentView.addSubview(starIcon)
        starIcon.addConstraints(fromStringArray: ["H:[$self(18)]-12-|",
                                                  "V:|-19-[$self(18)]"])
        
        rateLabel = KPLayerLabel()
        rateLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        rateLabel.textColor = KPColorPalette.KPMainColor_v2.starColor
        rateLabel.text = "0.0"
        rateLabel.isOpaque = true
        rateLabel.layer.masksToBounds = true
        contentView.addSubview(rateLabel)

        rateLabel.addConstraints(fromStringArray: ["H:[$self(28)]-1-[$view0]"],
                                        views: [starIcon])
        rateLabel.addConstraintForCenterAligning(to: starIcon,
                                                 in: .vertical,
                                                 constant: 0)
        
        
        shopStatusHint = UIView()
        shopStatusHint.backgroundColor = KPColorPalette.KPMainColor_v2.greenColor
        shopStatusHint.layer.cornerRadius = 4
        shopStatusHint.isOpaque = true
        contentView.addSubview(shopStatusHint)
        shopStatusHint.addConstraints(fromStringArray: ["H:[$view0]-14-[$self(8)]",
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
        shopLocationIcon.addConstraints(fromStringArray: ["H:[$view0]-11-[$self(14)]",
                                                          "V:[$self(14)]-21-|"],
                                         views: [shopImageView])
        
        shopLocationLabel = KPLayerLabel()
        shopLocationLabel.font = UIFont.systemFont(ofSize: KPFontSize.infoContent)
        shopLocationLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
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
        
        scoreLabel = KPMainListCellScoreLabel()
//        contentView.addSubview(scoreLabel)
//        scoreLabel.addConstraints(fromStringArray: ["H:[$self(30)]-8-|",
//                                                    "V:|-12-[$self(22)]"])
        
        featureContainer = KPMainListCellFeatureContainer()
//        contentView.addSubview(featureContainer)
//        featureContainer.addConstraints(fromStringArray: ["H:[$self]-8-|",
//                                                          "V:[$self]-10-|"])
        
        separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        contentView.addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:[$self(1)]|",
                                                   "H:|-8-[$self]-8-|"])
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidUpdate), name: .KPLocationDidUpdate, object: nil)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = selected ? KPColorPalette.KPBackgroundColor.grayColor_level7 : UIColor.white
        // Configure the view for the selected state
    }
    
    @objc func locationDidUpdate() {
        if let distanceInMeter = dataModel.distanceInMeter {
            var distance = distanceInMeter
            var unit = "m"
            if distance > 1000 {
                unit = "km"
                distance = distance/1000
            }
            
            if unit == "m" {
                if distance < 600 && distance > 300 {
                    self.shopDistanceLabel.text = "步行 5 min"
                } else if distance <= 300 {
                    self.shopDistanceLabel.text = "步行 3 min"
                } else {
                    self.shopDistanceLabel.text = String(format: "%.1f%@", distance, unit)
                }
            } else {
                self.shopDistanceLabel.text = String(format: "%.1f%@", distance, unit)
            }
        }
    }
}

class KPMainListCellScoreLabel: UILabel {
    
    private var scoreLabel: UILabel!
    var contentBackgroundColor: UIColor! {
        didSet {
            backgroundColor = contentBackgroundColor
            scoreLabel.backgroundColor = contentBackgroundColor
        }
    }
    var score: String! {
        didSet {
            scoreLabel.text = score
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = KPColorPalette.KPBackgroundColor.mainColor
        layer.cornerRadius = 2.0
        layer.masksToBounds = true
        
        scoreLabel = UILabel()
        scoreLabel.textColor = KPColorPalette.KPTextColor.whiteColor
        scoreLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        scoreLabel.isOpaque = true
        scoreLabel.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor
        addSubview(scoreLabel)
        scoreLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        scoreLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
