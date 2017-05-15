//
//  KPConstant.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import UIKit
import BenzeneFoundation

struct KPColorPalette {

    struct KPMainColor {
        static let mainColor_light = UIColor(hexString: "#c8955e")
        static let mainColor = UIColor(hexString: "#784d1f")
        static let statusBarColor = UIColor(hexString: "#784d1f")
        static let borderColor = UIColor(hexString: "#e6e6e6")
        static let starColor = UIColor(hexString: "#f9c816")
        
        
        static let grayColor_level1 = UIColor.init(r: 0.2, g: 0.2, b: 0.2, a: 1.0)
        static let grayColor_level2 = UIColor.init(r: 0.2, g: 0.2, b: 0.2, a: 0.7)
        static let grayColor_level3 = UIColor.init(r: 0.2, g: 0.2, b: 0.2, a: 0.5)
        static let grayColor_level4 = UIColor.init(r: 0.2, g: 0.2, b: 0.2, a: 0.3)
        static let grayColor_level5 = UIColor.init(r: 0.2, g: 0.2, b: 0.2, a: 0.2)
        static let grayColor_level6 = UIColor.init(r: 0.2, g: 0.2, b: 0.2, a: 0.1)
        static let grayColor_level7 = UIColor.init(r: 0.2, g: 0.2, b: 0.2, a: 0.05)
    }
    
    struct KPTextColor {
        static let grayColor = UIColor(hexString: "#333333")
        static let mainColor_light = UIColor(hexString: "#c8955e")
        static let mainColor = UIColor(hexString: "#784d1f")
        static let whiteColor = UIColor(hexString: "#ffffff")
        
        static let grayColor_level1 = UIColor.init(r: 0.2, g: 0.2, b: 0.2, a: 1.0)
        static let grayColor_level2 = UIColor.init(r: 0.2, g: 0.2, b: 0.2, a: 0.7)
        static let grayColor_level3 = UIColor.init(r: 0.2, g: 0.2, b: 0.2, a: 0.5)
        static let grayColor_level4 = UIColor.init(r: 0.2, g: 0.2, b: 0.2, a: 0.3)
        static let grayColor_level5 = UIColor.init(r: 0.2, g: 0.2, b: 0.2, a: 0.2)
        static let grayColor_level6 = UIColor.init(r: 0.2, g: 0.2, b: 0.2, a: 0.1)
    }
    
    struct KPBackgroundColor {
        static let cellScoreBgColor = UIColor(hexString: "#9f9426")
        
        static let scoreButtonColor = UIColor(hexString: "#9f9426")
        static let disabledScoreButtonColor = UIColor(hexString: "#C8C488")
    }
    
    struct KPShopStatusColor {
        static let opened = UIColor(hexString: "#6dd551")
        static let closed = UIColor(hexString: "#f05e32")
    }
    
    struct KPTestHintColor {
        static let redHintColor = UIColor(hexString: "#ff0000")
    }
    
    
//    struct Gray {
//        static let Light = UIColor(white: 0.8374, alpha: 1.0)
//        static let Medium = UIColor(white: 0.4756, alpha: 1.0)
//        static let Dark = UIColor(white: 0.2605, alpha: 1.0)
//    }
}
