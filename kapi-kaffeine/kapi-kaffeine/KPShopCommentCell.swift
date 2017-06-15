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
        
        userPicture = UIImageView(image: R.image.demo_1())
        userPicture.contentMode = .scaleAspectFit
        userPicture.layer.cornerRadius = 10.0
        userPicture.layer.borderWidth = 1.0
        userPicture.layer.borderColor = KPColorPalette.KPMainColor.grayColor_level5?.cgColor
        userPicture.layer.masksToBounds = true
        contentView.addSubview(userPicture)
        userPicture.addConstraints(fromStringArray: ["H:|-16-[$self(32)]",
                                                     "V:|-16-[$self(32)]"])
        

        userNameLabel = UILabel()
        userNameLabel.font = UIFont.systemFont(ofSize: 14.0)
        userNameLabel.textColor = KPColorPalette.KPTextColor.grayColor_level1
        userNameLabel.text = "Simon Lin"
        contentView.addSubview(userNameLabel)
        userNameLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self(190)]",
                                                       "V:|-16-[$self]"],
                                          metrics: [UIScreen.main.bounds.size.width/2],
                                          views: [userPicture])
        
        timeHintLabel = UILabel()
        timeHintLabel.font = UIFont.systemFont(ofSize: 12.0)
        timeHintLabel.textColor = KPColorPalette.KPTextColor.grayColor_level4
        timeHintLabel.text = "25 分鐘前"
        contentView.addSubview(timeHintLabel)
        timeHintLabel.addConstraints(fromStringArray: ["H:[$self]-16-|",
                                                       "V:|-16-[$self]"],
                                          metrics: [UIScreen.main.bounds.size.width/2],
                                          views: [userPicture])

        userCommentLabel = UILabel()
        userCommentLabel.font = UIFont.systemFont(ofSize: 14.0)
        userCommentLabel.numberOfLines = 0
        userCommentLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3
        userCommentLabel.setText(text: "時間, 天氣, 溫度(°C), 體感溫度(°C), 降雨機率, 蒲福風級, 風向, 相對濕度 .... 今天（16日）受鋒面影響，天氣不穩定，隨著雲系一波波移入",
                                 lineSpacing: 2.4)
        contentView.addSubview(userCommentLabel)
        userCommentLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]-16-|",
                                                          "V:[$view1]-4-[$self]"],
                                          metrics: [UIScreen.main.bounds.size.width/2],
                                          views: [userPicture, userNameLabel])
        
        voteUpButton = KPShopCommentCellButton.init(frame: .zero,
                                                    icon: R.image.icon_upvote()!,
                                                    title: "9")
        voteUpButton.buttonSelected = true
        contentView.addSubview(voteUpButton)
        voteUpButton.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
                                                      "V:[$view1]-12-[$self(20)]-20-|"],
                                         metrics: [UIScreen.main.bounds.size.width/2],
                                         views: [userPicture, userCommentLabel])
        
        
        voteDownButton = KPShopCommentCellButton.init(frame: .zero,
                                                      icon: R.image.icon_downvote()!,
                                                      title: "0")
        contentView.addSubview(voteDownButton)
        voteDownButton.addConstraints(fromStringArray: ["H:[$view0]-16-[$self]",
                                                        "V:[$view1]-12-[$self(20)]-20-|"],
                                           metrics: [UIScreen.main.bounds.size.width/2],
                                           views: [voteUpButton, userCommentLabel])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class KPShopCommentCellButton: UIButton {

    var buttonSelected: Bool = false {
        didSet {
            tintColor = buttonSelected ? KPColorPalette.KPMainColor.mainColor :
                KPColorPalette.KPMainColor.grayColor_level2
            titleLabel?.textColor = KPColorPalette.KPTextColor.grayColor_level1
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
    }
    
    public convenience init?(frame: CGRect,
                             icon: UIImage,
                             title: String) {
        self.init(frame:frame)
        
        setImage(icon, for: .normal)
        setTitle(title, for: .normal)
        setTitleColor(KPColorPalette.KPTextColor.grayColor_level1, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tintColor = KPColorPalette.KPMainColor.grayColor_level2
        imageView?.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
