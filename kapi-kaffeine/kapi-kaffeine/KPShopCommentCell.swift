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
    var voteUpCount: NSNumber! {
        didSet {
            self.voteUpButton.currentCount = voteUpCount.intValue
        }
    }
    
    var voteDownCount: NSNumber! {
        didSet {
            self.voteDownButton.currentCount = voteDownCount.intValue
        }
    }
    
    private var voteUpButton: KPShopCommentCellButton!
    private var voteDownButton: KPShopCommentCellButton!
    
    
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
        
        userPicture = UIImageView(image: R.image.demo_profile())
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
        contentView.addSubview(userNameLabel)
        userNameLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self(190)]",
                                                       "V:|-16-[$self]"],
                                          metrics: [UIScreen.main.bounds.size.width/2],
                                          views: [userPicture])
        
        timeHintLabel = UILabel()
        timeHintLabel.font = UIFont.systemFont(ofSize: 12.0)
        timeHintLabel.textColor = KPColorPalette.KPTextColor.grayColor_level4
        contentView.addSubview(timeHintLabel)
        timeHintLabel.addConstraints(fromStringArray: ["H:[$self]-16-|",
                                                       "V:|-16-[$self]"],
                                          metrics: [UIScreen.main.bounds.size.width/2],
                                          views: [userPicture])

        userCommentLabel = UILabel()
        userCommentLabel.font = UIFont.systemFont(ofSize: 14.0)
        userCommentLabel.numberOfLines = 0
        userCommentLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3
        contentView.addSubview(userCommentLabel)
        userCommentLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]-16-|",
                                                          "V:[$view1]-4-[$self]"],
                                          metrics: [UIScreen.main.bounds.size.width/2],
                                          views: [userPicture, userNameLabel])
        
        voteUpButton = KPShopCommentCellButton.init(frame: .zero,
                                                    icon: R.image.icon_upvote()!,
                                                    count: 0)
        voteUpButton.iconButton.addTarget(self,
                                          action: #selector(KPShopCommentCell.handleVoteUpButtonOnTapped),
                                          for: .touchUpInside);
        
        contentView.addSubview(voteUpButton)
        voteUpButton.addConstraints(fromStringArray: ["H:[$view0]-4-[$self]",
                                                      "V:[$view1]-12-[$self]-8-|"],
                                         metrics: [UIScreen.main.bounds.size.width/2],
                                         views: [userPicture, userCommentLabel])
        
        
        voteDownButton = KPShopCommentCellButton(frame: .zero,
                                                 icon: R.image.icon_downvote()!,
                                                 count: 0)
        voteDownButton.iconButton.addTarget(self,
                                            action: #selector(KPShopCommentCell.handleVoteDownButtonOnTapped),
                                            for: .touchUpInside);
        contentView.addSubview(voteDownButton)
        voteDownButton.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
                                                        "V:[$view1]-12-[$self]-8-|"],
                                           metrics: [UIScreen.main.bounds.size.width/2],
                                           views: [voteUpButton, userCommentLabel])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleVoteUpButtonOnTapped() {
        if voteDownButton.buttonSelected && !voteUpButton.buttonSelected {
            voteDownButton.buttonSelected = false
            voteDownButton.iconButton.isSelected = false
            voteUpButton.buttonSelected = true
        } else {
            voteUpButton.buttonSelected = !voteUpButton.buttonSelected
        }
    }
    
    func handleVoteDownButtonOnTapped() {
        if voteUpButton.buttonSelected && !voteDownButton.buttonSelected {
            voteUpButton.buttonSelected = false
            voteUpButton.iconButton.isSelected = false
            voteDownButton.buttonSelected = true
        } else {
            voteDownButton.buttonSelected = !voteDownButton.buttonSelected
        }
    }
}

class KPShopCommentCellButton: UIView {
    
    var iconButton: KPBounceButton!
    var countLabel: UILabel!
    var currentCount: Int! {
        didSet {
            let transition: CATransition = CATransition()
            transition.type = kCATransitionPush
            transition.duration = 0.2
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.subtype = currentCount > oldValue ? kCATransitionFromTop : kCATransitionFromBottom
            
            countLabel.layer.add(transition, forKey: kCATransition)
            countLabel.text = "\(currentCount ?? 0)"
        }
    }
    var buttonSelected: Bool = false {
        didSet {
            
            if buttonSelected != oldValue {
                currentCount = currentCount + (buttonSelected ? 1 : -1)
            }
            
            iconButton.tintColor = buttonSelected ? KPColorPalette.KPMainColor.mainColor :
                KPColorPalette.KPMainColor.grayColor_level3
            countLabel.textColor = buttonSelected ? KPColorPalette.KPMainColor.mainColor :
                    KPColorPalette.KPMainColor.grayColor_level3
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
    }
    
    public convenience init?(frame: CGRect,
                             icon: UIImage,
                             count: Int) {
        self.init(frame:frame)
        
        buttonSelected = false
        currentCount = count
        
        iconButton = KPBounceButton()
        iconButton.setImage(icon, for: .normal)
        iconButton.tintColor = KPColorPalette.KPMainColor.grayColor_level3
        iconButton.isSelected = false
        addSubview(iconButton)
        iconButton.addConstraints(fromStringArray: ["V:|-4@999-[$self(18@999)]-4@999-|",
                                                    "H:|-4-[$self(18)]"])
        iconButton.rippleInfo = BounceRippleInfo(rippleColor: KPColorPalette.KPBackgroundColor.mainColor_ripple,
                                                 rippleSize: CGSize(width: 32, height: 32),
                                                 rippleRadius:16,
                                                 backgroundColor: UIColor.white,
                                                 backgroundSize: CGSize(width: 16, height: 16),
                                                 backgroundRadius: 8)
        iconButton.adjustHitOffset = CGSize(width: 60, height: 16)
        
        
        countLabel = UILabel()
        countLabel.text = "\(count)"
        countLabel.font = UIFont.systemFont(ofSize: 14)
        countLabel.textColor = KPColorPalette.KPMainColor.grayColor_level3
        
        addSubview(countLabel)
        countLabel.addConstraints(fromStringArray: ["H:[$view0]-4-[$self]-4-|"],
                                  views: [iconButton])
        countLabel.addConstraintForCenterAligning(to: iconButton,
                                                  in: .vertical)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
