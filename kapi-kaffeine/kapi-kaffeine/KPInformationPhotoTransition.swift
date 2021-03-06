//
//  KPInformationPhotoTransition.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/5.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPInformationPhotoTransition: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
//        let containerView = transitionContext.containerView;
//        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
//        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
//        
//        
//        // 3: Set the destination view controllers frame
//        toVC.view.frame = fromVC.view.frame
//        
//        // 4: Create transition image view
//        let imageView = UIImageView(image: image)
//        imageView.contentMode = .scaleAspectFill
//        imageView.frame = (fromDelegate == nil) ?
//            CGRect.init(x: 0, y: 0, width: 0, height: 0) :
//            fromDelegate!.imageWindowFrame()
//        imageView.clipsToBounds = true
//        containerView.addSubview(imageView)
//        
//        // 5: Create from screen snapshot
//        let fromSnapshot = fromVC.view.snapshotView(afterScreenUpdates: true)
//        fromSnapshot?.frame = fromVC.view.frame
//        containerView.addSubview(fromSnapshot!)
//        
//        fromDelegate!.tranisitionSetup()
//        toDelegate!.tranisitionSetup()
//        
//        // 6: Create to screen snapshot
//        let toSnapshot = toVC.view.snapshotView(afterScreenUpdates: true)
//        toSnapshot?.frame = fromVC.view.frame
//        containerView.addSubview(toSnapshot!)
//        toSnapshot?.alpha = 0
//        
//        // 7: Bring the image view to the front and get the final frame
//        containerView.bringSubview(toFront: imageView)
//        let toFrame = (self.toDelegate == nil) ?
//            CGRect.init(x: 0, y: 0, width: 0, height: 0) :
//            self.toDelegate!.imageWindowFrame()
//        
//        // 8: Animate change
//        UIView.animate(withDuration: 0.5,
//                       delay: 0,
//                       usingSpringWithDamping: 0.8,
//                       initialSpringVelocity: 0.6,
//                       options: .curveEaseOut,
//                       animations: {
//                        toSnapshot?.alpha = 1
//                        imageView.frame = toFrame
//        }) { (_) in
//            self.toDelegate!.tranisitionCleanup()
//            self.fromDelegate!.tranisitionCleanup()
//            
//            // 9: Remove transition views
//            imageView.removeFromSuperview()
//            fromSnapshot?.removeFromSuperview()
//            toSnapshot?.removeFromSuperview()
//            
//            // 10: Complete transition
//            if !transitionContext.transitionWasCancelled {
//                containerView.addSubview(toVC.view)
//            }
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//            
//        }
    }
    
}
