//
//  KPModalViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/24.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit


enum KPModalPresentationStyle: String, RawRepresentable {
    case bottom = "Bottom"
    case top = "Top"
    case right = "Right"
    case left = "Left"
    case none = "None"
    case popout = "Popout"
}

protocol KPModalControllerDelegate: NSObjectProtocol {
    func modalControllerWillDissmiss(_ modalViewController: KPModalViewController)
    func modalControllerDidDissmiss(_ modalViewController: KPModalViewController)
    func modalControllerWillPresent(_ modalViewController: KPModalViewController)
    func modalControllerDidPresent(_ modalViewController: KPModalViewController)
    func modalControllerBackgroundOnTouched(_ modalViewController: KPModalViewController)
}

class KPModalViewController: KPViewController {

    
    static let defaultDismissDuration: CGFloat = 0.3
    
    var keyboardIsShowing: Bool = false
    var dismissWhenTouchingOnBackground: Bool = true
    var contentMoveWithKeyboard: Bool = false
    var backgroundYConstraint: NSLayoutConstraint!
    
    var presentationStyle: KPModalPresentationStyle = .bottom
    var layoutWithSize: Bool = true
    var layoutWithInset: Bool = false
    var cornerRadius: UIRectCorner?
    
    var contentSize: CGSize = CGSize.init(width: 0, height: 0) {
        didSet {
//            if self.containerSensingView != nil {
//                self.containerWidthConstraint = self.containerSensingView.constraint(forWidth: contentSize.width)
//                self.containerHeightConstraint = self.containerSensingView.constraint(forHeight: contentSize.height)
                self.layoutWithSize = true
                self.layoutWithInset = false
//            }
        }
    }
    
    var edgeInset: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            self.layoutWithSize = false
            self.layoutWithInset = true
        }
    }
    
    
    var backgroundSensingView: KPPopoverSensingView!
    var containerSensingView: KPPopoverSensingView = {
        let containerSensingView = KPPopoverSensingView()
        containerSensingView.backgroundColor = UIColor.clear
        containerSensingView.isHidden = true
        return containerSensingView
    }()
//    var containerWidthConstraint: NSLayoutConstraint!
//    var containerHeightConstraint: NSLayoutConstraint!
    
    var contentView: UIView! {
        didSet {
            if oldValue != nil {
                oldValue.removeFromSuperview()
            }
            
            if contentView != nil {
                self.containerSensingView.addSubview(contentView)
                contentView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:|[$self]|"])
            }
        }
    }
    
    var contentController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundSensingView = KPPopoverSensingView()
        backgroundSensingView.delegate = self
        backgroundSensingView.backgroundColor = UIColor.clear
        view.addSubview(backgroundSensingView)
        backgroundSensingView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                               "V:|[$self]"])
        backgroundYConstraint = backgroundSensingView.addConstraint(from: "V:[$self]|").first as! NSLayoutConstraint
        
        containerSensingView.delegate = self
        backgroundSensingView.addSubview(containerSensingView)
        
