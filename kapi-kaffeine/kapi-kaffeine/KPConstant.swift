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
        static let mainColor = UIColor(hexString: "#c8955e")
        static let buttonColor = UIColor(hexString: "#784d1f")
        static let statusBarColor = UIColor(hexString: "#784d1f")
        static let borderColor = UIColor(hexString: "#e6e6e6")
    }
    
    struct KPTextColor {
        static let cellNameColor = UIColor(hexString: "#333333")
        static let cellStatusColor = UIColor(hexString: "#212121")
        static let cellDistanceColor = UIColor(hexString: "#784d1f")
        static let whiteColor = UIColor(hexString: "#ffffff")
        static let grayColor = UIColor(hexString: "#333333")
    }
    
    struct KPBackgroundColor {
        static let cellScoreBgColor = UIColor(hexString: "#9f9426")
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
