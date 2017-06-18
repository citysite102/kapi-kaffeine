//
//  KPInformationHeaderButton.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/16.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

struct HeaderButtonInfo {
    let title: String
    let info: String
    let icon: UIImage
    let handler: (_ headerButton: KPInformationHeaderButton) -> ()
}

class KPInformationHeaderButton: UIView {

    var dampingRatio: CGFloat = 0.6
    var bounceDuration: Double = 0.5
    var icon: UIImageView!
    var titleLabel: UILabel!
    var infoLable: UILabel!
    var handler: ((_ headerButton: KPInformationHeaderButton) -> ())!
    var selected: Bool = false {
        didSet {
            self.icon.tintColor = selected ?
                KPColorPalette.KPMainColor.mainColor :
                KPColorPalette.KPMainColor.grayColor_level5
        }
    }
    
    var buttonInfo: HeaderButtonInfo? {
        didSet {
            self.icon.image = buttonInfo?.icon
            self.titleLabel.text = buttonInfo?.title
            self.infoLable.text = buttonInfo?.info
            self.handler = buttonInfo?.handler
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = KPColorPalette.KPMainColor.borderColor?.cgColor
        self.backgroundColor = UIColor.white
        
        self.icon = UIImageView.init()
        self.addSubview(self.icon)
        self.icon.addConstraintForCenterAligningToSuperview(in: .horizontal)
        self.icon.addConstraint(from: "V:|-12-[$self(24)]")
        self.icon.addConstraint(from: "H:[$self(24)]")
        self.icon.tintColor = selected ?
            KPColorPalette.KPMainColor.mainColor :
            KPColorPalette.KPMainColor.grayColor_level5
        
        self.titleLabel = UILabel.init()
        self.titleLabel.font = UIFont.systemFont(ofSize: 13)
        self.titleLabel.textColor = KPColorPalette.KPTextColor.mainColor
        self.addSubview(self.titleLabel)
        self.titleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        self.titleLabel.addConstraint(from: "V:[$view0]-4-[$self]",
                                      views: [self.icon])
        
        self.infoLable = UILabel.init()
        self.infoLable.font = UIFont.systemFont(ofSize: 11)
        self.infoLable.textColor = KPColorPalette.KPMainColor.grayColor_level3
        self.addSubview(self.infoLable)
        self.infoLable.addConstraintForCenterAligningToSuperview(in: .horizontal)
        self.infoLable.addConstraint(from: "V:[$view0]-4-[$self]",
                                     views: [self.titleLabel])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.performTouchBeganAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.performTouchEndAnimation()
        self.handler(self)
    }
    
    private func performTouchEndAnimation() {
        UIView.animate(withDuration: bounceDuration,
                       delay: 0,
                       usingSpringWithDamping: dampingRatio,
                       initialSpringVelocity: 1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: {
                        self.icon.layer.transform = CATransform3DIdentity
        }) { _ in
            
        }
    }
    
    private func performTouchBeganAnimation() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: {
                        self.icon.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.8, 0.8, 1.0)
        }) { _ in
            
        }
    }
    
}
