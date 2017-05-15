//
//  KPSearchViewDefaultCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchViewDefaultCell: UITableViewCell {

    lazy var demoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.text = "店家各項評分"
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(demoLabel)
        demoLabel.addConstraints(fromStringArray: ["H:|-8-[$self]"])
        demoLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
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

        // Configure the view for the selected state
    }

}
