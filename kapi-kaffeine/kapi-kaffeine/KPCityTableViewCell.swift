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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cityLabel = UILabel();
        cityLabel.font = UIFont.systemFont(ofSize: 12);
        cityLabel.textColor = KPColorPalette.KPTextColor.grayColor;
        cityLabel.isOpaque = true
        cityLabel.backgroundColor = UIColor.white
        cityLabel.layer.masksToBounds = true
        addSubview(self.cityLabel);
        cityLabel.addConstraints(fromStringArray: ["H:|-72-[$self]",
                                                   "V:|-12-[$self(16)]-12-|"]);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
