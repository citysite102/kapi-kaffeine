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
    case none = "None"
    case popout = "Popout"
}

protocol KPModalControllerDelegate: NSObjectProtocol {
    func modalControllerWillDissmiss(_ modalViewController: KPModalViewController);
    func modalControllerDidDissmiss(_ modalViewController: KPModalViewController);
    func modalControllerWillPresent(_ modalViewController: KPModalViewController);
    func modalControllerDidPresent(_ modalViewController: KPModalViewController);
    func modalControllerBackgroundOnTouched(_ modalViewController: KPModalViewController);
}

class KPModalViewController: UIViewController {

    
    static let defaultDismissDuration: CGFloat = 0.2;
    
    
    var dismissWhenTouchingOnBackground: Bool = true;
    var presentationStyle: KPModalPresentationStyle = .bottom;
    var layoutWithSize: Bool = true;
    var layoutWithInset: Bool = false;
    
    
    var contentSize: CGSize = CGSize.init(width: 0, height: 0) {
        didSet {
            if self.containerSensingView != nil {
                self.containerWidthConstraint = self.containerSensingView.constraint(forWidth: contentSize.width);
                self.containerHeightConstraint = self.containerSensingView.constraint(forHeight: contentSize.height);
                self.layoutWithSize = true;
                self.layoutWithInset = false;
            }
        }
    }
    
    var edgeInset: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            self.layoutWithSize = false;
            self.layoutWithInset = true;
        }
    }
    
    
    var backgroundSensingView: KPPopoverSensingView!
    var containerSensingView: KPPopoverSensingView!
    var containerWidthConstraint: NSLayoutConstraint!
    var containerHeightConstraint: NSLayoutConstraint!
    
    var contentView: UIView! {
        didSet {
            if oldValue != nil {
                oldValue.removeFromSuperview();
            }
            
            if contentView != nil {
                self.containerSensingView.addSubview(contentView);
                contentView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:|[$self]|"]);
            }
        }
    }
    
    var contentController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backgroundSensingView = KPPopoverSensingView();
        self.backgroundSensingView.delegate = self;
        self.backgroundSensingView.backgroundColor = UIColor.clear;
        self.view.addSubview(self.backgroundSensingView);
        self.backgroundSensingView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                    "V:|[$self]|"]);
        
        self.containerSensingView = KPPopoverSensingView();
        self.containerSensingView.backgroundColor = UIColor.clear;
        self.containerSensingView.delegate = self;
        self.containerSensingView.isHidden = true;
        self.backgroundSensingView.addSubview(self.containerSensingView);
        
        self.containerWidthConstraint = self.containerSensingView.constraint(forWidth: self.contentSize.width);
        self.containerHeightConstraint = self.containerSensingView.constraint(forHeight: self.contentSize.height);
    }
    
    func presentModalView() {
        let viewController = UIApplication.shared.topViewController;
        self.presentModalView(viewController);
    }
    
    func presentModalView(_ controller: UIViewController) {
        self.modalPresentationStyle = .overFullScreen;
        controller.present(self, animated: false) {
            self.setupPresentContent();
        };
    }
    
    func setupPresentContent() {
        
        let duration = 0.65;
        let damping  = 0.8;
        
        if self.contentController.parent != nil {
            self.contentController.willMove(toParentViewController: nil);
            self.contentController.view.removeFromSuperview();
            self.contentController.removeFromParentViewController();
        }
        
        if self.contentController != nil {
            self.contentView = self.contentController.view;
            self.addChildViewController(self.contentController);
            self.contentController.didMove(toParentViewController: self);
        }
        
        self.containerSensingView.removeAllRelatedConstraintsInSuperView();
        
        
        if self.layoutWithSize {
            self.containerSensingView.addConstraint(self.containerWidthConstraint);
            self.containerSensingView.addConstraint(self.containerHeightConstraint);
            self.containerSensingView.addConstraintForCenterAligningToSuperview(in: .vertical);
            self.containerSensingView.addConstraintForCenterAligningToSuperview(in: .horizontal);
        }
        
        if self.layoutWithInset {
            self.containerSensingView.addConstraints(fromStringArray: ["V:|-($metric0)-[$self]-($metric1)-|",
                                                                       "H:|-($metric2)-[$self]-($metric3)-|"],
                                                     metrics: [edgeInset.top,
                                                               edgeInset.bottom,
                                                               edgeInset.left,
                                                               edgeInset.right]);
        }
        
        // Initial Position
        var containerPoint: CGPoint = CGPoint.init(x: (self.view.frame.width-self.contentSize.width)/2,
                                                   y: self.view.frame.height);
        let containerSize: CGSize = CGSize.init(width: self.contentSize.width,
                                                height: self.contentSize.height);
        
        switch self.presentationStyle {
        case KPModalPresentationStyle.top:
            containerPoint.y = -self.contentSize.height;
        case KPModalPresentationStyle.bottom:
            containerPoint.y = self.view.frame.height;
        case KPModalPresentationStyle.popout:
            self.containerSensingView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5);
            self.containerSensingView.alpha = 0.0;
        default:
            print("Not Implement");
        }
        
        
        let containerFrame = CGRect.init(origin: containerPoint,
                                         size: containerSize);
        
        self.containerSensingView.frame = containerFrame;
        self.contentView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0),
                                             size: containerSize);
        self.contentView.layoutIfNeeded();
        
