//
//  KPExpNotificationView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/11.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPExpNotificationView: UIView {

    var icon: UIImageView!
    var container: UIView!
    var reasonLabel: UILabel!
    var experienceLabel: UILabel!
    
    struct Constants {
        static let viewHeight: CGFloat = UIDevice().isSuperCompact ? 24 : 36
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level3?.cgColor
        layer.cornerRadius = KPLayoutConstant.corner_radius
        layer.masksToBounds = true
        
        container = UIView()
        addSubview(container)
        container.addConstraints(fromStringArray: ["V:|[$self]|",
                                                   "H:|[$self]|"])
        container.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
        icon = UIImageView(image: R.image.icon_expup())
        icon.contentMode = .scaleAspectFit
        icon.tintColor = UIColor.white
        container.addSubview(icon)
        let _ = icon.addConstraintForCenterAligningToSuperview(in: .vertical)
        let _ = icon.addConstraints(fromStringArray: ["H:|-12-[$self(24)]",
                                                      "V:[$self(24)]"])
        icon.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        reasonLabel = UILabel();
        reasonLabel.font = UIFont.systemFont(ofSize: UIDevice().isSuperCompact ? 15.0 : 18.0);
        reasonLabel.textColor = KPColorPalette.KPTextColor.whiteColor;
        reasonLabel.isOpaque = true
        reasonLabel.layer.masksToBounds = true
        container.addSubview(reasonLabel)
        reasonLabel.addConstraints(fromStringArray: ["V:|-12-[$self]-12-|",
                                                     "H:[$view0]-8-[$self]"],
                                   views:[icon])
        
        experienceLabel = UILabel();
        experienceLabel.font = UIFont.boldSystemFont(ofSize: UIDevice().isSuperCompact ? 15.0 : 18.0);
        experienceLabel.textColor = KPColorPalette.KPTextColor.whiteColor;
        experienceLabel.text = "經驗值+1"
        experienceLabel.isOpaque = true
        experienceLabel.layer.masksToBounds = true
        container.addSubview(experienceLabel);
        experienceLabel.addConstraints(fromStringArray: ["V:|-12-[$self]-12-|",
                                                         "H:[$view0]-16-[$self]-12-|"],
                                        views: [reasonLabel])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showExpNotification(_ reason: String!,
                             _ experience: NSNumber!) {

        
        reasonLabel.text = reason
        experienceLabel.text = "經驗值+\(experience.intValue)"
        UIApplication.shared.topView?.addSubview(self)
        
        removeAllRelatedConstraintsInSuperView()
        addConstraints(fromStringArray: ["V:[$self]-($metric0)-|"],
                       metrics:[-(Constants.viewHeight+24)])
        addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseOut,
                       animations: {
                        self.transform = CGAffineTransform(translationX: 0, y: -70)
        }) { (_) in
            
            
            UIView.animate(withDuration: 0.1,
                           delay: 2.4,
                           options: UIViewAnimationOptions.curveLinear,
                           animations: { 
                            self.transform = CGAffineTransform(translationX: 0, y: -86)
            }, completion: { (_) in
                
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.5,
                               options: .curveEaseIn,
                               animations: {
                                self.transform = .identity
                }) { (_) in
                }
            })
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
//            
//            self.layer.cornerRadius = 5
//            let cornerRadiusAnimation = CABasicAnimation(keyPath: "cornerRadius")
//            cornerRadiusAnimation.duration = 0.4
//            self.layer.add(cornerRadiusAnimation, forKey: nil)
//            
//            
//            UIView.animate(withDuration: 0.5,
//                           delay: 0,
//                           usingSpringWithDamping: 0.6,
//                           initialSpringVelocity: 0.8,
//                           options: UIViewAnimationOptions.curveLinear,
//                           animations: { 
//                            self.frame = CGRect(x: self.frameOrigin.x + self.frameSize.width/2 - 5,
//                                                y: self.frameOrigin.y + self.frameSize.height/2 - 5,
//                                                width: 10, height: 10)
//                            self.layer.backgroundColor = KPColorPalette.KPMainColor_v2.mainColor?.cgColor
//            }, completion: { (_) in
//                
//                let movePath = UIBezierPath()
//                movePath.move(to: CGPoint(x: self.frameOrigin.x + self.frameSize.width/2 - 5,
//                                          y: self.frameOrigin.y + self.frameSize.height/2 - 5))
//                movePath.addCurve(to: CGPoint(x: 167.5, y: 544.5), controlPoint1: CGPoint(x: 166.5, y: 520.5),
//                                  controlPoint2: CGPoint(x: 167.5, y: 544.5))
//                movePath.addCurve(to: CGPoint(x: 66.5, y: 12.5), controlPoint1: CGPoint(x: 167.5, y: 544.5),
//                                  controlPoint2: CGPoint(x: 137.5, y: 12.5))
//                
//                let pathAnimation = CAKeyframeAnimation(keyPath: "position")
//                pathAnimation.path = movePath.cgPath
//                pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//                pathAnimation.delegate = self
////                pathAnimation.timingFunctions = [CAMediaTimingFunction(controlPoints: 0.29, 0.86, 0.57, 1),
////                                                 CAMediaTimingFunction(controlPoints: 0.79, 0.12, 0.87, 0.6)]
//                pathAnimation.rotationMode = kCAAnimationRotateAuto
//                pathAnimation.duration = 1.5
//                pathAnimation.isRemovedOnCompletion = false
//                pathAnimation.fillMode = kCAFillModeBoth
//                self.layer.add(pathAnimation, forKey: "path1")
//                
//
//                
//            })
//        }
        
    }
}

//extension KPExpNotificationView: CAAnimationDelegate {
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        
//        
//        if anim == self.layer.animation(forKey: "path1") {
//            let movePath = UIBezierPath()
//            movePath.move(to: CGPoint(x: 66.5, y: 12.5))
//            movePath.addCurve(to: CGPoint(x: 37.5, y: 49.5), controlPoint1: CGPoint(x: 66.5, y: 12.5), controlPoint2: CGPoint(x: 45.5, y: 10.5))
//            let pathAnimation = CAKeyframeAnimation(keyPath: "position")
//            pathAnimation.path = movePath.cgPath
//            pathAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.79, 0.12, 0.87, 0.6)
//            pathAnimation.delegate = self
//            //                pathAnimation.timingFunctions = [CAMediaTimingFunction(controlPoints: 0.29, 0.86, 0.57, 1),
//            //                                                 CAMediaTimingFunction(controlPoints: 0.79, 0.12, 0.87, 0.6)]
//            pathAnimation.rotationMode = kCAAnimationRotateAuto
//            pathAnimation.duration = 0.5
//            pathAnimation.isRemovedOnCompletion = false
//            pathAnimation.fillMode = kCAFillModeBoth
//            self.layer.add(pathAnimation, forKey: nil)
//        }
//    }
//}
