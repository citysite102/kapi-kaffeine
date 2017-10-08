//
//  KPInputExpandTransition.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/16.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

protocol InputTransitionProtocol {
    func inputSubTitleLabelFrame() -> CGRect
    func inputTextfieldFrame() -> CGRect
    
}

class KPInputExpandTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    
    private var inputView: KPSubTitleEditView!
    private var fromDelegate: InputTransitionProtocol?
    private var toDelegate: InputTransitionProtocol?
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "店家名稱"
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        return label
    }()
    
    lazy var editTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = KPColorPalette.KPTextColor.grayColor_level2
        textField.placeholder = "請輸入店家名稱"
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    var presenting: Bool = true
    // MARK: Setup Methods
    
    func setupInputTransition(_ inputView: KPSubTitleEditView,
                              fromDelegate: InputTransitionProtocol,
                              toDelegate: InputTransitionProtocol){
        self.inputView = inputView
        self.fromDelegate = fromDelegate
        self.toDelegate = toDelegate
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView;
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        
        // 3: Set the destination view controllers frame
        toVC.view.frame = fromVC.view.frame
        
        var inputTitleFrame = self.inputView.subTitleLabel.frame
        inputTitleFrame.origin = CGPoint(x: inputTitleFrame.origin.x,
                                         y: inputTitleFrame.origin.y+44)
        
        var inputFieldFrame = self.inputView.editTextField.frame
        inputFieldFrame.origin = CGPoint(x: inputFieldFrame.origin.x,
                                         y: inputFieldFrame.origin.y+44)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        backgroundView.frame = CGRect(x: inputTitleFrame.origin.x,
                                      y: inputTitleFrame.origin.y+44,
                                      width: UIScreen.main.bounds.size.width,
                                      height: inputFieldFrame.origin.y+44+inputFieldFrame.size.height-inputTitleFrame.origin.x)
        
        containerView.addSubview(backgroundView)
        
        
        subTitleLabel.frame = inputTitleFrame
        editTextField.frame = inputFieldFrame
        
        containerView.addSubview(subTitleLabel)
        containerView.addSubview(editTextField)
        
        // 7: Bring the image view to the front and get the final frame
//        containerView.bringSubview(toFront: inputView)
//        let toFrame = (self.toDelegate == nil) ?
//            CGRect(x: 0, y: 0, width: 0, height: 0) :
//            self.toDelegate!.inputWindowFrame()
        
//        let toFrame = CGRect(x: 0, y: 58, width: 320, height: 72)
        
        // 8: Animate change
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0.3,
                       options: .curveEaseOut,
                       animations: {
                        if var titleFrame = self.toDelegate?.inputSubTitleLabelFrame() {
                            titleFrame.origin = CGPoint(x: titleFrame.origin.x, y: titleFrame.origin.y-20)
                            self.subTitleLabel.frame = titleFrame
                        }
                        
                        if var fieldFrame = self.toDelegate?.inputTextfieldFrame() {
                            fieldFrame.origin = CGPoint(x: fieldFrame.origin.x, y: fieldFrame.origin.y-20)
                            self.editTextField.frame = fieldFrame
                        }
                        
                        
                        backgroundView.frame = toVC.view.frame
        }) { (_) in
//            self.toDelegate!.tranisitionCleanup()
//            self.fromDelegate!.tranisitionCleanup()
            
            // 9: Remove transition views
//            self.inputView.removeFromSuperview()
//            fromSnapshot?.removeFromSuperview()
//            toSnapshot?.removeFromSuperview()
            
            // 10: Complete transition
            if !transitionContext.transitionWasCancelled {
                containerView.addSubview(toVC.view)
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
    }
    
    func animationEnded(_ transitionCompleted: Bool) {
        
    }

}
