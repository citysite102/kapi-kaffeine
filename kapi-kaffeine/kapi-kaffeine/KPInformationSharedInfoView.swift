//
//  KPInformationSharedInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit


enum ActionStyle: Int {
    case normal = 1
}

struct Action {
    let title: String
    let style: ActionStyle
    let handler: (_ infoView: KPInformationSharedInfoView) -> ()
}

class KPInformationSharedInfoView: UIView {
    
    var infoTitleLabel: UILabel!
    var infoView: UIView!
    var actions: [Action]? {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.infoTitleLabel = UILabel.init();
        self.infoTitleLabel.font = UIFont.systemFont(ofSize: 13);
        self.infoTitleLabel.textColor = KPColorPalette.KPTextColor.mainColor;
        self.infoTitleLabel.text = "店家資訊";
        self.addSubview(self.infoTitleLabel);
        self.infoTitleLabel.addConstraints(fromStringArray: ["V:|-8-[$self]", "H:|-8-[$self]"]);
        
        self.infoView = UIView.init();
        self.infoView.backgroundColor = UIColor.white;
        self.addSubview(self.infoView);
        self.infoView.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]|", "H:|[$self]|"],
                                     views: [self.infoTitleLabel]);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


