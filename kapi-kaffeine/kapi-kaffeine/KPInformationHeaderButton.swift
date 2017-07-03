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
    let icon: UIImage
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
            
            if numberValue == 0 {
                self.infoLabel.text = self.buttonInfo.defaultInfo
            } else {
                let transition: CATransition = CATransition()
                transition.type = kCATransitionPush
                transition.duration = 0.2
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.subtype = numberValue > oldValue ? kCATransitionFromTop : kCATransitionFromBottom
                
                self.infoLabel.layer.add(transition,
                                         forKey: kCATransition)
                if oldValue == 0 {
                    self.infoLabel.text = (self.infoLabel.text! as
                        NSString).replacingOccurrences(of: self.buttonInfo.defaultInfo,
                                                       with:
                            (buttonInfo.info as NSString).replacingOccurrences(of: "%d",
                                                                               with: "\(numberValue)"))
                } else {
                    self.infoLabel.text = (self.infoLabel.text! as
                        NSString).replacingOccurrences(of: "\(oldValue)",
                            with: "\(numberValue)")
                }
            }
        }
    }
    
    var handler: ((_ headerButton: KPInformationHeaderButton) -> ())!
    var selected: Bool = false {
        didSet {
            self.icon.tintColor = selected ?
                KPColorPalette.KPMainColor.mainColor :
                KPColorPalette.KPMainColor.grayColor_level5
            self.titleLabel.textColor = selected ?
                KPColorPalette.KPTextColor.mainColor :
                KPColorPalette.KPMainColor.grayColor_level3
            self.numberValue = self.numberValue+1
        }
    }
    
    var buttonInfo: HeaderButtonInfo! {
        didSet {
            self.icon.image = buttonInfo?.icon
            self.titleLabel.text = buttonInfo.title
            self.infoLabel.text = buttonInfo.defaultInfo
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
        
        infoLabel = UILabel.init()
        infoLabel.font = UIFont.systemFont(ofSize: 11)
        infoLabel.textColor = KPColorPalette.KPMainColor.grayColor_level3
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
