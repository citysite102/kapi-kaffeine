//
//  KPBounceButton.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/22.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import pop


struct BounceRippleInfo {
    let rippleColor: UIColor!
    let rippleSize: CGSize!
    let rippleRadius: CGFloat!
    let backgroundColor: UIColor!
    let backgroundSize: CGSize!
    let backgroundRadius: CGFloat!
}

class KPBounceButton: UIButton {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    var dampingRatio: CGFloat = 0.35
    var bounceDuration: Double = 0.8
    var selectedTintColor: UIColor? {
        didSet {
            self.normalTintColor = self.tintColor
        }
    }
    var normalTintColor: UIColor?
    var adjustHitOffset: CGSize = CGSize(width: 0, height: 0)
    var rippleView: UIView?
    
    var rippleInfo: BounceRippleInfo? {
        didSet {
            rippleView = UIView()
            rippleView?.backgroundColor = rippleInfo?.rippleColor
            rippleView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            rippleView?.layer.cornerRadius = (rippleInfo?.rippleRadius!)!
            insertSubview(rippleView!, belowSubview: self.imageView!)
            let _ = rippleView?.addConstraintForCenterAligningToSuperview(in: .vertical)
            let _ = rippleView?.addConstraintForCenterAligningToSuperview(in: .horizontal)
            let _ = rippleView?.addConstraint(forWidth: (rippleInfo?.rippleSize.width)!)
            let _ = rippleView?.addConstraint(forHeight: (rippleInfo?.rippleSize.height)!)
            
            let backgroundView = UIView()
            backgroundView.isUserInteractionEnabled = false
            backgroundView.backgroundColor = rippleInfo?.backgroundColor
            backgroundView.layer.cornerRadius = (rippleInfo?.backgroundRadius!)!
            insertSubview(backgroundView, belowSubview: self.imageView!)
            let _ = backgroundView.addConstraintForCenterAligningToSuperview(in: .vertical)
            let _ = backgroundView.addConstraintForCenterAligningToSuperview(in: .horizontal)
            let _ = backgroundView.addConstraint(forWidth: (rippleInfo?.backgroundSize.width)!)
            let _ = backgroundView.addConstraint(forHeight: (rippleInfo?.backgroundSize.height)!)
        }
    }
    
    //----------------------------
    // MARK: - Initalization
    //----------------------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, image: UIImage) {
        self.init(frame: frame)
        setImage(image, for: .normal)
        adjustsImageWhenHighlighted = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        layer.transform = CATransform3DScale(CATransform3DIdentity, 0.85, 0.85, 1.0)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        self.performTouchEndAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.performTouchEndAnimation()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.performTouchEndAnimation()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if adjustHitOffset.width != 0 || adjustHitOffset.height != 0 {
            let adjustedBound = CGRect(x: bounds.origin.x-adjustHitOffset.width/2,
                                       y: bounds.origin.y-adjustHitOffset.height/2,
                                       width: bounds.width+adjustHitOffset.width,
                                       height: bounds.height+adjustHitOffset.height)
            return adjustedBound.contains(point)
            
        } else {
            return super.point(inside: point, with: event)
        }
    }
    
    func performTouchEndAnimation() {
        UIView.animate(withDuration: bounceDuration,
                       delay: 0,
                       usingSpringWithDamping: dampingRatio,
                       initialSpringVelocity: 1,
                       options: UIViewAnimationOptions.beginFromCurrentState,
                       animations: { 
                        self.layer.transform = CATransform3DIdentity
        }) { _ in
            
        }
        
        self.isSelected = !isSelected
        
        
        if self.isSelected && selectedTintColor != nil {
            self.tintColor = selectedTintColor
        } else {
            self.tintColor = normalTintColor
        }
        
        if rippleView != nil && isSelected {
            self.rippleView?.alpha = 1.0
            rippleView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: bounceDuration-0.5,
                           delay: 0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0.9,
                           options: .curveEaseInOut,
                           animations: { 
                            self.rippleView?.transform = .identity
            }, completion: { (_) in
                UIView.animate(withDuration: 0.3,
                               animations: { 
                                self.rippleView?.alpha = 0
                })
            })
        }
    }

}
