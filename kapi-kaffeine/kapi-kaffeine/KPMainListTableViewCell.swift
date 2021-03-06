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

    var dataModel: KPDataModel! {
        didSet {
            
            DispatchQueue.main.async {
                self.shopNameLabel.text = self.dataModel.name ?? "未命名"
                self.featureContainer.featureContents = self.dataModel.featureContents
                self.scoreLabel.score = String(format: "%.1f",
                                               (self.dataModel.averageRate?.doubleValue) ?? 0)
                
                if self.dataModel.closed {
                    self.shopNameLabel.text = "(已歇業) " + (self.dataModel.name ?? "未命名")
                    self.shopStatusLabel.textColor = KPColorPalette.KPTextColor.grayColor_level5
                    self.shopStatusHint.backgroundColor = KPColorPalette.KPTextColor.grayColor_level5
                    self.shopStatusLabel.text = "已歇業"
                } else {
                    if self.dataModel.businessHour != nil {
                        let shopStatus = self.dataModel.businessHour!.shopStatus
                        self.shopStatusLabel.textColor = KPColorPalette.KPTextColor.grayColor
                        self.shopStatusLabel.text = shopStatus.status
                        self.shopStatusHint.backgroundColor = shopStatus.isOpening ?
                                KPColorPalette.KPShopStatusColor.opened :
                                KPColorPalette.KPShopStatusColor.closed
                    } else {
                        self.shopStatusLabel.textColor = KPColorPalette.KPTextColor.grayColor_level5
                        self.shopStatusHint.backgroundColor = KPColorPalette.KPTextColor.grayColor_level5
                        self.shopStatusLabel.text = "暫無資料"
                    }
                }
                
            }
//            self.shopImageView.image = R.image.demo_6()
            if let photoURL = dataModel.covers?["kapi_s"] ?? dataModel.covers?["google_s"] {
                self.shopImageView.af_setImage(withURL: URL(string: photoURL)!,
                                               placeholderImage: drawImage(image: R.image.icon_loading()!,
                                                                           rectSize: CGSize(width: 56, height: 56),
                                                                           roundedRadius: 3),
                                               filter: nil,
                                               progress: nil,
                                               progressQueue: DispatchQueue.global(),
                                               imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                               runImageTransitionIfCached: true,
                                               completion: { response in
                                                if let responseImage = response.result.value {
                                                    self.shopImageView.image =  drawImage(image: responseImage,
                                                                                          rectSize: CGSize(width: 56, height: 56),
                                                                                          roundedRadius: 3)
                                                } else {
                                                    self.shopImageView.image =  drawImage(image: R.image.icon_noImage()!,
                                                                                          rectSize: CGSize(width: 56, height: 56),
                                                                                          roundedRadius: 3)
                                                }
                })
            } else {
                self.shopImageView.image = drawImage(image: R.image.icon_noImage()!,
                                                     rectSize: CGSize(width: 56, height: 56),
                                                     roundedRadius: 3)
            }
            
            locationDidUpdate()
        }
    }
    
    var shopImageView: UIImageView!
    var shopNameLabel: KPLayerLabel!
    var shopDistanceLabel: KPLayerLabel!
    var scoreLabel: KPMainListCellScoreLabel!
    var separator: UIView!
    
    private var shopStatusHint: UIView!
    private var shopStatusLabel: UILabel!
    private var featureContainer: KPMainListCellFeatureContainer!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        shopImageView = UIImageView(image: drawImage(image: R.image.demo_6()!,
                                                     rectSize: CGSize(width: 56, height: 56),
                                                     roundedRadius: 3))
        shopImageView.contentMode = .scaleAspectFill
        shopImageView.clipsToBounds = true
        contentView.addSubview(shopImageView)
            
        shopImageView.addConstraints(fromStringArray: ["H:|-8-[$self(60)]",
                                                       "V:|-12-[$self(60)]-12-|"])
        
        shopNameLabel = KPLayerLabel()
        shopNameLabel.font = UIFont.systemFont(ofSize: 14.0)
        shopNameLabel.textColor = KPColorPalette.KPTextColor.grayColor
        shopNameLabel.isOpaque = true
        shopNameLabel.layer.masksToBounds = true
        contentView.addSubview(shopNameLabel)

        shopNameLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self($metric0)]",
                                                       "V:|-12-[$self]"],
                                          metrics: [UIScreen.main.bounds.size.width/2],
                                          views: [shopImageView])
        
        shopStatusHint = UIView()
        shopStatusHint.backgroundColor = KPColorPalette.KPShopStatusColor.opened
        shopStatusHint.layer.cornerRadius = 3.0
        shopStatusHint.isOpaque = true
        contentView.addSubview(shopStatusHint)
        shopStatusHint.addConstraints(fromStringArray: ["H:[$view0]-8-[$self(6)]",
                                                        "V:[$view1]-10-[$self(6)]"],
                                          views: [shopImageView,
                                                  shopNameLabel])
        
        shopStatusLabel = KPLayerLabel()
        shopStatusLabel.font = UIFont.systemFont(ofSize: 12.0)
        shopStatusLabel.textColor = KPColorPalette.KPTextColor.grayColor
        shopStatusLabel.text = "營業時間 未知"
        shopStatusLabel.isOpaque = true
        shopStatusLabel.layer.masksToBounds = true
        contentView.addSubview(shopStatusLabel)
        shopStatusLabel.addConstraints(fromStringArray: ["H:[$view0]-5-[$self($metric0)]"],
                                            metrics: [UIScreen.main.bounds.size.width/2],
                                            views: [shopStatusHint,
                                                    shopNameLabel])
        shopStatusLabel.addConstraintForCenterAligning(to: shopStatusHint,
                                                       in: .vertical,
                                                       constant: -2)
        
        shopDistanceLabel = KPLayerLabel()
        shopDistanceLabel.font = UIFont.systemFont(ofSize: 20.0)
        shopDistanceLabel.textColor = KPColorPalette.KPTextColor.mainColor
        shopDistanceLabel.text = "0m"
        shopDistanceLabel.isOpaque = true
        shopDistanceLabel.layer.masksToBounds = true
        shopDistanceLabel.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        contentView.addSubview(shopDistanceLabel)
        shopDistanceLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
                                                           "V:[$self]-8-|"],
                                              views: [shopImageView,
                                                      shopStatusLabel])
        
        scoreLabel = KPMainListCellScoreLabel()
        contentView.addSubview(scoreLabel)
        scoreLabel.addConstraints(fromStringArray: ["H:[$self(30)]-8-|",
                                                    "V:|-12-[$self(22)]"])
        
        featureContainer = KPMainListCellFeatureContainer()
        contentView.addSubview(featureContainer)
        featureContainer.addConstraints(fromStringArray: ["H:[$self]-8-|",
                                                          "V:[$self]-10-|"])
        
        separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        contentView.addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:[$self(1)]|",
                                                   "H:|[$self]|"])
        
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
        backgroundColor = selected ? KPColorPalette.KPBackgroundColor.grayColor_level6 : UIColor.white
        // Configure the view for the selected state
    }
    
    func locationDidUpdate() {
        if let distanceInMeter = dataModel.distanceInMeter {
            var distance = distanceInMeter
            var unit = "m"
            if distance > 1000 {
                unit = "km"
                distance = distance/1000
            }
            self.shopDistanceLabel.text = String(format: "%.1f%@", distance, unit)
        } else {
            self.shopDistanceLabel.text = "-"
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
        scoreLabel.font = UIFont.systemFont(ofSize: 14.0)
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
