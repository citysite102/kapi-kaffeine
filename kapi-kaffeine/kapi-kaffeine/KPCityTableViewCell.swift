//
//  KPCityTableViewCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/21.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPCityTableViewCell: UITableViewCell {

    var cityLabel: UILabel!
    var selectedBox: KPCheckBox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cityLabel = UILabel();
        cityLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent);
        cityLabel.textColor = KPColorPalette.KPTextColor.grayColor;
        cityLabel.layer.masksToBounds = true
        addSubview(self.cityLabel);
        cityLabel.addConstraints(fromStringArray: ["H:|-80-[$self]",
                                                   "V:|-16-[$self(16)]-16-|"]);
        
        selectedBox = KPCheckBox()
        selectedBox.setMarkType(markType: .checkmark,
                                animated: true)
        selectedBox.boxLineWidth = 2.0
        selectedBox.stateChangeAnimation = .bounce(.fill)
        selectedBox.setCheckState(.checked, animated: false)
        selectedBox.isHidden = true
        addSubview(selectedBox)
        selectedBox.addConstraint(from: "H:[$self(16)]-16-|")
        selectedBox.addConstraint(from: "V:[$self(16)]")
        selectedBox.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        selectedBackgroundView = UIImageView(image: UIImage(color: KPColorPalette.KPBackgroundColor.mainColor_light_10!))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectedBox.isHidden = !selected
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        backgroundColor = highlighted ?
            KPColorPalette.KPBackgroundColor.mainColor_light_10 :
            UIColor.white
    }

}