//        self.containerSensingView.center = self.backgroundSensingView.center;
//        self.contentView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
//        self.containerSensingView.alpha = 0;
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(damping),
                       initialSpringVelocity: 1.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        
                        self.backgroundSensingView.layoutIfNeeded();
                        self.containerSensingView.isHidden = false;
                        self.containerSensingView.alpha = 1.0;
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.3) { 
            self.view.backgroundColor = KPColorPalette.KPMainColor.grayColor_level3;
        }
    }
    
    
    func dismissControllerWithDefaultDuration() {
        self.dismissController(duration: KPModalViewController.defaultDismissDuration);
    }
    
    func dismissController(duration: CGFloat) {
        self.dismissController(duration: duration, completion: nil);
    }
    
    func dismissControllerWithDefaultDuration(completion: (() -> Void)? = nil) {
        self.dismissController(duration: KPModalViewController.defaultDismissDuration,
                               completion: nil);
    }
    
    func dismissController(duration: CGFloat, completion: (() -> Void)? = nil) {
        
        UIView.animate(withDuration: Double(duration),
                       animations: {
            switch self.presentationStyle {
            case KPModalPresentationStyle.top:
                self.containerSensingView.frameOrigin = CGPoint.init(x: self.containerSensingView.frame.minX,
                                                                     y: -self.view.frame.height);
            case KPModalPresentationStyle.bottom:
                self.containerSensingView.frameOrigin = CGPoint.init(x: self.containerSensingView.frame.minX,
                                                                     y: self.view.frame.height);
            case KPModalPresentationStyle.popout:
                self.containerSensingView.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5);
                self.containerSensingView.alpha = 0.0;
            default:
                print("Not Implement");
            }
        }) { (_) in
            if self.contentController != nil {
                self.contentController.willMove(toParentViewController: nil);
                self.contentController.view.removeFromSuperview();
                self.contentController.removeFromParentViewController();
            }
            
            
            super.dismiss(animated: false,
                          completion: { 
                            completion?();
                            self.contentView.removeFromSuperview();
                            self.contentView = nil;
                            self.contentController = nil;
                            self.backgroundSensingView.actionAvailableViews = nil;
                            self.containerSensingView.isHidden = false;
            });
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
            self.dismissControllerWithDefaultDuration();
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
            return parentController as? KPModalViewController;
        } else {
            return nil
        }
        
    }
}
