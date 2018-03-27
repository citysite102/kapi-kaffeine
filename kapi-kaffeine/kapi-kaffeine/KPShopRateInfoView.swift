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
                      "環境舒適", "有無限時", "站立座位",
                      "插座數量"]
    var rateImages = [R.image.icon_wifi(), R.image.icon_sleep(), R.image.icon_money(),
                      R.image.icon_seat(), R.image.icon_cup(), R.image.icon_cutlery(),
                      R.image.icon_pic(), R.image.icon_time(), R.image.icon_stand(),
                      R.image.icon_socket()]
    
    var rateViews: [rateStatusView] = [rateStatusView]()
    var rateContents = [String]()
    
    weak var dataModel: KPDetailedDataModel! {
        didSet {
            rateContents = []
            rateContents.append("0.0")
            rateContents.append("0.0")
            rateContents.append("0.0")
            rateContents.append("0.0")
            rateContents.append("0.0")
            rateContents.append("0.0")
            rateContents.append("0.0")
//            rateContents.append(dataModel.wifiAverage != nil ?
//                (dataModel.wifiAverage?.stringValue.count == 1 ?
//                    "\((dataModel.wifiAverage?.stringValue)!).0" :
//                    "\((dataModel.wifiAverage?.stringValue)!)") :
//                "0.0")
//            rateContents.append(dataModel.quietAverage != nil ?
//                (dataModel.quietAverage?.stringValue.count == 1 ?
//                    "\((dataModel.quietAverage?.stringValue)!).0" :
//                    "\((dataModel.quietAverage?.stringValue)!)") :
//                "0.0")
//            rateContents.append(dataModel.cheapAverage != nil ?
//                (dataModel.cheapAverage?.stringValue.count == 1 ?
//                    "\((dataModel.cheapAverage?.stringValue)!).0" :
//                    "\((dataModel.cheapAverage?.stringValue)!)") :
//                "0.0")
//            rateContents.append(dataModel.seatAverage != nil ?
//                (dataModel.seatAverage?.stringValue.count == 1 ?
//                    "\((dataModel.seatAverage?.stringValue)!).0" :
//                    "\((dataModel.seatAverage?.stringValue)!)") :
//                "0.0")
//            rateContents.append(dataModel.tastyAverage != nil ?
//                (dataModel.tastyAverage?.stringValue.count == 1 ?
//                    "\((dataModel.tastyAverage?.stringValue)!).0" :
//                    "\((dataModel.tastyAverage?.stringValue)!)") :
//                "0.0")
//            rateContents.append(dataModel.foodAverage != nil ?
//                (dataModel.foodAverage?.stringValue.count == 1 ?
//                    "\((dataModel.foodAverage?.stringValue)!).0" :
//                    "\((dataModel.foodAverage?.stringValue)!)") :
//                "0.0")
//            rateContents.append(dataModel.musicAverage != nil ?
//                (dataModel.musicAverage?.stringValue.count == 1 ?
//                    "\((dataModel.musicAverage?.stringValue)!).0" :
//                    "\((dataModel.musicAverage?.stringValue)!)") :
//                "0.0")
            
            
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
            
            if let socket = dataModel.socket {
                if socket == 1 {
                    rateContents.append("多")
                } else if socket == 2 {
                    rateContents.append("少")
                } else if socket == 3 {
                    rateContents.append("部分")
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
                (rateData.wifiAverage?.stringValue.count == 1 ?
                    "\((rateData.wifiAverage?.stringValue)!).0" :
                    "\((rateData.wifiAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(rateData.quietAverage != nil ?
                (rateData.quietAverage?.stringValue.count == 1 ?
                    "\((rateData.quietAverage?.stringValue)!).0" :
                    "\((rateData.quietAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(rateData.cheapAverage != nil ?
                (rateData.cheapAverage?.stringValue.count == 1 ?
                    "\((rateData.cheapAverage?.stringValue)!).0" :
                    "\((rateData.cheapAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(rateData.seatAverage != nil ?
                (rateData.seatAverage?.stringValue.count == 1 ?
                    "\((rateData.seatAverage?.stringValue)!).0" :
                    "\((rateData.seatAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(rateData.tastyAverage != nil ?
                (rateData.tastyAverage?.stringValue.count == 1 ?
                    "\((rateData.tastyAverage?.stringValue)!).0" :
                    "\((rateData.tastyAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(rateData.foodAverage != nil ?
                (rateData.foodAverage?.stringValue.count == 1 ?
                    "\((rateData.foodAverage?.stringValue)!).0" :
                    "\((rateData.foodAverage?.stringValue)!)") :
                "0.0")
            rateContents.append(rateData.musicAverage != nil ?
                (rateData.musicAverage?.stringValue.count == 1 ?
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
                } else {
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
            
            if let socket = dataModel.socket {
                if socket == 1 {
                    rateContents.append("多")
                } else if socket == 2 {
                    rateContents.append("少")
                } else if socket == 3 {
                    rateContents.append("部分")
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
            
            rateView!.addConstraint(forWidth: (UIScreen.main.bounds.size.width-72)/2)
            if index == 0 {
                rateView!.addConstraints(fromStringArray: ["V:|[$self(24)]",
                                                           "H:|-($metric0)-[$self]"],
                                         metrics:[KPLayoutConstant.information_horizontal_offset])
                
            } else if index == 4 {
                rateView!.addConstraints(fromStringArray: ["V:[$view0]-14-[$self(24)]-($metric0)-|",
                                                           "H:|-($metric0)-[$self]"],
                                         metrics:[KPLayoutConstant.information_horizontal_offset],
                                         views: [rateViews[index-1]])
                
            } else if index == 5 {
                rateView!.addConstraints(fromStringArray: ["V:|[$self(24)]",
                                                           "H:[$self]-($metric0)-|"],
                                         metrics:[KPLayoutConstant.information_horizontal_offset],
                                         views:[rateViews[0]])

            } else if index == 6 || index == 7 || index == 8 || index == 9 {
                rateView!.addConstraints(fromStringArray: ["V:[$view0]-14-[$self(24)]",
                                                           "H:[$self]-($metric0)-|"],
                                         metrics:[KPLayoutConstant.information_horizontal_offset],
                                         views:[rateViews[index-1],
                                                rateViews[0]])
            } else {
                rateView!.addConstraints(fromStringArray: ["V:[$view0]-14-[$self(24)]",
                                                           "H:|-($metric0)-[$self]"],
                                         metrics:[KPLayoutConstant.information_horizontal_offset],
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
//        iconImageView.tintColor = KPColorPalette.KPMainColor_v2.textColor_level2
//        addSubview(iconImageView)
//        iconImageView.addConstraints(fromStringArray: ["V:|[$self(20)]|",
//                                                       "H:|[$self(20)]"])
        
        rateTitleLabel = UILabel()
        rateTitleLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        rateTitleLabel.text = content
        rateTitleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        addSubview(rateTitleLabel)
        rateTitleLabel.addConstraints(fromStringArray: ["H:|[$self]"],
                                      views: [iconImageView])
        rateTitleLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        rateContentLabel = UILabel()
        rateContentLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        rateContentLabel.text = rateContent
        rateContentLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor_light
        addSubview(rateContentLabel)
        rateContentLabel.addConstraints(fromStringArray: ["H:[$self]|"],
                                         views: [rateTitleLabel])
        rateContentLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
