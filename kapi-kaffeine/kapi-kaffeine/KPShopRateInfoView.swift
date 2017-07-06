//
//  KPShopScoreInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopRateInfoView: UIView {

    var rateTitles = ["WiFi穩定", "安靜程度", "價格實惠",
                      "座位數量", "咖啡品質", "餐點美味",
                      "環境舒適"]
    var rateImages = [R.image.icon_wifi(), R.image.icon_sleep(), R.image.icon_money(),
                      R.image.icon_seat(), R.image.icon_cup(), R.image.icon_cutlery(),
                      R.image.icon_pic()]
    
    var rateViews: [rateStatusView] = [rateStatusView]()
    var rateContents = [String]()
    var rates: KPDataRateModel! {
        didSet {
            rateContents.append(rates.wifi != nil ?
                (rates.wifi?.stringValue.characters.count == 1 ? "\((rates.wifi?.stringValue)!).0" : "\((rates.wifi?.stringValue)!)") :
                "0.0")
            rateContents.append(rates.quite != nil ?
                (rates.quite?.stringValue.characters.count == 1 ? "\((rates.quite?.stringValue)!).0" : "\((rates.quite?.stringValue)!)") :
                "0.0")
            rateContents.append(rates.cheap != nil ?
                (rates.cheap?.stringValue.characters.count == 1 ? "\((rates.cheap?.stringValue)!).0" : "\((rates.cheap?.stringValue)!)") :
                "0.0")
            rateContents.append(rates.seat != nil ?
                (rates.seat?.stringValue.characters.count == 1 ? "\((rates.seat?.stringValue)!).0" : "\((rates.seat?.stringValue)!)") :
                "0.0")
            rateContents.append(rates.tasty != nil ?
                (rates.tasty?.stringValue.characters.count == 1 ? "\((rates.tasty?.stringValue)!).0" : "\((rates.tasty?.stringValue)!)") :
                "0.0")
            rateContents.append(rates.food != nil ?
                (rates.food?.stringValue.characters.count == 1 ? "\((rates.food?.stringValue)!).0" : "\((rates.food?.stringValue)!)") :
                "0.0")
            rateContents.append(rates.music != nil ?
                (rates.music?.stringValue.characters.count == 1 ? "\((rates.music?.stringValue)!).0" : "\((rates.music?.stringValue)!)") :
                "0.0")
            
            for (index, rateView) in rateViews.enumerated() {
                rateView.rateContentLabel.text = rateContents[index]
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
        
        for (index, property) in rateTitles.enumerated() {
        
            let rateView = rateStatusView.init(frame:.zero,
                                               icon:rateImages[index]!,
                                               content:property,
                                               rateContent:"0.0")
            addSubview(rateView!)
            rateViews.append(rateView!)
            
            rateView!.addConstraint(forWidth: (UIScreen.main.bounds.size.width-48)/2)
            if index == 0 {
                rateView!.addConstraints(fromStringArray: ["V:|-16-[$self(24)]",
                                                           "H:|-16-[$self]"])
                
            } else if index == 4 {
                rateView!.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(24)]-16-|",
                                                           "H:|-16-[$self]"],
                                         views: [rateViews[index-1]])
                
            } else if index == 5 {
                rateView!.addConstraints(fromStringArray: ["V:|-16-[$self(24)]",
                                                           "H:[$view0]-16-[$self]"],
                                         views:[rateViews[0]])

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
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

class rateStatusView: UIView {
    
    var iconImageView: UIImageView!
    var rateTitleLabel: UILabel!
    var rateContentLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
    }
    
    public convenience init?(frame: CGRect,
                             icon: UIImage,
                             content: String,
                             rateContent: String) {
        self.init(frame:frame)
        
        iconImageView = UIImageView.init(image: icon)
        iconImageView.tintColor = KPColorPalette.KPMainColor.mainColor
        addSubview(iconImageView)
        iconImageView.addConstraints(fromStringArray: ["V:|[$self(24)]|",
                                                       "H:|[$self(24)]"])
        
        rateTitleLabel = UILabel.init()
        rateTitleLabel.font = UIFont.systemFont(ofSize: 13.0)
        rateTitleLabel.text = content
        rateTitleLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3
        addSubview(rateTitleLabel)
        rateTitleLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]"],
                                      views: [iconImageView])
        rateTitleLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        rateContentLabel = UILabel.init()
        rateContentLabel.font = UIFont.systemFont(ofSize: 13.0)
        rateContentLabel.text = rateContent
        rateContentLabel.textColor = KPColorPalette.KPTextColor.mainColor_light
        addSubview(rateContentLabel)
        rateContentLabel.addConstraints(fromStringArray: ["H:[$self]|"],
                                         views: [rateTitleLabel])
        rateContentLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
