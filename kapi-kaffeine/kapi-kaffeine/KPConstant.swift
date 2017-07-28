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

struct KPNotification {
    struct information {
        static let commentInformation = "commentInformation"
        static let rateInformation = "rateInformation"
    }
}

struct KPColorPalette {

    struct KPMainColor {
        static let mainColor_light = UIColor(hexString: "#c8955e")
        static let mainColor = UIColor(hexString: "#784d1f")
        static let mainColor_sub = UIColor(hexString: "#9f9426")
        static let statusBarColor = UIColor(hexString: "#784d1f")
        static let borderColor = UIColor(hexString: "#e6e6e6")
        static let starColor = UIColor(hexString: "#f9c816")
        static let warningColor = UIColor(hexString: "#FF5D5D")
        
        static let tempButtonCOlor = UIColor(hexString: "#4DA0D3")
        
        static let grayColor_level1 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 1.0)
        static let grayColor_level2 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.7)
        static let grayColor_level3 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.5)
        static let grayColor_level4 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.3)
        static let grayColor_level5 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.2)
        static let grayColor_level6 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.1)
        static let grayColor_level7 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.05)
        
        static let whiteColor_level1 = UIColor(hexString: "#ffffffaa")
    }
    
    struct KPTextColor {
        static let grayColor = UIColor(hexString: "#333333")
        static let mainColor_light = UIColor(hexString: "#c8955e")
        static let mainColor = UIColor(hexString: "#784d1f")
//        static let mainColor_light = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.5)
//        static let mainColor = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.7)
        static let whiteColor = UIColor(hexString: "#ffffff")
        static let warningColor = UIColor(hexString: "#FF5D5D")
        
        
        static let default_placeholder = UIColor(hexString: "#C7C7CD")
        static let grayColor_level1 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 1.0)
        static let grayColor_level2 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.7)
        static let grayColor_level3 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.5)
        static let grayColor_level4 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.3)
        static let grayColor_level5 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.2)
        static let grayColor_level6 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.1)
        static let grayColor_level7 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.05)
    }
    
    struct KPBackgroundColor {
        
        static let mainColor_light = UIColor(hexString: "#c8955e")
        static let mainColor_light_10 = UIColor(hexString: "#784d1f20")
        static let mainColor = UIColor(hexString: "#784d1f")
        static let mainColor_60 = UIColor(hexString: "#784d1f99")
        static let mainColor_20 = UIColor(hexString: "#784d1f33")
        static let mainColor_sub = UIColor(hexString: "#9f9426")
        
        static let cellScoreBgColor = UIColor(hexString: "#9f9426")
        static let scoreButtonColor = UIColor(hexString: "#9f9426")
        static let disabledScoreButtonColor = UIColor(hexString: "#C8C488")
        static let exp_background = UIColor(rgbaHexValue: 0xffffff33)
        
        static let mainColor_ripple = UIColor(rgbaHexValue: 0xc8955eaa)
        
        
        static let grayColor_level3 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.5)
        static let grayColor_level4 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.3)
        static let grayColor_level5 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.2)
        static let grayColor_level6 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.1)
        static let grayColor_level7 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.05)
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
    static let cancelLogInKey = "KPCancelLogInKey"
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
    
    var isSuperCompact: Bool {
        let size = UIScreen.main.bounds.size
        return size.width < 350 || size.height < 350
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

