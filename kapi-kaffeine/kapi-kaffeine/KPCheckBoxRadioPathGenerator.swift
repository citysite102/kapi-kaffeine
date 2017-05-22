//
//  KPCheckBoxRadioPathGenerator.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/5.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import UIKit

class KPCheckBoxRadioPathGenerator: KPCheckBoxPathGenerator {
    
    override func pathForMark() -> UIBezierPath? {
        let transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        let translate = CGAffineTransform(translationX: size * 0.2, y: size * 0.2)
        let path = pathForBox()
        path?.apply(transform)
        path?.apply(translate)
        return path
    }
    
    override func pathForLongMark() -> UIBezierPath? {
        return pathForBox()
    }
    
    override func pathForMixedMark() -> UIBezierPath? {
        return pathForMark()
    }
    
    override func pathForLongMixedMark() -> UIBezierPath? {
        return pathForBox()
    }
    
    override func pathForUnselectedMark() -> UIBezierPath? {
        return nil
    }
    
    override func pathForLongUnselectedMark() -> UIBezierPath? {
        return nil
    }
}
