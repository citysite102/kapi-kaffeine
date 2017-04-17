//
//  KPShopInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopInfoView: UIView {

    var titleLabel: UILabel!;
    var featureContainer: UIView!;
    var featureContents: [String]!;
    var openTimeIcon: UIImageView!;
    var openHint: UIView!;
    var openLabel: UILabel!;
    var otherTimeButton: UIButton!;
    var phoneIcon: UIImageView!;
    var phoneLabel: UILabel!;
    var locationIcon: UIImageView!;
    var locationLabel: UILabel!;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
