//
//  KPSharedIntroView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/24.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSharedIntroView: UIView {
    
    lazy var introTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: KPFontSize.header)
        label.textAlignment = .center
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        return label
    }()
    
    lazy var introDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.alpha = 0.8
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.isUserInteractionEnabled = false

        addSubview(introTitleLabel)
        addSubview(introDescriptionLabel)
        
        introTitleLabel.addConstraints(fromStringArray: ["V:[$self]-180-|",
                                                         "H:|-32-[$self]-32-|"])
        
        introDescriptionLabel.addConstraints(fromStringArray: ["V:[$view0]-16-[$self]",
                                                               "H:|-32-[$self]-32-|"],
                                             views:[introTitleLabel])
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
