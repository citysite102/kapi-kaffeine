//
//  KPPopoverSensingView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/23.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

@objc protocol KPPopoverSensingViewDelegate: NSObjectProtocol {
    @objc optional func sensingViewStartTouchAtUnavailableArea(_ popoverSensingView: KPPopoverSensingView)
    @objc optional func sensingViewTouchBegan(_ popoverSensingView: KPPopoverSensingView)
    @objc optional func sensingViewTouchEnd(_ popoverSensingView: KPPopoverSensingView)
    
    
}

class KPPopoverSensingView: UIView {
    
    weak open var delegate: KPPopoverSensingViewDelegate?
    
    var passTouchEventAnyway: Bool!
    var actionAvailableViews: [UIView]!
    var isPassingTouched: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        passTouchEventAnyway = false
        actionAvailableViews = [UIView]()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitTestView = super.hitTest(point, with: event)
        
        if hitTestView == self {
            for actionView in actionAvailableViews {
                let convertRect = convert(actionView.bounds, from: actionView)
                if convertRect.contains(point) {
                    return nil
                }
            }
            
            if passTouchEventAnyway {
                delegate?.sensingViewStartTouchAtUnavailableArea!(self)
                return nil
            } else {
                return self
            }
        }
        
        return hitTestView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouchNeededToBePassedThrough(touches) {
            next?.touchesBegan(touches, with: event)
            isPassingTouched = true
        } else {
            delegate?.sensingViewTouchBegan!(self)
            isPassingTouched = false
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouchNeededToBePassedThrough(touches) {
            next?.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPassingTouched {
            next?.touchesEnded(touches, with: event)
        } else {
            delegate?.sensingViewTouchEnd!(self)
        }
    }
    
    
    func isTouchNeededToBePassedThrough(_ touches: Set<UITouch>) -> Bool {
        if actionAvailableViews.count <= 0 {
            return false
        }
        
        for touch in touches {
            for actionView in actionAvailableViews {
                let convertRect = convert(actionView.bounds, from: actionView)
                if !convertRect.contains(touch.location(in: self)) {
                    return false
                }
            }
        }
        
        return true
    }
}
