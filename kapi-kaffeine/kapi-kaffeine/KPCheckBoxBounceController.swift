//
//  KPCheckBoxBounceController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/5.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPCheckBoxBounceController: KPCheckBoxController {

    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    override var tintColor: UIColor {
        didSet {
            selectedBoxLayer.strokeColor = tintColor.cgColor
            if style == .stroke {
                markLayer.strokeColor = tintColor.cgColor
                if markType == .radio {
                    markLayer.fillColor = tintColor.cgColor
                }
            } else {
                if markType == .radio {
                    selectedBoxLayer.fillColor = nil
                } else {
                    selectedBoxLayer.fillColor = tintColor.cgColor
                }
            }
        }
    }
    
    override var secondaryTintColor: UIColor? {
        didSet {
            unselectedBoxLayer.strokeColor = secondaryTintColor?.cgColor
        }
    }
    
    override var secondaryCheckmarkTintColor: UIColor? {
        didSet {
            if style == .fill {
                markLayer.strokeColor = secondaryCheckmarkTintColor?.cgColor
                if markType == .radio {
                    markLayer.strokeColor = nil
                    markLayer.fillColor  = secondaryCheckmarkTintColor?.cgColor
                }
            }
        }
    }
    
    override var hideBox: Bool {
        didSet {
            selectedBoxLayer.isHidden = hideBox
            unselectedBoxLayer.isHidden = hideBox
        }
    }
    
    var style: KPCheckBox.AnimationStyle = .stroke
    
    init(style: KPCheckBox.AnimationStyle) {
        self.style = style
        super.init()
        sharedSetup()
    }
    
    override init() {
        super.init()
        sharedSetup()
    }
    
    fileprivate func sharedSetup() {
        // Disable som implicit animations.
        let newActions = [
            "opacity": NSNull(),
            "strokeEnd": NSNull(),
            "transform": NSNull(),
            "fillColor": NSNull(),
            "path": NSNull(),
            "lineWidth": NSNull()
        ]
        
        // Setup the unselected box layer
        unselectedBoxLayer.lineCap = kCALineCapRound
        unselectedBoxLayer.rasterizationScale = UIScreen.main.scale
        unselectedBoxLayer.shouldRasterize = true
        unselectedBoxLayer.actions = newActions
        
        unselectedBoxLayer.opacity = 1.0
        unselectedBoxLayer.strokeEnd = 1.0
        unselectedBoxLayer.transform = CATransform3DIdentity
        unselectedBoxLayer.fillColor = nil
        
        // Setup the selected box layer.
        selectedBoxLayer.lineCap = kCALineCapRound
        selectedBoxLayer.rasterizationScale = UIScreen.main.scale
        selectedBoxLayer.shouldRasterize = true
        selectedBoxLayer.actions = newActions
        
        selectedBoxLayer.fillColor = nil
        selectedBoxLayer.transform = CATransform3DIdentity
        
        // Setup the checkmark layer.
        markLayer.lineCap = kCALineCapRound
        markLayer.lineJoin = kCALineJoinRound
        markLayer.rasterizationScale = UIScreen.main.scale
        markLayer.shouldRasterize = true
        markLayer.actions = newActions
        
        markLayer.transform = CATransform3DIdentity
        markLayer.fillColor = nil
    }
    
    
    //----------------------------
    // MARK: - Layers
    //----------------------------
    
    let markLayer = CAShapeLayer()
    let selectedBoxLayer = CAShapeLayer()
    let unselectedBoxLayer = CAShapeLayer()
    
    override var layersToDisplay: [CALayer] {
        return [unselectedBoxLayer, selectedBoxLayer, markLayer]
    }

    
    //----------------------------
    // MARK: - Animations
    //----------------------------
    
    override func animate(_ fromState: KPCheckBox.CheckState?, toState: KPCheckBox.CheckState?,
                          completion: (() -> Void)?) {
        super.animate(fromState, toState: toState)
        
        if pathGenerator.pathForMark(toState) == nil && pathGenerator.pathForMark(fromState) != nil {
            
            let amplitude: CGFloat = pathGenerator.boxType == .square ? 0.20 : 0.35
            let wiggleAnimation = animationGenerator.fillAnimation(2, amplitude: amplitude, reverse: true)
            let opacityAnimation = animationGenerator.opacityAnimation(true)
            opacityAnimation.duration = opacityAnimation.duration / 1.5
            opacityAnimation.beginTime = CACurrentMediaTime() + animationGenerator.animationDuration - opacityAnimation.duration
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayersForState(self.state)
                completion?()
            })
            
            selectedBoxLayer.add(opacityAnimation, forKey: "opacity")
            markLayer.add(wiggleAnimation, forKey: "transform")
            
            CATransaction.commit()
        } else if pathGenerator.pathForMark(toState) != nil && pathGenerator.pathForMark(fromState) == nil {
            
            markLayer.path = pathGenerator.pathForMark(toState)?.cgPath
            
            let amplitude: CGFloat = pathGenerator.boxType == .square ? 0.20 : 0.35
            let wiggleAnimation = animationGenerator.fillAnimation(1, amplitude: amplitude, reverse: false)
            
            let opacityAnimation = animationGenerator.opacityAnimation(false)
            opacityAnimation.duration = opacityAnimation.duration / 1.5
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ () -> Void in
                self.resetLayersForState(self.state)
                completion?()
            })
            
            selectedBoxLayer.add(opacityAnimation, forKey: "opacity")
            markLayer.add(wiggleAnimation, forKey: "transform")
            
            CATransaction.commit()
        } else {
            
            let fromPath = pathGenerator.pathForMark(fromState)
            let toPath = pathGenerator.pathForMark(toState)
            
            let morphAnimation = animationGenerator.morphAnimation(fromPath, toPath: toPath)
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({ [unowned self] () -> Void in
                self.resetLayersForState(self.state)
                completion?()
            })
            
            markLayer.add(morphAnimation, forKey: "path")
            
            CATransaction.commit()
        }
        
    }
    
    //----------------------------
    // MARK: - Layout
    //----------------------------
    
    override func layoutLayers() {
        // Frames
        unselectedBoxLayer.frame = CGRect(x: 0.0, y: 0.0, width: pathGenerator.size, height: pathGenerator.size)
        selectedBoxLayer.frame = CGRect(x: 0.0, y: 0.0, width: pathGenerator.size, height: pathGenerator.size)
        markLayer.frame = CGRect(x: 0.0, y: 0.0, width: pathGenerator.size, height: pathGenerator.size)
        // Paths
        unselectedBoxLayer.path = pathGenerator.pathForBox()?.cgPath
        selectedBoxLayer.path = pathGenerator.pathForBox()?.cgPath
        markLayer.path = pathGenerator.pathForMark(state)?.cgPath
    }
    
    //----------------------------
    // MARK: - Display
    //----------------------------
    
    override func resetLayersForState(_ state: KPCheckBox.CheckState?) {
        super.resetLayersForState(state)
        
        // Remove all remnant animations. They will interfere with each other if they are not removed before a new round of animations start.
        unselectedBoxLayer.removeAllAnimations()
        selectedBoxLayer.removeAllAnimations()
        markLayer.removeAllAnimations()
        
        // Set the properties for the final states of each necessary property of each layer.
        unselectedBoxLayer.strokeColor = secondaryTintColor?.cgColor
        unselectedBoxLayer.lineWidth = pathGenerator.boxLineWidth
        
        selectedBoxLayer.strokeColor = tintColor.cgColor
        selectedBoxLayer.lineWidth = pathGenerator.boxLineWidth
        
        if style == .stroke {
            selectedBoxLayer.fillColor = nil
            markLayer.strokeColor = tintColor.cgColor
            if markType != .radio {
                markLayer.fillColor = nil
            } else {
                markLayer.fillColor = tintColor.cgColor
            }
        } else {
            markLayer.strokeColor = secondaryCheckmarkTintColor?.cgColor
            if markType == .radio {
                selectedBoxLayer.fillColor = nil
                markLayer.fillColor = tintColor.cgColor
                markLayer.strokeColor = nil
            } else {
                selectedBoxLayer.fillColor = tintColor.cgColor
            }
        }
        
        markLayer.lineWidth = pathGenerator.checkmarkLineWidth
        
        if pathGenerator.pathForMark(state) != nil {
            markLayer.transform = CATransform3DIdentity
            selectedBoxLayer.opacity = 1.0
        } else {
            selectedBoxLayer.opacity = 0.0
            markLayer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
        }
        
        // Paths
        unselectedBoxLayer.path = pathGenerator.pathForBox()?.cgPath
        selectedBoxLayer.path = pathGenerator.pathForBox()?.cgPath
        markLayer.path = pathGenerator.pathForMark(state)?.cgPath
    }
}
