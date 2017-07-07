//
//  demoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/7.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

enum STATE {
    case STATE1
    case STATE2
    case STATE3
}

class menu: UIView {
    
    var animateMenuLayer: menuLayer!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        let real_frame = UIEdgeInsetsInsetRect(frame,
                                               UIEdgeInsetsMake(30,
                                                                30,
                                                                30,
                                                                30))
        animateMenuLayer = menuLayer()
        super.init(frame: real_frame)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        animateMenuLayer.frame = bounds
        animateMenuLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(animateMenuLayer)
        animateMenuLayer.setNeedsDisplay()
    }
    
    func openAnimation() {
        let openAnimation_1 = animator.sharedAnimator.createBasicAnimation("xAxisPercent",
                                                                           0.3,
                                                                           0,
                                                                           1)
//        openAnimation_1.delegate = self as! CAAnimationDelegate
        animateMenuLayer.add(openAnimation_1,
                             forKey: "openAnimation_1")
        
    }
}

//extension menu: CAAnimationDelegate {
//    override func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        
//    }
//}

class animator {
    
    static let sharedAnimator = animator()
    
    func createBasicAnimation(_ keypath: String,
                              _ duration: CFTimeInterval,
                              _ fromValue: Any,
                              _ toValue: Any) -> CAKeyframeAnimation {
        let anim = CAKeyframeAnimation(keyPath: keypath)
        anim.values = self.basicAnimationValues(fromValue, toValue, CGFloat(duration)) as! [Any]
        anim.duration = duration
        anim.fillMode = kCAFillModeForwards
        anim.isRemovedOnCompletion = false
        
        return anim
    }
    
    func basicAnimationValues(_ fromValue: Any,
                              _ toValue: Any,
                              _ duration: CGFloat) -> NSMutableArray {
        let numberOfFrames = duration * 60
        let values = NSMutableArray(capacity: Int(numberOfFrames))
        for _ in 0..<values.count {
            values.add(0)
        }
        
        let diff: CGFloat = CGFloat(toValue as? Double ?? 0) - CGFloat(fromValue as? Double ?? 0)
        for i in 0..<values.count {
            let x: CGFloat = CGFloat(i)/numberOfFrames
            let value = CGFloat(fromValue as? Double ?? 0) + x*diff
            values[i] = value
        }
        return values
    }
}

class menuLayer: CALayer {

    static let rectOffset: CGFloat = 30
    var animationState: STATE = .STATE1
    var xAxisPercent: CGFloat = 0.0
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "xAxisPercent" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let lastLayer = layer as? menuLayer {
            xAxisPercent = lastLayer.xAxisPercent
        }
    }
    
    override func draw(in ctx: CGContext) {
        
        let real_rect = UIEdgeInsetsInsetRect(self.frame,
                                              UIEdgeInsetsMake(menuLayer.rectOffset,
                                                               menuLayer.rectOffset,
                                                               menuLayer.rectOffset,
                                                               menuLayer.rectOffset))
        
        let offset = real_rect.size.width/3.6
        let center = CGPoint(x: frame.midX, y: frame.midY)
        
        
        let moveDistance = xAxisPercent*(offset)
        let top_left = CGPoint(x: center.x-offset-moveDistance,
                               y: menuLayer.rectOffset)
        let top_center = CGPoint(x: center.x-moveDistance,
                                 y: menuLayer.rectOffset)
        let top_right = CGPoint(x: center.x+offset-moveDistance,
                                y: menuLayer.rectOffset)
        
        
        let right_top = CGPoint(x: real_rect.maxX,
                                y: center.y-offset)
        let right_center = CGPoint(x: real_rect.maxX,
                                   y: center.y)
        let right_bottom = CGPoint(x: real_rect.maxX,
                                   y: center.y+offset)
        
        let bottom_left = CGPoint(x: center.x-offset,
                                  y: real_rect.maxY)
        let bottom_center = CGPoint(x: center.x,
                                    y: real_rect.maxY)
        let bottom_right = CGPoint(x: center.x+offset,
                                   y: real_rect.maxY)
        
        let left_top = CGPoint(x: menuLayer.rectOffset,
                               y: center.y-offset)
        let left_center = CGPoint(x: menuLayer.rectOffset,
                               y: center.y)
        let left_bottom = CGPoint(x: menuLayer.rectOffset,
                               y: center.y+offset)
        
        let circlePath = UIBezierPath()
        circlePath.move(to: top_center)
        circlePath.addCurve(to: right_center,
                            controlPoint1: top_right,
                            controlPoint2: right_top)
        circlePath.addCurve(to: bottom_center,
                            controlPoint1: right_bottom,
                            controlPoint2: bottom_right)
        circlePath.addCurve(to: left_center,
                            controlPoint1: bottom_left,
                            controlPoint2: left_bottom)
        circlePath.addCurve(to: top_center,
                            controlPoint1: left_top,
                            controlPoint2: top_left)
        circlePath.close()
        
        ctx.addPath(circlePath.cgPath)
        ctx.setFillColor(UIColor(red: 29.0/255.0,
                                 green: 163.0/255.0,
                                 blue: 1.0,
                                 alpha: 1.0).cgColor)
        ctx.fillPath()
        
//        var moveDistance_1: CGFloat
//        var moveDistance_2: CGFloat
//        var top_left: CGPoint
//        var top_center: CGPoint
//        var top_right: CGPoint
//        
//        switch animationState {
//        case .STATE1:
//            
//        case .STATE2:
//        case .STATE3:
//        }
    }
    
}
