//
//  KPInformationHeaderButton.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/16.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

struct HeaderButtonInfo {
    let title: String!
    let info: String!
    let defaultInfo: String!
    let icon: UIImage!
    let handler: (_ headerButton: KPInformationHeaderButton) -> ()
}

class KPInformationHeaderButton: UIView {

    var dampingRatio: CGFloat = 0.6
    var bounceDuration: Double = 0.5
    var icon: UIImageView!
    var titleLabel: UILabel!
    var infoLabel: UILabel!
    
    var numberValue: Int = 0 {
        didSet {
            if self.numberValue == 0 {
                self.infoLabel.text = self.buttonInfo.defaultInfo
            } else if self.numberValue == oldValue {
                self.infoLabel.text = self.infoLabel.text
            } else {
                let transition: CATransition = CATransition()
                transition.type = kCATransitionPush
                transition.duration = 0.2
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.subtype = self.numberValue > oldValue ? kCATransitionFromTop : kCATransitionFromBottom
                
                self.infoLabel.layer.add(transition,
                                         forKey: kCATransition)
                if oldValue == 0 {
                    self.infoLabel.text = (self.infoLabel.text! as
                        NSString).replacingOccurrences(of: self.buttonInfo.defaultInfo,
                                                       with:
                            (self.buttonInfo.info as NSString).replacingOccurrences(of: "%d",
                                                                               with: "\(self.numberValue)"))
                } else {
                    self.infoLabel.text = (self.infoLabel.text! as
                        NSString).replacingOccurrences(of: "\(oldValue)",
                            with: "\(self.numberValue)")
                }
            }
        }
    }
    
    var handler: ((_ headerButton: KPInformationHeaderButton) -> ())!
    var selected: Bool = false {
        didSet {
            icon.tintColor = selected ?
                KPColorPalette.KPMainColor_v2.mainColor :
                KPColorPalette.KPMainColor.grayColor_level5
            titleLabel.textColor = KPColorPalette.KPTextColor.mainColor
//            numberValue = self.numberValue + (selected ? 1 : (self.numberValue > 0 ? -1 : 0))
        }
    }
    
    var buttonInfo: HeaderButtonInfo! {
        didSet {
            icon.image = buttonInfo.icon
            titleLabel.text = buttonInfo.title
            infoLabel.text = buttonInfo.defaultInfo
            handler = buttonInfo.handler
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1.0
        layer.borderColor = KPColorPalette.KPMainColor.borderColor?.cgColor
        backgroundColor = UIColor.white
        
        icon = UIImageView()
        addSubview(icon)
        icon.addConstraintForCenterAligningToSuperview(in: .horizontal)
        icon.addConstraint(from: "V:|-12-[$self(24)]")
        icon.addConstraint(from: "H:[$self(24)]")
        icon.tintColor = selected ?
            KPColorPalette.KPMainColor.mainColor :
            KPColorPalette.KPMainColor.grayColor_level5
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = KPColorPalette.KPTextColor.mainColor
        addSubview(titleLabel)
        titleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        titleLabel.addConstraint(from: "V:[$view0]-4-[$self]",
                                 views: [icon])
        
        infoLabel = UILabel()
        infoLabel.font = UIFont.systemFont(ofSize: 11)
        infoLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3
        addSubview(infoLabel)
        infoLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        infoLabel.addConstraint(from: "V:[$view0]-4-[$self]",
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
        
        if KPUserManager.sharedManager.currentUser == nil {
            KPPopoverView.popoverLoginView()
        } else {
            if KPServiceHandler.sharedHandler.isCurrentShopClosed {
                KPPopoverView.popoverClosedView()
            } else {
                handler(self)
            }
        }
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
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: {
                        self.icon.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.7, 0.7, 1.0)
        }) { _ in
            
        }
    }
    
}
