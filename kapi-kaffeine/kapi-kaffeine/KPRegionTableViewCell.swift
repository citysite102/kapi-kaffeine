//
//  KPRegionTableViewCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/21.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPRegionTableViewCell: UITableViewCell {

    var regionIcon: UIImageView!
    var regionLabel: UILabel!
    var expandIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.regionIcon = UIImageView.init(image: UIImage.init(named: "icon_taipei"));
        self.addSubview(self.regionIcon);
        self.regionIcon.addConstraints(fromStringArray: ["V:|-12-[$self(24)]-12-|",
                                                         "H:|-16-[$self(24)]"]);
        
        self.regionLabel = UILabel();
        self.regionLabel.font = UIFont.systemFont(ofSize: 14);
        self.regionLabel.textColor = KPColorPalette.KPTextColor.grayColor;
        self.addSubview(self.regionLabel);
        self.regionLabel.addConstraints(fromStringArray: ["H:[$view0]-32-[$self]"],
                                        views: [self.regionIcon]);
        self.regionLabel.addConstraintForCenterAligningToSuperview(in: .vertical);
        
        self.expandIcon = UIImageView.init(image: UIImage.init(named: "icon_map"));
        self.addSubview(self.expandIcon);
        self.expandIcon.addConstraints(fromStringArray: ["V:|-12-[$self(24)]-12-|",
                                                         "H:[$self(24)]-16-|"]);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
