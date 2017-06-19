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
            if selected && oldValue != selected {
                performBounceAnimation()
            }
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
        icon.contentMode = .scaleAspectFit
        icon.addConstraintForCenterAligningToSuperview(in: .vertical)
        icon.addConstraintForCenterAligningToSuperview(in: .horizontal)
        icon.addConstraints(fromStringArray: ["V:|[$self]|",
                                              "H:|[$self]|"])
        
        selected = false
        
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
    
    private func performBounceAnimation() {
        layer.transform = CATransform3DScale(CATransform3DIdentity, 0.8, 0.8, 1.0);
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

}
