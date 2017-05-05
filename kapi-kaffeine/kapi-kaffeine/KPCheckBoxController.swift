//
//  KPCheckBoxController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/5.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import UIKit

class KPCheckBoxController {
    
    //----------------------------
    // MARK: - Properties
    //----------------------------
    
    /// The path presets for the manager.
    var pathGenerator: KPCheckBoxPathGenerator = KPCheckboxCheckPathGenerator()
    
    /// The animation presets for the manager.
    var animationGenerator: KPCheckBoxAnimationGenerator = KPCheckBoxAnimationGenerator()
    
    /// The current state of the checkbox.
    var state: KPCheckBox.CheckState = .unchecked
    
    /// The current tint color.
    /// - Note: Subclasses should override didSet to update the layers when this value changes.
    var tintColor: UIColor = UIColor.black
    
    /// The secondary tint color.
    /// - Note: Subclasses should override didSet to update the layers when this value changes.
    var secondaryTintColor: UIColor? = UIColor.lightGray
    
    /// The secondary color of the mark.
    /// - Note: Subclasses should override didSet to update the layers when this value changes.
    var secondaryCheckmarkTintColor: UIColor? = UIColor.white
    
    /// Whether or not to hide the box.
    /// - Note: Subclasses should override didSet to update the layers when this value changes.
    var hideBox: Bool = false
    
    /// Whether or not to allow morphong between states.
    var enableMorphing: Bool = true
    
    // The type of mark to display.
    var markType: KPCheckBox.MarkType = .checkmark {
        didSet {
            if markType == oldValue {
                return
            }
            setMarkType(type: markType, animated: false)
        }
    }
    
    func setMarkType(type: KPCheckBox.MarkType, animated: Bool) {
        var newPathGenerator: KPCheckBoxPathGenerator? = nil
        if type != markType {
            switch type {
            case .checkmark:
                newPathGenerator = KPCheckboxCheckPathGenerator()
                break
            case .radio:
                newPathGenerator = KPCheckBoxRadioPathGenerator()
                break
            default:
                newPathGenerator = KPCheckBoxRadioPathGenerator()
                break
//            case .addRemove:
//                newPathGenerator = M13CheckboxAddRemovePathGenerator()
//                break
//            case .disclosure:
//                newPathGenerator = M13CheckboxDisclosurePathGenerator()
//                break
            }
            
            newPathGenerator?.boxLineWidth = pathGenerator.boxLineWidth
            newPathGenerator?.boxType = pathGenerator.boxType
            newPathGenerator?.checkmarkLineWidth = pathGenerator.checkmarkLineWidth
            newPathGenerator?.cornerRadius = pathGenerator.cornerRadius
            newPathGenerator?.size = pathGenerator.size
            
            // Animate the change.
            if pathGenerator.pathForMark(state) != nil && animated {
                let previousState = state
                animate(state, toState: nil, completion: { [weak self] in
                    self?.pathGenerator = newPathGenerator!
                    self?.resetLayersForState(previousState)
                    if self?.pathGenerator.pathForMark(previousState) != nil {
                        self?.animate(nil, toState: previousState)
                    }
                })
            } else if newPathGenerator?.pathForMark(state) != nil && animated {
                let previousState = state
                pathGenerator = newPathGenerator!
                resetLayersForState(nil)
                animate(nil, toState: previousState)
            } else {
                pathGenerator = newPathGenerator!
                resetLayersForState(state)
            }
            
            markType = type
        }
    }
    
    //----------------------------
    // MARK: - Layers
    //----------------------------
    
    /// The layers to display in the checkbox. The top layer is the last layer in the array.
    var layersToDisplay: [CALayer] {
        return []
    }
    
    //----------------------------
    // MARK: - Animations
    //----------------------------
    
    /**
     Animates the layers between the two states.
     - parameter fromState: The previous state of the checkbox.
     - parameter toState: The new state of the checkbox.
     */
    func animate(_ fromState: KPCheckBox.CheckState?, toState: KPCheckBox.CheckState?, completion: (() -> Void)? = nil) {
        if let toState = toState {
            state = toState
        }
    }
    
    //----------------------------
    // MARK: - Layout
    //----------------------------
    
    /// Layout the layers.
    func layoutLayers() {
        
    }
    
    //----------------------------
    // MARK: - Display
    //----------------------------
    
    /**
     Reset the layers to be in the given state.
     - parameter state: The new state of the checkbox.
     */
    func resetLayersForState(_ state: KPCheckBox.CheckState?) {
        if let state = state {
            self.state = state
        }
        layoutLayers()
    }
    
    
}
