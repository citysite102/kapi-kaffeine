//
//  KPInformationTranstion
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/19.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPInformationTranstion: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! KPMainViewController;
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! UINavigationController;
        
        let container = transitionContext.containerView;
        let bounds = UIScreen.main.bounds;
        let finalFrameForVC = transitionContext.finalFrame(for: toVC);
        
        toVC.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: bounds.size.height);
        container.addSubview(toVC.view);
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.8,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { 
                        fromVC.view.alpha = 0.5
                        fromVC.view.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
                        toVC.view.frame = finalFrameForVC
        }) { (finish) in
            transitionContext.completeTransition(true)
            fromVC.view.alpha = 1.0
        }
    }
}
