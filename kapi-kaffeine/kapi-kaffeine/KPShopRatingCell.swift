//
//  KPShopRatingCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/24.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopRatingCell: UITableViewCell {

    var userPicture: UIImageView!
    var userNameLabel: UILabel!
    var timeHintLabel: UILabel!
    var scoreLabel: KPMainListCellScoreLabel!
    var separator: UIView!
    var rateTitles = ["WiFi穩定", "安靜程度", "價格實惠",
                      "座位數量", "咖啡品質", "餐點美味",
                      "環境舒適"]
    var rateImages = [R.image.icon_wifi(), R.image.icon_sleep(), R.image.icon_money(),
                      R.image.icon_seat(), R.image.icon_cup(), R.image.icon_cutlery(),
                      R.image.icon_pic()]
    
    var rateViews: [rateStatusView] = [rateStatusView]()
    var rateContents = [String]()
    var rateData: KPSimpleRateModel! {
        didSet {
            
            var totalRate: CGFloat = 0
            var availableRateCount: CGFloat = 0
            
            
            if let wifi = rateData.wifi {
                rateContents.append(rateData.wifi?.stringValue.characters.count == 1 ?
                    "\((rateData.wifi?.stringValue)!).0" :
                    "\((rateData.wifi?.stringValue)!)")
                
                if wifi.floatValue != 0.0 {
                    totalRate = totalRate + wifi.cgFloatValue
                    availableRateCount = availableRateCount+1
                }
            } else {
                rateContents.append("0.0")
            }
            
            if let quiet = rateData.quiet {
                rateContents.append(rateData.quiet?.stringValue.characters.count == 1 ?
                    "\((rateData.quiet?.stringValue)!).0" :
                    "\((rateData.quiet?.stringValue)!)")
                
                if quiet.floatValue != 0.0 {
                    totalRate = totalRate + quiet.cgFloatValue
                    availableRateCount = availableRateCount+1
                }
            } else {
                rateContents.append("0.0")
            }
            
            if let cheap = rateData.cheap {
                rateContents.append(rateData.cheap?.stringValue.characters.count == 1 ?
                    "\((rateData.cheap?.stringValue)!).0" :
                    "\((rateData.cheap?.stringValue)!)")
                
                if cheap.floatValue != 0.0 {
                    totalRate = totalRate + cheap.cgFloatValue
                    availableRateCount = availableRateCount+1
                }
            } else {
                rateContents.append("0.0")
            }

            if let seat = rateData.seat {
                rateContents.append(rateData.seat?.stringValue.characters.count == 1 ?
                    "\((rateData.seat?.stringValue)!).0" :
                    "\((rateData.seat?.stringValue)!)")
                
                if seat.floatValue != 0.0 {
                    totalRate = totalRate + seat.cgFloatValue
                    availableRateCount = availableRateCount+1
                }
            } else {
                rateContents.append("0.0")
            }
            
            if let tasty = rateData.tasty {
                rateContents.append(rateData.tasty?.stringValue.characters.count == 1 ?
                    "\((rateData.tasty?.stringValue)!).0" :
                    "\((rateData.tasty?.stringValue)!)")
                
                if tasty.floatValue != 0.0 {
                    totalRate = totalRate + tasty.cgFloatValue
                    availableRateCount = availableRateCount+1
                }
            } else {
                rateContents.append("0.0")
            }
            
            if let food = rateData.food {
                rateContents.append(rateData.food?.stringValue.characters.count == 1 ?
                    "\((rateData.food?.stringValue)!).0" :
                    "\((rateData.food?.stringValue)!)")
                
                if food.floatValue != 0.0 {
                    totalRate = totalRate + food.cgFloatValue
                    availableRateCount = availableRateCount+1
                }
            } else {
                rateContents.append("0.0")
            }
            
            if let music = rateData.music {
                rateContents.append(rateData.music?.stringValue.characters.count == 1 ?
                    "\((rateData.music?.stringValue)!).0" :
                    "\((rateData.music?.stringValue)!)")
                
                if music.floatValue != 0.0 {
                    totalRate = totalRate + music.cgFloatValue
                    availableRateCount = availableRateCount+1
                }
            } else {
                rateContents.append("0.0")
            }
            
            let averageRate = totalRate/availableRateCount
            scoreLabel.score = String(format: "%.1f", averageRate)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        userPicture = UIImageView(image: R.image.demo_profile())
        userPicture.contentMode = .scaleAspectFit
        userPicture.layer.cornerRadius = 10.0
        userPicture.layer.borderWidth = 1.0
        userPicture.layer.borderColor = KPColorPalette.KPMainColor.grayColor_level5?.cgColor
        userPicture.layer.masksToBounds = true
        contentView.addSubview(userPicture)
        userPicture.addConstraints(fromStringArray: ["H:|-16-[$self(40)]",
                                                     "V:|-24-[$self(40)]"])
        
        
        userNameLabel = UILabel()
        userNameLabel.font = UIFont.systemFont(ofSize: 14.0)
        userNameLabel.text = "測試用名稱"
        userNameLabel.textColor = KPColorPalette.KPTextColor.mainColor
        contentView.addSubview(userNameLabel)
        userNameLabel.addConstraints(fromStringArray: ["H:[$view0]-16-[$self(190)]",
                                                       "V:|-24-[$self]"],
                                     views:[userPicture])
        
        timeHintLabel = UILabel()
        timeHintLabel.text = "一個世紀前"
        timeHintLabel.font = UIFont.systemFont(ofSize: 12.0)
        timeHintLabel.textColor = KPColorPalette.KPTextColor.grayColor_level4
        contentView.addSubview(timeHintLabel)
        timeHintLabel.addConstraints(fromStringArray: ["[$view0]-16-[$self]"],
                                     views:[userPicture])
        timeHintLabel.addConstraintForAligning(to: .bottom, of: userPicture)
        
        
        for (index, property) in rateTitles.enumerated() {
            let rateView = rateStatusView.init(frame:.zero,
                                               icon:rateImages[index]!,
                                               content:property,
                                               rateContent:"0.0")
            contentView.addSubview(rateView!)
            rateViews.append(rateView!)
            
            rateView!.addConstraint(forWidth: (UIScreen.main.bounds.size.width-48)/2)
            if index == 0 {
                rateView!.addConstraints(fromStringArray: ["V:[$view0]-20-[$self(24)]",
                                                           "H:|-16-[$self]"],
                                         views:[userPicture])
                
            } else if index == 4 {
                rateView!.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(24)]-16-|",
                                                           "H:|-16-[$self]"],
                                         views: [rateViews[index-1]])
                
            } else if index == 5 {
                rateView!.addConstraints(fromStringArray: ["V:[$view1]-20-[$self(24)]",
                                                           "H:[$view0]-16-[$self]"],
                                         views:[rateViews[0], userPicture])
                
            } else if index == 6 || index == 7 || index == 8 {
                rateView!.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(24)]",
                                                           "H:[$view1]-16-[$self]"],
                                         views:[rateViews[index-1],
                                                rateViews[0]])
            } else {
                rateView!.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(24)]",
                                                           "H:|-16-[$self]"],
                                         views: [rateViews[index-1]])
            }
        }
        
        scoreLabel = KPMainListCellScoreLabel()
        scoreLabel.score = "0.0"
        contentView.addSubview(scoreLabel)
        scoreLabel.addConstraints(fromStringArray: ["H:[$self(32)]-16-|",
                                                    "V:|-24-[$self(24)]"])
        
        separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        contentView.addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:[$self(1)]|",
                                                   "H:|-16-[$self]|"])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