//        containerWidthConstraint = containerSensingView.constraint(forWidth: contentSize.width)
//        containerHeightConstraint = containerSensingView.constraint(forHeight: contentSize.height)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func presentModalView() {
        let viewController = UIApplication.shared.topViewController
        presentModalView(viewController)
    }
    
    func presentModalView(_ controller: UIViewController) {
        presentModalView(controller, .overFullScreen)
    }
    
    func presentModalView(_ controller: UIViewController, _ style: UIModalPresentationStyle) {
        modalPresentationStyle = style
        controller.present(self, animated: false) {
            self.setupPresentContent()
        }
    }
    
    func setupPresentContent() {
        
        let duration = 0.7
        let damping  = 0.8
        
        if self.contentController.parent != nil {
            self.contentController.willMove(toParentViewController: nil)
            self.contentController.view.removeFromSuperview()
            self.contentController.removeFromParentViewController()
        }
        
        if self.contentController != nil {
            self.contentView = self.contentController.view
            self.addChildViewController(self.contentController)
            self.contentController.didMove(toParentViewController: self)
        }
        
        self.containerSensingView.removeAllRelatedConstraintsInSuperView()
        
        
        var containerPoint: CGPoint = CGPoint.init(x: 0, y: 0)
        var containerSize: CGSize = CGSize.init(width: 0, height: 0)
        
        if self.layoutWithSize {
            self.containerSensingView.addConstraint(forWidth: contentSize.width)
            self.containerSensingView.addConstraint(forHeight: contentSize.height)
            self.containerSensingView.addConstraintForCenterAligningToSuperview(in: .vertical)
            self.containerSensingView.addConstraintForCenterAligningToSuperview(in: .horizontal)
            
            containerPoint = CGPoint.init(x: (self.view.frame.width-self.contentSize.width)/2,
                                          y: self.contentSize.height)
            containerSize = CGSize.init(width: self.contentSize.width,
                                        height: self.contentSize.height)
        }
        
        if self.layoutWithInset {
            self.containerSensingView.addConstraints(fromStringArray: ["V:|-($metric0)-[$self]-($metric1)-|",
                                                                       "H:|-($metric2)-[$self]-($metric3)-|"],
                                                     metrics: [edgeInset.top,
                                                               edgeInset.bottom,
                                                               edgeInset.left,
                                                               edgeInset.right])
            containerPoint = CGPoint.init(x: edgeInset.left,
                                          y: edgeInset.top)
            containerSize = CGSize.init(width: backgroundSensingView.frame.size.width - edgeInset.left - edgeInset.right,
                                        height: backgroundSensingView.frame.size.height - edgeInset.top - edgeInset.bottom)
        }
        
        switch self.presentationStyle {
        case KPModalPresentationStyle.top:
            containerPoint.y = -self.contentSize.height
        case KPModalPresentationStyle.bottom:
            containerPoint.y = self.view.frame.height
        case KPModalPresentationStyle.left:
            containerPoint.x = -self.view.frame.width
            containerPoint.y = 0
        case KPModalPresentationStyle.right:
            containerPoint.x = self.view.frame.width
            containerPoint.y = 0
        case KPModalPresentationStyle.popout:
            self.containerSensingView.alpha = 0.0
        default:
            print("Not Implement")
        }
        
        let containerFrame = CGRect.init(origin: containerPoint,
                                         size: containerSize)
        
        self.containerSensingView.frame = containerFrame
        self.contentView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0),
                                             size: containerSize)
        
        self.contentView.layoutIfNeeded()
        
        if cornerRadius != nil {
            let path = UIBezierPath(roundedRect:CGRect.init(x: 0, y: 0,
                                                            width: contentView.frameSize.width,
                                                            height: contentView.frameSize.height),
                                    byRoundingCorners:cornerRadius!,
                                    cornerRadii: CGSize(width: 8, height:  8))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            contentView.layer.mask = maskLayer
        }
        
        if presentationStyle == .popout {
            self.containerSensingView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        }
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(damping),
                       initialSpringVelocity: 1.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        self.containerSensingView.transform = CGAffineTransform.identity
                        self.backgroundSensingView.layoutIfNeeded()
                        self.containerSensingView.isHidden = false
                        self.containerSensingView.alpha = 1.0
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.3) { 
            self.view.backgroundColor = KPColorPalette.KPMainColor.grayColor_level3
        }
    }
    
    
    func dismissControllerWithDefaultDuration() {
        self.dismissController(duration: KPModalViewController.defaultDismissDuration)
    }
    
    func dismissController(duration: CGFloat) {
        self.dismissController(duration: duration, completion: nil)
    }
    
    func dismissControllerWithDefaultDuration(completion: (() -> Void)? = nil) {
        self.dismissController(duration: KPModalViewController.defaultDismissDuration,
                               completion: nil)
    }
    
    func dismissController(duration: CGFloat, completion: (() -> Void)? = nil) {
        
        self.view.backgroundColor = UIColor.clear
        
        UIView.animate(withDuration: Double(duration),
                       animations: {
            switch self.presentationStyle {
            case KPModalPresentationStyle.top:
                self.containerSensingView.frameOrigin = CGPoint.init(x: self.containerSensingView.frame.minX,
                                                                     y: -self.view.frame.height)
            case KPModalPresentationStyle.bottom:
                self.containerSensingView.frameOrigin = CGPoint.init(x: self.containerSensingView.frame.minX,
                                                                     y: self.view.frame.height)
            case KPModalPresentationStyle.left:
                self.containerSensingView.frameOrigin = CGPoint.init(x: -self.view.frame.width,
                                                                     y: self.containerSensingView.frame.minY)
            case KPModalPresentationStyle.right:
                self.containerSensingView.frameOrigin = CGPoint.init(x: self.view.frame.width,
                                                                     y: self.containerSensingView.frame.minY)
            case KPModalPresentationStyle.popout:
                self.containerSensingView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                self.containerSensingView.alpha = 0.0
            default:
                print("Not Implement")
            }
        }) { (_) in
            if self.contentController != nil {
                self.contentController.willMove(toParentViewController: nil)
                self.contentController.view.removeFromSuperview()
                self.contentController.removeFromParentViewController()
            }
            
            
            super.dismiss(animated: false,
                          completion: { 
                            completion?()
                            self.contentView.removeFromSuperview()
                            self.contentView = nil
                            self.contentController = nil
                            self.backgroundSensingView.actionAvailableViews = nil
                            self.containerSensingView.isHidden = false
            })
        }
    }
    
    
    func handleKeyboardWillShow(_ notification: NSNotification) {
        keyboardIsShowing = true
        if !contentMoveWithKeyboard {
            return
        }
        
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRect = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRect.size.height
        let animationDuration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        UIView.animate(withDuration: animationDuration.doubleValue,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.backgroundSensingView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
        }) { (_) in
            
        }
    }
    
    func handleKeyboardWillHide(_ notification: NSNotification) {
        keyboardIsShowing = false
        if !contentMoveWithKeyboard {
            return
        }
        
        let userInfo = notification.userInfo
        let animationDuration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        UIView.animate(withDuration: animationDuration.doubleValue,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                            self.backgroundSensingView.transform = CGAffineTransform.identity
        }) { (_) in
            
        }
        
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension KPModalViewController: KPPopoverSensingViewDelegate {
    
    func sensingViewTouchBegan(_ popoverSensingView: KPPopoverSensingView) {
        
    }
    
    func sensingViewTouchEnd(_ popoverSensingView: KPPopoverSensingView) {
        if self.dismissWhenTouchingOnBackground &&
            popoverSensingView == self.backgroundSensingView {
            self.dismissControllerWithDefaultDuration()
        }
    }
}

private var KPMODALVIEWCONTROLLER_PROPERTY = 0

extension UIViewController {
    
//    var appModalController: KPModalViewController {
//        get {
//            let result = objc_getAssociatedObject(self,
//                                                  &KPMODALVIEWCONTROLLER_PROPERTY) as? KPModalViewController
//            if result == nil {
//                return KPModalViewController()
//            }
//            return result!
//        }
//        set {
//            objc_setAssociatedObject(self,
//                                     &KPMODALVIEWCONTROLLER_PROPERTY,
//                                     newValue,
//                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
//        }
//    }
    
    func appModalController() -> KPModalViewController? {
        
        var parentController = self.parent
        
        while !(parentController is KPModalViewController) && ((parentController?.parent) != nil) {
            parentController = parentController?.parent
        }
        
        if parentController is KPModalViewController {
            return parentController as? KPModalViewController
        } else {
            return nil
        }
        
    }
}
