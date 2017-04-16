//
//  KPInformationHeaderButton.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/16.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

struct HeaderButtonInfo {
    let title: String
    let info: String
    let icon: UIImage
    let handler: (_ headerButton: KPInformationHeaderButton) -> ()
}

class KPInformationHeaderButton: UIView {

    var icon: UIImageView!;
    var titleLabel: UILabel!;
    var infoLable: UILabel!;
    var handler: ((_ headerButton: KPInformationHeaderButton) -> ())!;
    
    var buttonInfo: HeaderButtonInfo? {
        didSet {
            self.icon.image = buttonInfo?.icon;
            self.titleLabel.text = buttonInfo?.title;
            self.infoLable.text = buttonInfo?.info;
            self.handler = buttonInfo?.handler;
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = KPColorPalette.KPMainColor.borderColor?.cgColor;
        
        self.icon = UIImageView.init();
        self.addSubview(self.icon);
        self.icon.addConstraintForCenterAligningToSuperview(in: .horizontal);
        self.icon.addConstraint(from: "V:|-12-[$self]");
        
        self.titleLabel = UILabel.init();
        self.titleLabel.font = UIFont.systemFont(ofSize: 13);
        self.titleLabel.textColor = KPColorPalette.KPTextColor.cellDistanceColor;
        self.addSubview(self.titleLabel);
        self.titleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal);
        self.titleLabel.addConstraint(from: "V:[$view0]-4-[$self]",
                                      views: [self.icon]);
        
        self.infoLable = UILabel.init();
        self.infoLable.font = UIFont.systemFont(ofSize: 11);
        self.infoLable.alpha = 0.7;
        self.infoLable.textColor = KPColorPalette.KPTextColor.grayColor;
        self.addSubview(self.infoLable);
        self.infoLable.addConstraintForCenterAligningToSuperview(in: .horizontal);
        self.infoLable.addConstraint(from: "V:[$view0]-4-[$self]",
                                     views: [self.titleLabel]);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Hi");
    }
}
