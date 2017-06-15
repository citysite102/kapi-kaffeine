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
        
        static let mainColor_top = UIColor(hexString: "D1A06B")
        static let mainColor_bottom = UIColor(hexString: "#A67037")
    }
    
    struct KPShopStatusColor {
        static let opened = UIColor(hexString: "#6dd551")
        static let closed = UIColor(hexString: "#f05e32")
    }
    
    struct KPTestHintColor {
        static let redHintColor = UIColor(hexString: "#ff0000")
    }
    
}

struct KPFactorConstant {
    struct KPSpacing {
        static let introSpacing: CGFloat = 2.4
    }
}

struct AppConstant {
    static let introShownKey = "KPIntroHasShownKey"
    static let userDefaultsSuitName = "kapi-userdefault"
}

extension UIDevice {

    var iPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    var isCompact: Bool {
        let size = UIScreen.main.bounds.size
        return size.width < 600 || size.height < 600
    }
    
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case unknown
    }
    var screenType: ScreenType {
        guard iPhone else { return .unknown }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        default:
            return .unknown
        }
    }
}

