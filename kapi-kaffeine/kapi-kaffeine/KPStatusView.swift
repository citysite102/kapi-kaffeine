//
//  KPStatusView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/14.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPStatusView: UIView {

    
    var icon: UIImageView!
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = KPColorPalette.KPTextColor.grayColor_level4
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var iconSize: CGSize! {
        didSet {
            self.icon.addConstraint(forWidth: iconSize.width)
            self.icon.addConstraint(forHeight: iconSize.height)
        }
    }
    
    //----------------------------
    // MARK: - Initalization
    //----------------------------
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ iconImage: UIImage,
                     _ content: String) {
        self.init(frame: .zero)
        
        icon = UIImageView(image: iconImage)
        addSubview(icon)
        icon.contentMode = .scaleAspectFit
        icon.addConstraint(from: "V:|[$self]")
        icon.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        addSubview(descriptionLabel)
        descriptionLabel.addConstraints(fromStringArray: ["V:[$view0]-20-[$self]",
                                                          "H:|-8-[$self]-8-|"],
                                        views: [icon])
        descriptionLabel.setText(text: content,
                                 lineSpacing: 3.0)
    }
    
    
}
