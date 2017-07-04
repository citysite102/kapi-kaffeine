//
//  KPPopoverView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/3.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

protocol PopoverProtocol {
    var popoverView: KPPopoverView! { get set }
}

class KPPopoverView: UIView {

    
    static let sharedPopoverView = KPPopoverView()

    var dismissWhenTouchOnBackground: Bool = true
    var contentView: UIView! {
        didSet {
            containerView.addSubview(contentView)
            contentView.addConstraints(fromStringArray: ["V:|[$self]"])
            contentView.addConstraintForCenterAligningToSuperview(in: .horizontal)
            contentView.addConstraintsForExpandingSuperview()
            contentView.layoutIfNeeded()
            
            if var protocolView = contentView as? PopoverProtocol {
                protocolView.popoverView = self
            }
        }
    }

    
    private var backgroundView: KPPopoverSensingView!
    private var containerView: UIView!
    
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        initWithDefaultSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initWithDefaultSetting() {
        
        backgroundView = KPPopoverSensingView()
        backgroundView.backgroundColor = KPColorPalette.KPMainColor.grayColor_level3
        backgroundView.actionAvailableViews = [self]
        backgroundView.alpha = 0
        backgroundView.passTouchEventAnyway = false
        backgroundView.delegate = self
        addSubview(backgroundView)
        backgroundView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                        "H:|[$self]|"])
        
        containerView = UIView()
        containerView.backgroundColor = UIColor.clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.isHidden = true
        addSubview(containerView)
        
    }
    
    
    func popoverContent() {
        
        let rootView = UIApplication.shared.topView
        rootView?.addSubview(self)
        
        containerView.alpha = 1.0
        containerView.isHidden = false
        
        addConstraints(fromStringArray: ["V:|[$self]|",
                                         "H:|[$self]|"])
        layoutIfNeeded()
        isUserInteractionEnabled = true
        
        containerView.removeAllRelatedConstraintsInSuperView()
        containerView.addConstraintForCenterAligningToSuperview(in: .vertical)
        containerView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        containerView.layoutIfNeeded()
        containerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseOut,
                       animations: { 
                        self.containerView.transform = .identity
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       options: .beginFromCurrentState,
                       animations: { 
                        self.backgroundView.alpha = 1.0
        }) { (_) in
            
        }
    }
    
    func dismiss() {
        
        isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.4,
                       delay: 0.05,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseOut,
                       animations: {
                        self.containerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (_) in
            self.contentView.removeFromSuperview()
            self.removeFromSuperview()
        }
        
        UIView.animate(withDuration: 0.35,
                       delay: 0.05,
                       options: .curveLinear,
                       animations: { 
                        self.backgroundView.alpha = 0
                        self.containerView.alpha = 0
        }) { (_) in
            
        }
    }
}

extension KPPopoverView: KPPopoverSensingViewDelegate {
    
    func sensingViewStartTouchAtUnavailableArea(_ popoverSensingView: KPPopoverSensingView) {
        if dismissWhenTouchOnBackground {
            dismiss()
        }
    }
    
    func sensingViewTouchEnd(_ popoverSensingView: KPPopoverSensingView) {
        if dismissWhenTouchOnBackground {
            dismiss()
        }
    }
}
