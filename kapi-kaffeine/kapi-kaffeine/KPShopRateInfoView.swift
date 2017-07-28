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
                      "環境舒適", "有無限時", "站立座位"]
    var rateImages = [R.image.icon_wifi(), R.image.icon_sleep(), R.image.icon_money(),
                      R.image.icon_seat(), R.image.icon_cup(), R.image.icon_cutlery(),
                      R.image.icon_pic(), R.image.icon_clock(), R.image.icon_seat()]
    
    var rateViews: [rateStatusView] = [rateStatusView]()
    var rateContents = [String]()
    
    weak var dataModel: KPDataModel! {
        didSet {
            rateContents = []
            rateContents.append(dataModel.wifiAverage != nil ?
                (dataModel.wifiAverage?.stringValue.characters.count == 1 ?
                    "\((dataModel.wifiAverage?.stringValue)!).0" :
                    "\((dataModel.wifiAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(dataModel.quietAverage != nil ?
                (dataModel.quietAverage?.stringValue.characters.count == 1 ?
                    "\((dataModel.quietAverage?.stringValue)!).0" :
                    "\((dataModel.quietAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(dataModel.cheapAverage != nil ?
                (dataModel.cheapAverage?.stringValue.characters.count == 1 ?
                    "\((dataModel.cheapAverage?.stringValue)!).0" :
                    "\((dataModel.cheapAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(dataModel.seatAverage != nil ?
                (dataModel.seatAverage?.stringValue.characters.count == 1 ?
                    "\((dataModel.seatAverage?.stringValue)!).0" :
                    "\((dataModel.seatAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(dataModel.tastyAverage != nil ?
                (dataModel.tastyAverage?.stringValue.characters.count == 1 ?
                    "\((dataModel.tastyAverage?.stringValue)!).0" :
                    "\((dataModel.tastyAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(dataModel.foodAverage != nil ?
                (dataModel.foodAverage?.stringValue.characters.count == 1 ?
                    "\((dataModel.foodAverage?.stringValue)!).0" :
                    "\((dataModel.foodAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(dataModel.musicAverage != nil ?
                (dataModel.musicAverage?.stringValue.characters.count == 1 ?
                    "\((dataModel.musicAverage?.stringValue)!).0" :
                    "\((dataModel.musicAverage?.stringValue)!)") :
                "0.0")
            
            
            if let limitedTime = dataModel.limitedTime {
                if limitedTime == 1 {
                    rateContents.append("客滿")
                } else if limitedTime == 2 {
                    rateContents.append("不限")
                } else if limitedTime == 3 {
                    rateContents.append("人多")
                } else if limitedTime == 4 {
                    rateContents.append("未知")
                }
            } else {
                rateContents.append("未知")
            }
            
            if let standingDesk = dataModel.standingDesk {
                if standingDesk == 1 {
                    rateContents.append("有")
                } else if standingDesk == 4 {
                    rateContents.append("未知")
                } else {
                    rateContents.append("未知")
                }
            } else {
                rateContents.append("未知")
            }
            
            for (index, rateView) in rateViews.enumerated() {
                rateView.rateContentLabel.text = rateContents[index]
            }
        }
    }
    
    var rateData: KPRateDataModel! {
        didSet {
            rateContents = []
            rateContents.append(rateData.wifiAverage != nil ?
                (rateData.wifiAverage?.stringValue.characters.count == 1 ?
                    "\((rateData.wifiAverage?.stringValue)!).0" :
                    "\((rateData.wifiAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(rateData.quietAverage != nil ?
                (rateData.quietAverage?.stringValue.characters.count == 1 ?
                    "\((rateData.quietAverage?.stringValue)!).0" :
                    "\((rateData.quietAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(rateData.cheapAverage != nil ?
                (rateData.cheapAverage?.stringValue.characters.count == 1 ?
                    "\((rateData.cheapAverage?.stringValue)!).0" :
                    "\((rateData.cheapAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(rateData.seatAverage != nil ?
                (rateData.seatAverage?.stringValue.characters.count == 1 ?
                    "\((rateData.seatAverage?.stringValue)!).0" :
                    "\((rateData.seatAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(rateData.tastyAverage != nil ?
                (rateData.tastyAverage?.stringValue.characters.count == 1 ?
                    "\((rateData.tastyAverage?.stringValue)!).0" :
                    "\((rateData.tastyAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(rateData.foodAverage != nil ?
                (rateData.foodAverage?.stringValue.characters.count == 1 ?
                    "\((rateData.foodAverage?.stringValue)!).0" :
                    "\((rateData.foodAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(rateData.musicAverage != nil ?
                (rateData.musicAverage?.stringValue.characters.count == 1 ?
                    "\((rateData.musicAverage?.stringValue)!).0" :
                    "\((rateData.musicAverage?.stringValue)!)") :
                "0.0")

            
            if let limitedTime = dataModel.limitedTime {
                if limitedTime == 1 {
                    rateContents.append("客滿")
                } else if limitedTime == 2 {
                    rateContents.append("不限")
                } else if limitedTime == 3 {
                    rateContents.append("人多")
                } else if limitedTime == 4 {
                    rateContents.append("未知")
                }
            } else {
                rateContents.append("未知")
            }
            
            if let standingDesk = dataModel.standingDesk {
                if standingDesk == 1 {
                    rateContents.append("有")
                } else if standingDesk == 4 {
                    rateContents.append("未知")
                } else {
                    rateContents.append("未知")
                }
            } else {
                rateContents.append("未知")
            }
            
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
        
        rateTitleLabel = UILabel()
        rateTitleLabel.font = UIFont.systemFont(ofSize: 13.0)
        rateTitleLabel.text = content
        rateTitleLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3
        addSubview(rateTitleLabel)
        rateTitleLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]"],
                                      views: [iconImageView])
        rateTitleLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        rateContentLabel = UILabel()
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
