//
//  KPShopScoreInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopRateInfoView: UIView {

    var rateProperties = ["WiFi穩定", "價格實惠", "咖啡品質",
                          "插座數量", "站立座位", "安靜程度",
                          "通常有位置", "環境舒適度", "有無限時"];
    var rateViews:[rateStatusView] = [rateStatusView]();
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
        
        for (index, property) in self.rateProperties.enumerated() {
        
            let rateView = rateStatusView.init(frame:.zero,
                                               icon:R.image.icon_map()!,
                                               content:property,
                                               rateContent:"5.0");
            self.addSubview(rateView!);
            self.rateViews.append(rateView!);
            
            rateView!.addConstraint(forWidth: (UIScreen.main.bounds.size.width-48)/2);
            if index == 0 {
                rateView!.addConstraints(fromStringArray: ["V:|-16-[$self(24)]",
                                                           "H:|-16-[$self]"]);
                
            } else if index == 4 {
                rateView!.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(24)]-16-|",
                                                           "H:|-16-[$self]"],
                                         views: [self.rateViews[index-1]]);
                
            } else if index == 5 {
                rateView!.addConstraints(fromStringArray: ["V:|-16-[$self(24)]",
                                                           "H:[$view0]-16-[$self]"],
                                         views:[self.rateViews[0]]);

            } else if index == 6 || index == 7 || index == 8 {
                rateView!.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(24)]",
                                                           "H:[$view1]-16-[$self]"],
                                         views:[self.rateViews[index-1],
                                                self.rateViews[0]]);
            } else {
                rateView!.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(24)]",
                                                           "H:|-16-[$self]"],
                                         views: [self.rateViews[index-1]]);
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

class rateStatusView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
    }
    
    public convenience init?(frame: CGRect,
                             icon: UIImage,
                             content: String,
                             rateContent: String) {
        self.init(frame:frame);
        
        let iconImageView = UIImageView.init(image: icon);
        self.addSubview(iconImageView);
        iconImageView.addConstraints(fromStringArray: ["V:|[$self(24)]|",
                                                       "H:|[$self(24)]"]);
        
        let ratePropertyLabel = UILabel.init();
        ratePropertyLabel.font = UIFont.systemFont(ofSize: 13.0);
        ratePropertyLabel.text = content;
        ratePropertyLabel.textColor = KPColorPalette.KPTextColor.mainColor;
        self.addSubview(ratePropertyLabel);
        ratePropertyLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]"],
                                        views: [iconImageView])
        ratePropertyLabel.addConstraintForCenterAligningToSuperview(in: .vertical);
        
        let rateContentLabel = UILabel.init();
        rateContentLabel.font = UIFont.systemFont(ofSize: 13.0);
        rateContentLabel.text = rateContent;
        rateContentLabel.textColor = KPColorPalette.KPTextColor.mainColor_light;
        self.addSubview(rateContentLabel);
        rateContentLabel.addConstraints(fromStringArray: ["H:[$self]|"],
                                         views: [ratePropertyLabel])
        rateContentLabel.addConstraintForCenterAligningToSuperview(in: .vertical);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
