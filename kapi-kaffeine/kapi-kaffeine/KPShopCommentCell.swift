//
//  KPShopCommentCell.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/18.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopCommentCell: UITableViewCell {

    
    var userPicture: UIImageView!
    var userNameLabel: UILabel!
    var timeHintLabel: UILabel!
    var userCommentLabel: UILabel!
    var voteUpButton: KPShopCommentCellButton!
    var voteDownButton: KPShopCommentCellButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.userPicture = UIImageView(image: UIImage(named: "image_shop_demo"));
        self.userPicture.contentMode = .scaleAspectFit;
        self.userPicture.layer.cornerRadius = 10.0;
        self.userPicture.layer.masksToBounds = true;
        self.contentView.addSubview(self.userPicture);
        self.userPicture.addConstraints(fromStringArray: ["H:|-16-[$self(32)]",
                                                            "V:|-16-[$self(32)]"]);
        

        self.userNameLabel = UILabel();
        self.userNameLabel.font = UIFont.systemFont(ofSize: 12.0);
        self.userNameLabel.textColor = KPColorPalette.KPTextColor.grayColor_level1;
        self.userNameLabel.text = "Simon Lin";
        self.contentView.addSubview(self.userNameLabel);
        self.userNameLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self(190)]",
                                                            "V:|-16-[$self]"],
                                          metrics: [UIScreen.main.bounds.size.width/2],
                                          views: [self.userPicture]);
        
        self.timeHintLabel = UILabel();
        self.timeHintLabel.font = UIFont.systemFont(ofSize: 10.0);
        self.timeHintLabel.textColor = KPColorPalette.KPTextColor.grayColor_level2;
        self.timeHintLabel.text = "25 分鐘前";
        self.contentView.addSubview(self.timeHintLabel);
        self.timeHintLabel.addConstraints(fromStringArray: ["H:[$self]-16-|",
                                                            "V:|-16-[$self]"],
                                          metrics: [UIScreen.main.bounds.size.width/2],
                                          views: [self.userPicture]);

        self.userCommentLabel = UILabel();
        self.userCommentLabel.font = UIFont.systemFont(ofSize: 14.0);
        self.userCommentLabel.numberOfLines = 0;
        self.userCommentLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3;
        self.userCommentLabel.text = "It runs well. But the problem is that code (in didSet) is not run for the very first time. I mean when a new FavoriteView instance is initialized.";
        self.contentView.addSubview(self.userCommentLabel);
        self.userCommentLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]-16-|",
                                                               "V:[$view1]-4-[$self]"],
                                          metrics: [UIScreen.main.bounds.size.width/2],
                                          views: [self.userPicture, self.userNameLabel]);
        
        self.voteUpButton = KPShopCommentCellButton.init(frame: .zero,
                                                         icon: UIImage.init(named: "icon_map")!,
                                                         title: "9");
        self.voteUpButton.buttonSelected = true;
        self.contentView.addSubview(self.voteUpButton);
        self.voteUpButton.addConstraints(fromStringArray: ["H:[$view0]-8-[$self(40)]",
                                                           "V:[$view1]-12-[$self(16)]-20-|"],
                                         metrics: [UIScreen.main.bounds.size.width/2],
                                         views: [self.userPicture, self.userCommentLabel]);
        
        
        self.voteDownButton = KPShopCommentCellButton.init(frame: .zero,
                                                           icon: UIImage.init(named: "icon_map")!,
                                                           title: "0");
        self.contentView.addSubview(self.voteDownButton);
        self.voteDownButton.addConstraints(fromStringArray: ["H:[$view0]-24-[$self(40)]",
                                                             "V:[$view1]-12-[$self(16)]-20-|"],
                                           metrics: [UIScreen.main.bounds.size.width/2],
                                           views: [self.voteUpButton, self.userCommentLabel]);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class KPShopCommentCellButton: UIButton {

    var buttonSelected: Bool = false {
        didSet {
            self.tintColor = buttonSelected ? KPColorPalette.KPMainColor.mainColor :
                KPColorPalette.KPMainColor.grayColor_level2;
            self.titleLabel?.textColor = KPColorPalette.KPTextColor.grayColor_level1;
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
    }
    
    public convenience init?(frame: CGRect,
                             icon: UIImage,
                             title: String) {
        self.init(frame:frame);
        
        self.setImage(icon, for: .normal);
        self.setTitle(title, for: .normal);
        self.setTitleColor(KPColorPalette.KPTextColor.grayColor_level1, for: .normal);
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14);
        self.tintColor = KPColorPalette.KPMainColor.grayColor_level2;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
