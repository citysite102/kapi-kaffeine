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
                                               self.dataModel.rates?.average?.floatValue ?? 0)
            }
            
            if let photoURL = dataModel.photos?["google_s"] {
                self.shopImageView.af_setImage(withURL: URL(string: photoURL)!,
                                               placeholderImage: R.image.icon_loading())
            } else {
                self.shopImageView.image = R.image.icon_noImage()
            }
            
            if let currentLocation = KPLocationManager.sharedInstance().currentLocation {
                var distance = CLLocation(latitude: dataModel.latitude, longitude: dataModel.longitude).distance(from: currentLocation)
                var unit = "m"
                if distance > 1000 {
                    unit = "km"
                    distance = distance/1000
                }
                self.shopDistanceLabel.text = "\(Int(distance))\(unit)"
            } else {
                self.shopDistanceLabel.text = "-"
            }
            
            if dataModel.businessHour != nil {
                let shopStatus = dataModel.businessHour.shopStatus
                shopStatusLabel.textColor = KPColorPalette.KPTextColor.grayColor;
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
//    var shopOpened: Bool = true {
//        didSet {
//            self.shopStatusHint.backgroundColor = shopOpened ?
//            KPColorPalette.KPShopStatusColor.opened :
//            KPColorPalette.KPShopStatusColor.closed
//        }
//    }
//    var shopStatusContent: String = "營業中" {
//        didSet {
//            shopStatusLabel.text = self.shopOpened ?
//                "營業中"+shopStatusContent :
//                "休息中"+shopStatusContent;
//        }
//    }
    
    var shopImageView: UIImageView!
    var shopNameLabel: KPMainListCellNormalLabel!
    var shopDistanceLabel: KPMainListCellNormalLabel!
    var scoreLabel: KPMainListCellScoreLabel!
    
    private var shopStatusHint: UIView!
    private var shopStatusLabel: UILabel!
    private var featureContainer: KPMainListCellFeatureContainer!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        shopImageView = UIImageView(image: UIImage(named: "demo_6"));        
        shopImageView.contentMode = .scaleAspectFill;
        shopImageView.clipsToBounds = true
        shopImageView.layer.cornerRadius = 2.0
        contentView.addSubview(shopImageView);
        shopImageView.addConstraints(fromStringArray: ["H:|-8-[$self(56)]",
                                                            "V:|-12-[$self(56)]-12-|"]);
        
        shopNameLabel = KPMainListCellNormalLabel();
        shopNameLabel.font = UIFont.systemFont(ofSize: 14.0);
        shopNameLabel.textColor = KPColorPalette.KPTextColor.grayColor;
        contentView.addSubview(shopNameLabel);

        shopNameLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self($metric0)]",
                                                            "V:|-12-[$self]"],
                                          metrics: [UIScreen.main.bounds.size.width/2],
                                          views: [shopImageView]);
        
        shopStatusHint = UIView();
        shopStatusHint.backgroundColor = KPColorPalette.KPShopStatusColor.opened;
        shopStatusHint.layer.cornerRadius = 3.0;
        contentView.addSubview(shopStatusHint);
        shopStatusHint.addConstraints(fromStringArray: ["H:[$view0]-9-[$self(6)]",
                                                             "V:[$view1]-7-[$self(6)]"],
                                          views: [shopImageView,
                                                  shopNameLabel]);
        
        shopStatusLabel = UILabel();
        shopStatusLabel.font = UIFont.systemFont(ofSize: 12.0);
        shopStatusLabel.textColor = KPColorPalette.KPTextColor.grayColor;
        shopStatusLabel.text = "營業中 12:00-21:00";
        contentView.addSubview(shopStatusLabel);
        shopStatusLabel.addConstraints(fromStringArray: ["H:[$view0]-5-[$self($metric0)]"],
                                            metrics: [UIScreen.main.bounds.size.width/2],
                                            views: [shopStatusHint,
                                                    shopNameLabel]);
        shopStatusLabel.addConstraintForCenterAligning(to: shopStatusHint, in: .vertical);
        
        shopDistanceLabel = KPMainListCellNormalLabel();
        shopDistanceLabel.font = UIFont.systemFont(ofSize: 20.0);
        shopDistanceLabel.textColor = KPColorPalette.KPTextColor.mainColor;
        shopDistanceLabel.text = "600m";
        shopDistanceLabel.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        contentView.addSubview(shopDistanceLabel);
        shopDistanceLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
                                                                "V:[$self]-10-|"],
                                              views: [shopImageView,
                                                      shopStatusLabel]);
        
        scoreLabel = KPMainListCellScoreLabel();
        contentView.addSubview(scoreLabel);
        scoreLabel.addConstraints(fromStringArray: ["H:[$self(30)]-8-|",
                                                         "V:|-12-[$self(22)]"]);
        
        featureContainer = KPMainListCellFeatureContainer();
        contentView.addSubview(featureContainer);
        featureContainer.addConstraints(fromStringArray: ["H:[$self]-8-|",
                                                               "V:[$self]-12-|"]);
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = selected ? KPColorPalette.KPMainColor.grayColor_level6 : UIColor.white;
        // Configure the view for the selected state
    }
}

class KPMainListCellNormalLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, 0, 0, 0)));
    }
}


class KPMainListCellScoreLabel: UILabel {
    
    
    var scoreLabel:UILabel!;
    var score:String! {
        didSet {
            scoreLabel.text = score;
        }
    };
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        backgroundColor = KPColorPalette.KPBackgroundColor.cellScoreBgColor;
        layer.cornerRadius = 2.0;
        layer.masksToBounds = true;
        
        scoreLabel = UILabel();
        scoreLabel.textColor = KPColorPalette.KPTextColor.whiteColor;
        scoreLabel.font = UIFont.systemFont(ofSize: 14.0);
        addSubview(scoreLabel);
        scoreLabel.addConstraintForCenterAligningToSuperview(in: .vertical);
        scoreLabel.addConstraintForCenterAligningToSuperview(in: .horizontal);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
