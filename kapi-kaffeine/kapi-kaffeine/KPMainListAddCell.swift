//
//  KPMainListAddCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2018/2/2.
//  Copyright © 2018年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPMainListAddCell: UITableViewCell {

    var addImageView: UIImageView!
    var addDescriptionLabel: KPLayerLabel!
    var addActionLabel: KPLayerLabel!
    var separator: UIView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addImageView = UIImageView(image: R.image.icon_store_add()!)
        addImageView.contentMode = .scaleAspectFill
        addImageView.clipsToBounds = true
        addImageView.tintColor
         = KPColorPalette.KPTextColor_v2.mainColor_hint_light
        contentView.addSubview(addImageView)
        
        addImageView.addConstraints(fromStringArray: ["H:|-30-[$self(48)]",
                                                      "V:|-16-[$self(48)]-16-|"])
        
        addDescriptionLabel = KPLayerLabel()
        addDescriptionLabel.font = UIFont.systemFont(ofSize: 11)
        addDescriptionLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        addDescriptionLabel.text = "找不到喜歡的咖啡店嗎？"
        addDescriptionLabel.isOpaque = true
        addDescriptionLabel.layer.masksToBounds = true
        contentView.addSubview(addDescriptionLabel)
        
        addDescriptionLabel.addConstraints(fromStringArray: ["H:[$view0]-22-[$self]|",
                                                             "V:|-19-[$self]"],
                                     views: [addImageView])
        
        addActionLabel = KPLayerLabel()
        addActionLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        addActionLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        addActionLabel.text = "新增咖啡店"
        addActionLabel.isOpaque = true
        addActionLabel.layer.masksToBounds = true
        contentView.addSubview(addActionLabel)
        
        addActionLabel.addConstraints(fromStringArray: ["H:[$view0]-22-[$self]|",
                                                        "V:[$self]-22-|"],
                                           views: [addImageView])
        
        
        separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        contentView.addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:[$self(1)]|",
                                                   "H:|-8-[$self]-8-|"])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
