//
//  KPBounceView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/14.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPBounceView: UIView {

    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    var selected: Bool = false {
        didSet {
            icon.tintColor = selected ? selectedColor : unSelectedColor
        }
    }
    var icon: UIImageView!
    
    var selectedColor = KPColorPalette.KPMainColor.starColor
    var unSelectedColor = KPColorPalette.KPMainColor.grayColor_level3
    
    var dampingRatio: CGFloat = 0.35
    var bounceDuration: Double = 0.8
    
    //----------------------------
    // MARK: - Initalization
    //----------------------------
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ iconImage: UIImage) {
        self.init(frame: .zero)
        
        icon = UIImageView.init(image: iconImage.withRenderingMode(.alwaysTemplate))
        icon.tintColor = unSelectedColor
        addSubview(icon)
        icon.addConstraints(fromStringArray: ["V:|[$self]|",
                                              "H:|[$self]|"])
        
        selected = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event);
        layer.transform = CATransform3DScale(CATransform3DIdentity, 0.8, 0.8, 1.0);
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event);
        self.performTouchEndAnimation();
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.performTouchEndAnimation();
    }
    
    private func performTouchEndAnimation() {
        UIView.animate(withDuration: bounceDuration,
                       delay: 0,
                       usingSpringWithDamping: dampingRatio,
                       initialSpringVelocity: 1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: {
                        self.layer.transform = CATransform3DIdentity;
        }) { _ in
            
        }
    }
    
//    private func performBounceAnimation() {
//        layer.transform = CATransform3DScale(CATransform3DIdentity, 0.9, 0.9, 1.0);
//        UIView.animate(withDuration: bounceDuration,
//                       delay: 0,
//                       usingSpringWithDamping: dampingRatio,
//                       initialSpringVelocity: 1,
//                       options: UIViewAnimationOptions.beginFromCurrentState,
//                       animations: {
//                        self.layer.transform = CATransform3DIdentity;
//        }) { _ in
//            
//        }
//    }

}
