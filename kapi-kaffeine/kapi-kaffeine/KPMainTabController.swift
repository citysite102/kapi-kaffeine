//
//  KPMainTabController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2018/1/24.
//  Copyright © 2018年 kapi-kaffeine. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class KPMainTabController: ESTabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        shouldHijackHandler = {
            tabbarController, viewController, index in
//            if index == 2 {
//                return true
//            }
            return false
        }
        
        didHijackHandler = {
            tabbarController, viewController, index in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.map_add_store_button)
                
                let controller = KPModalViewController()
                controller.edgeInset = UIEdgeInsets(top: 0,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0)
                let newStoreController = KPNewStoreController()
                let navigationController = UINavigationController(rootViewController: newStoreController)
                if #available(iOS 11.0, *) {
                    navigationController.navigationBar.prefersLargeTitles = true
                } else {
                    // Fallback on earlier versions
                }
                controller.contentController = navigationController
                controller.presentModalView()
            }
        }
        
        
        let exploreController = KPExplorationViewController()
//        let exploreItem = ESTabBarItem.init(KPBounceTabBarItem(),
//                                            title: nil,
//                                            image: R.image.icon_explore(),
//                                            selectedImage: R.image.icon_explore())
        let exploreItem = UITabBarItem(title: "",
                                       image: R.image.icon_explore(),
                                       selectedImage: R.image.icon_explore())
        exploreItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0)
        exploreItem.titlePositionAdjustment = UIOffset(horizontal: 40, vertical: 0)
        exploreController.tabBarItem = exploreItem
        
        
//        let navSearchController = KPSearchViewController()
//        let searchController = UINavigationController(rootViewController: navSearchController)
//
//        let searchItem = UITabBarItem(title: "搜尋",
//                                      image: R.image.icon_search(),
//                                      selectedImage: R.image.icon_search())
//        searchItem.imageInsets = UIEdgeInsetsMake(2, 2, 2, 2)
//        navSearchController.showDismissButton = false
//        searchController.tabBarItem = searchItem
        
        
//        let newStoreController = KPNewStoreController()
//        newStoreController.tabBarItem = ESTabBarItem(KPTabBarAddButton(),
//                                                     title: nil,
//                                                     image: R.image.tab_button_add(),
//                                                     selectedImage: R.image.tab_button_add(), tag: 2)
        
        let listItem = UITabBarItem(title: "",
                                    image: R.image.icon_listView(),
                                    selectedImage: R.image.icon_listView())
        listItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0)
        
        let listController = UIStoryboard.init(name: "Main",
                                               bundle: nil).instantiateViewController(withIdentifier: "mainViewController") as! KPMainViewController
        listController.tabBarItem = listItem
        
        let profileItem = UITabBarItem(title: "",
                                       image: R.image.icon_profile(),
                                       selectedImage: R.image.icon_profile())
        profileItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0)
        profileItem.titlePositionAdjustment = UIOffset(horizontal: -40, vertical: 0)
//        if (KPUserManager.sharedManager.currentUser != nil) {
        
            let profileController = KPUserProfileViewController()
            profileController.tabBarItem = profileItem
            viewControllers = [exploreController,
                               listController,
                               profileController]
//            viewControllers = [exploreController,
//                               searchController,
//                               newStoreController,
//                               listController,
//                               profileController]
//        } else {
//            let loginController = KPLoginViewController()
//            loginController.tabBarItem = profileItem
//            viewControllers = [exploreController,
//                               listController,
//                               loginController]
//            viewControllers = [exploreController,
//                               searchController,
//                               newStoreController,
//                               listController,
//                               loginController]
//        }
        setupDefaultUI()
    }
    
    func setupDefaultUI() {
        
        UITabBar.appearance().barTintColor = KPColorPalette.KPMainColor_v2.mainColor_bg
        UITabBar.appearance().unselectedItemTintColor = KPColorPalette.KPMainColor_v2.mainColor_unselect
        UITabBar.appearance().tintColor = KPColorPalette.KPMainColor_v2.mainColor_sub
        
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: KPColorPalette.KPTextColor_v2.mainColor_title!,
                                                                            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32)]
        } else {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: KPColorPalette.KPTextColor_v2.mainColor_title!,
                                                                       NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32)]
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
