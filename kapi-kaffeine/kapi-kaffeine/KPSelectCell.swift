//
//  KPSelectCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/21.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSelectCell: UITableViewCell {

    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = KPColorPalette.KPTextColor.grayColor_level2
        return label
    }()
    
    var selectedBox: KPCheckBox!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(contentLabel)
        contentLabel.addConstraints(fromStringArray: ["H:|-16-[$self]"])
        contentLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        selectedBox = KPCheckBox()
        selectedBox.setMarkType(markType: .checkmark,
                                animated: true)
        selectedBox.boxLineWidth = 2.0
        selectedBox.stateChangeAnimation = .bounce(.fill)
        selectedBox.setCheckState(.checked, animated: false)
        selectedBox.isHidden = true
        addSubview(selectedBox)
        selectedBox.addConstraint(from: "H:[$self(20)]-16-|")
        selectedBox.addConstraint(from: "V:[$self(20)]")
        selectedBox.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        selectedBackgroundView = UIImageView(image: UIImage(color: KPColorPalette.KPBackgroundColor.mainColor_light_10!))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectedBox.isHidden = !selected
    }

}
