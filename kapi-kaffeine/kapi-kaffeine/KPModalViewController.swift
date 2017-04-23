//
//  KPModalViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/24.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit


enum presentationType {
    case bottom
    case top
    case none
    case popout
}

protocol KPModalControllerDelegate: NSObjectProtocol {
    func modalControllerWillDissmiss(_ modalViewController: KPModalViewController);
    func modalControllerDidDissmiss(_ modalViewController: KPModalViewController);
    func modalControllerWillPresent(_ modalViewController: KPModalViewController);
    func modalControllerDidPresent(_ modalViewController: KPModalViewController);
    func modalControllerBackgroundOnTouched(_ modalViewController: KPModalViewController);
}

class KPModalViewController: UIViewController, KPPopoverSensingViewDelegate {

    
    var backgroundSensingView: KPPopoverSensingView!
    var containerSensingView: KPPopoverSensingView!
    var containerWidthConstraint: NSLayoutConstraint!
    var containerHeightConstraint: NSLayoutConstraint!
    
    var contentView: UIView! {
        didSet {
            if oldValue != nil {
                oldValue.removeFromSuperview();
            }
            self.containerSensingView.addSubview(contentView);
            contentView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"]);
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
        
        self.containerWidthConstraint = self.containerSensingView.constraint(forWidth: 120);
        self.containerHeightConstraint = self.containerSensingView.constraint(forHeight: 120);
    }
    
    func presentModalView() {
        let viewController = UIApplication.shared.topViewController;
        self.presentModalView(viewController);
    }
    
    func presentModalView(_ controller: UIViewController) {
        self.modalPresentationStyle = .fullScreen;
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
        
        self.containerSensingView.addConstraint(self.containerWidthConstraint);
        self.containerSensingView.addConstraint(self.containerHeightConstraint);
        self.containerSensingView.addConstraintForCenterAligningToSuperview(in: .vertical);
        self.containerSensingView.addConstraintForCenterAligningToSuperview(in: .horizontal);
        
        self.containerSensingView.center = self.backgroundSensingView.center;
        self.contentView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
        self.containerSensingView.alpha = 0;
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(damping),
                       initialSpringVelocity: 1.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { 
                        self.contentView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
                        self.containerSensingView.isHidden = false;
                        self.containerSensingView.alpha = 1.0;
                        self.backgroundSensingView.layoutIfNeeded();
        }) { (_) in
            
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

private var KPMODALVIEWCONTROLLER_PROPERTY = 0

extension UIViewController {
    
    var appModalController: KPModalViewController {
        get {
            let result = objc_getAssociatedObject(self,
                                                  &KPMODALVIEWCONTROLLER_PROPERTY) as? KPModalViewController
            if result == nil {
                return KPModalViewController()
            }
            return result!
        }
        set {
            objc_setAssociatedObject(self,
                                     &KPMODALVIEWCONTROLLER_PROPERTY,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}
