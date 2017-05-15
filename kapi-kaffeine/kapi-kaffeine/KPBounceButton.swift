//
//  KPBounceButton.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/22.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import pop

class KPBounceButton: UIButton {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    var dampingRatio: CGFloat = 0.35
    var bounceDuration: Double = 0.8
    
    //----------------------------
    // MARK: - Initalization
    //----------------------------
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    convenience init (frame: CGRect, image: UIImage) {
        self.init(frame: frame);
        self.setImage(image.withRenderingMode(.alwaysTemplate),
                      for: .normal);
        self.setImage(image.withRenderingMode(.alwaysTemplate),
                      for: .highlighted);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
    }
    
    func performTouchEndAnimation() {
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
