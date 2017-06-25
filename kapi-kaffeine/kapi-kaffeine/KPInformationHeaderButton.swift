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
            self.titleLabel.textColor = selected ?
                KPColorPalette.KPTextColor.mainColor :
                KPColorPalette.KPMainColor.grayColor_level3
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
        
        layer.borderWidth = 1.0
        layer.borderColor = KPColorPalette.KPMainColor.borderColor?.cgColor
        backgroundColor = UIColor.white
        
        icon = UIImageView.init()
        addSubview(icon)
        icon.addConstraintForCenterAligningToSuperview(in: .horizontal)
        icon.addConstraint(from: "V:|-12-[$self(24)]")
        icon.addConstraint(from: "H:[$self(24)]")
        icon.tintColor = selected ?
            KPColorPalette.KPMainColor.mainColor :
            KPColorPalette.KPMainColor.grayColor_level5
        
        titleLabel = UILabel.init()
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = KPColorPalette.KPTextColor.mainColor
        addSubview(titleLabel)
        titleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        titleLabel.addConstraint(from: "V:[$view0]-4-[$self]",
                                 views: [icon])
        
        infoLable = UILabel.init()
        infoLable.font = UIFont.systemFont(ofSize: 11)
        infoLable.textColor = KPColorPalette.KPMainColor.grayColor_level3
        addSubview(infoLable)
        infoLable.addConstraintForCenterAligningToSuperview(in: .horizontal)
        infoLable.addConstraint(from: "V:[$view0]-4-[$self]",
                                views: [titleLabel])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        performTouchBeganAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        performTouchEndAnimation()
        handler(self)
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
