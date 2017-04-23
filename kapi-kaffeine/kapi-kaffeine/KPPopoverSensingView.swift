//
//  KPPopoverSensingView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/23.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

@objc protocol KPPopoverSensingViewDelegate: NSObjectProtocol {
    @objc optional func sensingViewStartTouchAtUnavailableArea(_ popoverSensingView: KPPopoverSensingView);
    @objc optional func sensingViewTouchBegan(_ popoverSensingView: KPPopoverSensingView);
    @objc optional func sensingViewTouchEnd(_ popoverSensingView: KPPopoverSensingView);
}

class KPPopoverSensingView: UIView {
    
    weak open var delegate: KPPopoverSensingViewDelegate?
    
    var passTouchEventAnyway: Bool!
    var actionAvailableViews: [UIView]!
    var isPassingTouched: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.passTouchEventAnyway = false;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitTestView = super.hitTest(point, with: event);
        
        if hitTestView == self {
            for actionView in self.actionAvailableViews {
                let convertRect = self.convert(actionView.bounds, from: actionView);
                if convertRect.contains(point) {
                    return nil;
                }
            }
        }
        
        if passTouchEventAnyway {
            self.delegate?.sensingViewStartTouchAtUnavailableArea!(self);
            return nil;
        } else {
            return self;
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isTouchNeededToBePassedThrough(touches) {
            self.next?.touchesBegan(touches, with: event);
            self.isPassingTouched = true;
        } else {
            self.delegate?.sensingViewTouchBegan!(self);
            self.isPassingTouched = false;
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isTouchNeededToBePassedThrough(touches) {
            self.next?.touchesMoved(touches, with: event);
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isPassingTouched {
            self.next?.touchesEnded(touches, with: event);
        } else {
            self.delegate?.sensingViewTouchEnd!(self);
        }
    }
    
    
    func isTouchNeededToBePassedThrough(_ touches: Set<UITouch>) -> Bool {
        if self.actionAvailableViews.count <= 0 {
            return false;
        }
        
        for touch in touches {
            for actionView in self.actionAvailableViews {
                let convertRect = self.convert(actionView.bounds, from: actionView);
                if !convertRect.contains(touch.location(in: self)) {
                    return false;
                }
            }
        }
        
        return true;
    }
}
