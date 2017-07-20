//
//  KPPhotoTransition.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/19.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

protocol ImageTransitionProtocol {
    func tranisitionSetup()
    func tranisitionCleanup()
    func imageWindowFrame() -> CGRect
}



class KPPhotoDisplayTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    enum photoTransitionType: String, RawRepresentable {
        case normal = "normal"
        case damping = "damping"
    }
    
    private var image: UIImage?
    private var fromDelegate: ImageTransitionProtocol?
    private var toDelegate: ImageTransitionProtocol?
    
    var presenting: Bool = true
    var transitionType: photoTransitionType = .normal
    
    // MARK: Setup Methods
    func setupImageTransition(_ image: UIImage,
                              fromDelegate: ImageTransitionProtocol,
                              toDelegate: ImageTransitionProtocol){
        self.image = image
        self.fromDelegate = fromDelegate
        self.toDelegate = toDelegate
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView;
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        
        // 3: Set the destination view controllers frame
        toVC.view.frame = fromVC.view.frame
        
        // 4: Create transition image view
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = (fromDelegate == nil) ?
            CGRect(x: 0, y: 0, width: 0, height: 0) :
            fromDelegate!.imageWindowFrame()
        imageView.clipsToBounds = true
        containerView.addSubview(imageView)
        
        // 5: Create from screen snapshot
        let fromSnapshot = fromVC.view.snapshotView(afterScreenUpdates: true)
        fromSnapshot?.frame = fromVC.view.frame
        containerView.addSubview(fromSnapshot!)
        
        fromDelegate!.tranisitionSetup()
        toDelegate!.tranisitionSetup()
        
        // 6: Create to screen snapshot
        let toSnapshot = toVC.view.snapshotView(afterScreenUpdates: true)
        toSnapshot?.frame = fromVC.view.frame
        containerView.addSubview(toSnapshot!)
        toSnapshot?.alpha = 0
        
        // 7: Bring the image view to the front and get the final frame
        containerView.bringSubview(toFront: imageView)
        let toFrame = (self.toDelegate == nil) ?
        CGRect(x: 0, y: 0, width: 0, height: 0) :
            self.toDelegate!.imageWindowFrame()
        
        
        
        if transitionType == .normal {
            CATransaction.setDisableActions(true)
            imageView.layer.bounds = CGRect(x: 0, y: 0, width: toFrame.width, height: toFrame.height)
            imageView.layer.position = CGPoint(x: toFrame.origin.x+toFrame.width/2,
                                               y: toFrame.origin.y+toFrame.height/2)
            
            
            let animationBound = CABasicAnimation(keyPath: "bounds")
            animationBound.duration = 0.4
            animationBound.timingFunction = CAMediaTimingFunction(controlPoints: 0.13, 1.03, 0.65, 0.96)
            
            let animationPosition = CABasicAnimation(keyPath: "position")
            animationPosition.duration = 0.4
            animationPosition.timingFunction = CAMediaTimingFunction(controlPoints: 0.13, 1.03, 0.65, 0.96)
            
            CATransaction.setCompletionBlock { 
                self.toDelegate!.tranisitionCleanup()
                self.fromDelegate!.tranisitionCleanup()
                
                // 9: Remove transition views
                imageView.removeFromSuperview()
                fromSnapshot?.removeFromSuperview()
                toSnapshot?.removeFromSuperview()
                
                // 10: Complete transition
                if !transitionContext.transitionWasCancelled {
                    containerView.addSubview(toVC.view)
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
            imageView.layer.add(animationBound, forKey: nil)
            imageView.layer.add(animationPosition, forKey: nil)
            
            // 8: Animate change
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.85,
                           initialSpringVelocity: 0.3,
                           options: .curveEaseOut,
                           animations: { 
                            toSnapshot?.alpha = 1
            }) { (_) in
            }
        } else {
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.85,
                           initialSpringVelocity: 0.3,
                           options: .curveEaseOut,
                           animations: {
                            toSnapshot?.alpha = 1
                            imageView.frame = toFrame
            }) { (_) in
                            self.toDelegate!.tranisitionCleanup()
                            self.fromDelegate!.tranisitionCleanup()
                
                            // 9: Remove transition views
                            imageView.removeFromSuperview()
                            fromSnapshot?.removeFromSuperview()
                            toSnapshot?.removeFromSuperview()
                
                            // 10: Complete transition
                            if !transitionContext.transitionWasCancelled {
                                containerView.addSubview(toVC.view)
                            }
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}
