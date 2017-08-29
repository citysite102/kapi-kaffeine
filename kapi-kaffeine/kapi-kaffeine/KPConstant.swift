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


struct KPAnalyticsEventPropertyKey {
    static let proeperty_name = "name"
    
    static let proeperty_source = "source"
    struct proeperty_source_value {
        static let source_list = "list"
        static let source_map = "map"
        static let source_search = "search"
        static let source_profile = "profile"
    }
}

struct KPAnalyticsEvent {
    
    static let ads_click = "ads_click"
    
    static let cell_event = "cell_event"
    // 紀錄點開來的店相關的屬性（可以知道哪間店被點開次數最多/評分，透過哪個管道）
    // --> 知道從哪一頁點進去的 Map/List/Search/Profile
    struct cellEventProperty {
        static let store_name = "store_name"
        static let store_rate = "store_rate"
        static let source = "source"
    }
    
    // 頁面
    static let page_event = "page_event"
    struct pageEventProperty {
        static let list_page = "list_page"
        static let map_page = "map_page"
        static let detail_page = "datail_page"
        static let search_page = "search_page"
        static let profile_page = "profile_page"
        static let setting_page = "setting_page"
        static let aboutus_page = "aboutus_page"
    }
    
    // 按鈕
    static let button_click = "button_click"
    struct buttonEventProperty {
        
        // Main
        static let main_menu_button = "main_menu_button"
        static let main_filter_button = "main_filter_button"
        static let main_fast_filter_button = "main_fast_filter_button"
        static let main_add_store_button = "main_add_store_button"
        static let main_switch_mode_button = "main_switch_mode_button"
        static let main_search_button = "main_search_button"
        static let map_navigation_button = "map_navigation_button"
        static let map_near_button = "map_near_button"
        
        // Store
        static let store_more_button = "store_more_button"
        static let store_favorite_button = "store_favorite_button"
        static let store_visit_button = "store_visit_button"
        static let store_rate_button = "store_rate_button"
        static let store_comment_button = "store_comment_button"
        static let store_streetview_button = "store_streetview_button"
        static let store_navigation_button = "store_navigation_button"
        
        // Quick Search
        static let quick_wifi_button = "quick_wifi_button"
        static let quick_socket_button = "quick_socket_button"
        static let quick_time_button = "quick_time_button"
        static let quick_open_button = "quick_open_button"
        static let quick_rate_button = "quick_rate_button"
        static let quick_clear_button = "quick_clear_button"
    }
}

struct KPNotification {
    struct information {
        static let commentInformation = "commentInformation"
        static let rateInformation =    "rateInformation"
        static let photoInformation =   "photoInformation"
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
        static let warningColor = UIColor(hexString: "#FF4040")
        
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
        static let mainColor_60 = UIColor(hexString: "#784d1f99")
//        static let mainColor_light = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.5)
//        static let mainColor = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.7)
        static let whiteColor = UIColor(hexString: "#ffffff")
        static let warningColor = UIColor(hexString: "#FF4040")
        
        
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
        
        static let grayColor_level2 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.7)
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

