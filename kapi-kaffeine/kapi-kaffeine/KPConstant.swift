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


struct KPAnalyticsEvent {
    static let ads_click = "ads_click"
    // 紀錄點開來的店相關的屬性（可以知道哪間店被點開次數最多/評分，透過哪個管道）-->
    // 知道從哪一頁點進去的 Map/List/Search/Profile
    static let cell_click = "cell_click"
    // 頁面
    static let page_event = "page_event"
    // 按鈕
    static let button_click = "button_click"
}

struct KPAnalyticsEventProperty {
    static let name = "name"
    static let source = "source"
    static let store_name = "store_name"
    static let store_rate = "store_rate"
}

struct KPInfoMapping {
    static let citiesMapping = [
        "taipei" :"台北",
        "keelung" :"基隆",
        "taoyuan" :"桃園",
        "hsinchu" :"新竹",
        "yilan" :"宜蘭",
        "hualien" :"花蓮",
        "taitung" :"台東",
        "penghu" :"澎湖",
        "miaoli" :"苗栗",
        "taichung" :"台中",
        "nantou" :"南投",
        "changhua" :"彰化",
        "yunlin" :"雲林",
        "chiayi" :"嘉義",
        "tainan" :"台南",
        "kaohsiung" :"高雄",
        "pingtung" :"屏東"]
}

struct KPAnalyticsEventValue {
    
    static let unknown = "unknown"
    
    struct source {
        static let source_list = "list"
        static let source_map = "map"
        static let source_search = "search"
        static let source_profile = "profile"
        static let source_recommend = "recommend"
    }
    
    struct page {
        static let list_page = "list_page"
        static let map_page = "map_page"
        static let detail_page = "datail_page"
        static let search_page = "search_page"
        static let profile_page = "profile_page"
        static let setting_page = "setting_page"
        static let aboutus_page = "aboutus_page"
    }
    
    struct button {
        // Main
        static let main_menu_button = "main_menu_button"
        static let main_filter_button = "main_filter_button"
        static let main_fast_filter_button = "main_fast_filter_button"
        static let main_switch_mode_button = "main_switch_mode_button"
        static let main_search_button = "main_search_button"
        static let list_add_store_button = "list_add_store_button"
        static let map_add_store_button = "map_add_store_button"
        static let map_navigation_button = "map_navigation_button"
        static let map_near_button = "map_near_button"
        
        // New
        static let new_send_button = "new_send_button"
        static let new_dismiss_button = "new_dismiss_button"
        
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
        
        // Search
        static let condition_search_button = "condition_search_button"
    }
}

struct KPNotification {
    struct information {
        static let commentInformation = "commentInformation"
        static let rateInformation =    "rateInformation"
        static let photoInformation =   "photoInformation"
    }
}


struct KPFontSize {
    static let storeHeader: CGFloat = 32.0
    static let header: CGFloat = 24.0
    static let sub_header: CGFloat = 18.0
    static let mainContent: CGFloat = 16.0
    static let subContent: CGFloat = 14.0
    static let infoContent: CGFloat = 13.0
}
    
struct KPLayoutConstant {
    static let topBar_height = 64
    static let bottomBar_height = 56
    static let separator_height = 1
    
    static let dismissButton_size = 26
    static let information_horizontal_offset = 18
    static let intro_horizontal_offset = 32
    
}

struct KPColorPalette {

    struct KPMainColor_v2 {
        
        static let mainColor_light = UIColor(hexString: "#315384")
        static let mainColor = UIColor(hexString: "#2F3746")
        static let mainColor_sub = UIColor(hexString: "#0DB9A3")
        static let mainColor_dark = UIColor(hexString: "#202735")
        
        static let shadow_mainColor = UIColor(hexString: "#2F3746")
        static let shadow_darkColor = UIColor(hexString: "#111111")
        static let shadow_mainColor_black = UIColor(hexString: "#2F3746")
        
        static let mainColor_unselect = UIColor(hexString: "#CED8E6")
        static let mainColor_bg = UIColor(hexString: "#FCFCFC")

        static let starColor = UIColor(hexString: "#F4B635")
        static let collectedColor = UIColor(hexString: "#F4D23F")
        static let greenColor = UIColor(hexString: "#25AF76")
        static let redColor = UIColor(hexString: "#F86666")
        
        static let grayColor_level1 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.9)
        static let grayColor_level2 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.7)
        static let grayColor_level3 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.5)
        static let grayColor_level4 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.3)
        static let grayColor_level5 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.2)
        static let grayColor_level6 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.1)
        static let grayColor_level7 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.05)
        
        static let separator_color = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.05)
        
        static let whiteColor_level1 = UIColor(hexString: "#ffffffaa")
    }
    
    struct KPTextColor_v2 {
        static let mainColor_title = UIColor(hexString: "#3a3a3a")
        static let mainColor_subtitle = UIColor(hexString: "#545454")
        static let mainColor_description = UIColor(hexString: "#8a8a8a")
        static let mainColor_hint = UIColor(hexString: "#A8A8A8")
        static let mainColor_hint_light = UIColor(hexString: "#C8C8C8")
        
        static let yellow_color = UIColor(hexString: "#FFE453")
        static let whiteColor = UIColor(hexString: "#ffffff")
    }
    
    struct KPTextColor {
        static let grayColor = UIColor(hexString: "#333333")
        static let mainColor_light = UIColor(hexString: "#c8955e")
        static let mainColor = UIColor(hexString: "#784d1f")
        static let mainColor_60 = UIColor(hexString: "#784d1f99")
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
        
        static let whiteColor = UIColor(rgbaHexValue: 0xffffffff)
        static let whiteColor_alpha = UIColor(rgbaHexValue: 0xffffffaa)
        static let white_level1 = UIColor(white: 1.0, alpha: 0.95)
        static let white_level2 = UIColor(white: 1.0, alpha: 0.15)
        static let white_level3 = UIColor(white: 1.0, alpha: 0.15)
        
        static let grayColor_level1 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.9)
        static let grayColor_level2 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.7)
        static let grayColor_level3 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.5)
        static let grayColor_level4 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.3)
        static let grayColor_level5 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.2)
        static let grayColor_level5_5 = UIColor(r: 0.2, g: 0.2, b: 0.2, a: 0.15)
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

