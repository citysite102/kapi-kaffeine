//
//  KPPhotoTransition.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/19.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPPhotoTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! ViewController;
//        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! ViewController;
//    
//        let container = transitionContext.containerView;
        
//        //2.创建一个 Cell 中 imageView 的截图，并把 imageView 隐藏，造成使用户以为移动的就是 imageView 的假象
//        let snapshotView = fromVC.selectedCell.imageView.snapshotViewAfterScreenUpdates(false)
//        snapshotView.frame = container.convertRect(fromVC.selectedCell.imageView.frame, fromView: fromVC.selectedCell)
//        fromVC.selectedCell.imageView.hidden = true
//        
//        //3.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
//        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
//        toVC.view.alpha = 0
//        
//        //4.都添加到 container 中。注意顺序不能错了
//        container.addSubview(toVC.view)
//        container.addSubview(snapshotView)
//        
//        //5.执行动画
//        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
//            snapshotView.frame = toVC.avatarImageView.frame
//            toVC.view.alpha = 1
//        }) { (finish: Bool) -> Void in
//            fromVC.selectedCell.imageView.hidden = false
//            toVC.avatarImageView.image = toVC.image
//            snapshotView.removeFromSuperview()
//            
//            //一定要记得动画完成后执行此方法，让系统管理 navigation
//            transitionContext.completeTransition(true)
//        }
    }
    
}
