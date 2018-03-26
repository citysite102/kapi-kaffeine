//
//  KPInformationDismissTransition.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/20.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPInformationDismissTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var defaultDimissed: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! UINavigationController;
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! KPMainTabController;
        
        let container = transitionContext.containerView;
        let finalFrameForVC = transitionContext.finalFrame(for: toVC);
        
        fromVC.navigationBar.isHidden = true
        fromVC.view.layer.shouldRasterize = true
        fromVC.view.layer.rasterizationScale = UIScreen.main.scale
        toVC.view.layer.shouldRasterize = true
        toVC.view.layer.rasterizationScale = UIScreen.main.scale
        
        if defaultDimissed {
            toVC.view.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            container.insertSubview(toVC.view, at: 0);
            
            let opacityView = UIView();
            opacityView.backgroundColor = UIColor.black;
            opacityView.alpha = 0.5;
            opacityView.frame = finalFrameForVC;
            
            container.insertSubview(opacityView, at: 1);
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext)-0.1,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.8,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: {
                            opacityView.alpha = 0.0;
                            toVC.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                            fromVC.view.frame = CGRect(x: 0,
                                                       y: UIScreen.main.bounds.size.height,
                                                       width: UIScreen.main.bounds.size.width,
                                                       height: UIScreen.main.bounds.size.height)
            }) { (finish) in
                DispatchQueue.main.async {
                    if (transitionContext.transitionWasCancelled) {
                        opacityView.removeFromSuperview();
                    }
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    fromVC.view.layer.shouldRasterize = false
                    toVC.view.layer.shouldRasterize = false
                }
            }
        } else {
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
                            fromVC.view.frame = finalFrameForVC.offsetBy(dx: UIDevice().isSuperCompact ? 380 : 420,
                                                                         dy: 20);
                            fromVC.view.transform = CGAffineTransform(rotationAngle: 0.15);
                            opacityView.alpha = 0.0;
                            toVC.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            }) { (finish) in
                DispatchQueue.main.async {
                    if (transitionContext.transitionWasCancelled) {
                        opacityView.removeFromSuperview();
                    }
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    fromVC.view.layer.shouldRasterize = false
                    toVC.view.layer.shouldRasterize = false
                }
            }
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }
}
