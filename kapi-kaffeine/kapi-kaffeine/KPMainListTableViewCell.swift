//
//  KPMainListTableViewCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import CoreLocation

class KPMainListTableViewCell: UITableViewCell {

    var dataModel: KPDataModel! {
        didSet {
            self.shopNameLabel.text = dataModel.name
            if let latstr = dataModel.latitude, let latitude = Double(latstr),
                let longstr = dataModel.longitude, let longitude = Double(longstr), let currentLocation = KPLocationManager.sharedInstance().currentLocation {
                var distance = CLLocation(latitude: latitude, longitude: longitude).distance(from: currentLocation)
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
    var shopOpened: Bool = true {
        didSet {
            self.shopStatusHint.backgroundColor = shopOpened ?
            KPColorPalette.KPShopStatusColor.opened :
            KPColorPalette.KPShopStatusColor.closed
        }
    }
    var shopStatusContent: String = "營業中" {
        didSet {
            self.shopStatusLabel.text = self.shopOpened ?
                "營業中"+shopStatusContent :
                "休息中"+shopStatusContent;
        }
    }
    
    var shopImageView: UIImageView!
    var shopNameLabel: KPMainListCellNormalLabel!
    var shopDistanceLabel: KPMainListCellNormalLabel!
    var scoreLabel: KPMainListCellScoreLabel!
    
    private var shopStatusHint: UIView!
    private var shopStatusLabel: UILabel!
    private var featureContainer: KPMainListCellFeatureContainer!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.shopImageView = UIImageView(image: UIImage(named: "image_shop_demo"));
        self.shopImageView.contentMode = .scaleAspectFit;
        self.addSubview(self.shopImageView);
        self.shopImageView.addConstraints(fromStringArray: ["H:|-8-[$self(56)]",
                                                            "V:|-12-[$self(56)]-12-|"]);
        
        self.shopNameLabel = KPMainListCellNormalLabel();
        self.shopNameLabel.font = UIFont.systemFont(ofSize: 14.0);
        self.shopNameLabel.textColor = KPColorPalette.KPTextColor.grayColor;
        self.shopNameLabel.text = "覺旅咖啡";
        self.addSubview(self.shopNameLabel);

        self.shopNameLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self($metric0)]",
                                                            "V:|-12-[$self]"],
                                          metrics: [UIScreen.main.bounds.size.width/2],
                                          views: [self.shopImageView]);
        
        self.shopStatusHint = UIView();
        self.shopStatusHint.backgroundColor = KPColorPalette.KPShopStatusColor.opened;
        self.shopStatusHint.layer.cornerRadius = 3.0;
        self.addSubview(self.shopStatusHint);
        self.shopStatusHint.addConstraints(fromStringArray: ["H:[$view0]-9-[$self(6)]",
                                                             "V:[$view1]-7-[$self(6)]"],
                                          views: [self.shopImageView,
                                                  self.shopNameLabel]);
        
        self.shopStatusLabel = UILabel();
        self.shopStatusLabel.font = UIFont.systemFont(ofSize: 12.0);
        self.shopStatusLabel.textColor = KPColorPalette.KPTextColor.grayColor;
        self.shopStatusLabel.text = "營業中 12:00-21:00";
        self.addSubview(self.shopStatusLabel);
        self.shopStatusLabel.addConstraints(fromStringArray: ["H:[$view0]-5-[$self($metric0)]"],
                                            metrics: [UIScreen.main.bounds.size.width/2],
                                            views: [self.shopStatusHint,
                                                    self.shopNameLabel]);
        self.shopStatusLabel.addConstraintForCenterAligning(to: self.shopStatusHint, in: .vertical);
        
        self.shopDistanceLabel = KPMainListCellNormalLabel();
        self.shopDistanceLabel.font = UIFont.systemFont(ofSize: 20.0);
        self.shopDistanceLabel.textColor = KPColorPalette.KPTextColor.mainColor;
        self.shopDistanceLabel.text = "600m";
        self.shopDistanceLabel.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
        self.addSubview(self.shopDistanceLabel);
        self.shopDistanceLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
                                                                "V:[$self]-10-|"],
                                              views: [self.shopImageView,
                                                      self.shopStatusLabel]);
        
        self.scoreLabel = KPMainListCellScoreLabel();
        self.scoreLabel.score = "4.3";
        self.addSubview(self.scoreLabel);
        self.scoreLabel.addConstraints(fromStringArray: ["H:[$self(30)]-8-|",
                                                         "V:|-12-[$self(22)]"]);
        
        self.featureContainer = KPMainListCellFeatureContainer();
        self.featureContainer.featureContents = ["燈光美", "氣氛佳"];
        self.addSubview(self.featureContainer);
        self.featureContainer.addConstraints(fromStringArray: ["H:[$self]-8-|",
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
            self.scoreLabel.text = score;
        }
    };
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.backgroundColor = KPColorPalette.KPBackgroundColor.cellScoreBgColor;
        self.layer.cornerRadius = 2.0;
        self.layer.masksToBounds = true;
        
        self.scoreLabel = UILabel();
        self.scoreLabel.textColor = KPColorPalette.KPTextColor.whiteColor;
        self.scoreLabel.font = UIFont.systemFont(ofSize: 14.0);
        self.addSubview(self.scoreLabel);
        self.scoreLabel.addConstraintForCenterAligningToSuperview(in: .vertical);
        self.scoreLabel.addConstraintForCenterAligningToSuperview(in: .horizontal);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
