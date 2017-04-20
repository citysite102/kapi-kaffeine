//
//  KPInformationDismissTransition.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/20.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPInformationDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! UINavigationController;
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! KPMainViewController;
        
        let container = transitionContext.containerView;
        let finalFrameForVC = transitionContext.finalFrame(for: toVC);

        toVC.view.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        container.insertSubview(toVC.view, at: 0);
        
        let opacityView = UIView();
        opacityView.backgroundColor = UIColor.black;
        opacityView.alpha = 0.5;
        opacityView.frame = finalFrameForVC;
        
        container.insertSubview(opacityView, at: 1);
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        fromVC.view.frame = finalFrameForVC.offsetBy(dx: 400, dy: 20);
                        fromVC.view.transform = CGAffineTransform(rotationAngle: 0.15);
                        opacityView.alpha = 0.0;
                        toVC.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
        }) { (finish) in
            
            if (transitionContext.transitionWasCancelled) {
                opacityView.removeFromSuperview();
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
}
