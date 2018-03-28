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

    var exploreAnimationHasPerformed: Bool = false
    var shouldMapRefetch: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.setNeedsStatusBarAppearanceUpdate()
        
        let exploreController = KPExplorationViewController()
        exploreController.rootTabViewController = self
        
        let exploreItem = UITabBarItem(title: "",
                                       image: R.image.icon_explore(),
                                       selectedImage: R.image.icon_explore())
        exploreItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0)
        exploreItem.titlePositionAdjustment = UIOffset(horizontal: 40, vertical: 0)
        exploreController.tabBarItem = exploreItem
        
        let listItem = UITabBarItem(title: "",
                                    image: R.image.icon_listView(),
                                    selectedImage: R.image.icon_listView())
        listItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0)
        let listController = UIStoryboard.init(name: "Main",
                                               bundle: nil).instantiateViewController(withIdentifier: "mainViewController") as! KPMainViewController
        listController.tabBarItem = listItem
        listController.rootTabViewController = self
        
        let profileItem = UITabBarItem(title: "",
                                       image: R.image.icon_profile(),
                                       selectedImage: R.image.icon_profile())
        profileItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0)
        profileItem.titlePositionAdjustment = UIOffset(horizontal: -40, vertical: 0)
        
        let profileController = KPUserProfileViewController()
        profileController.tabBarItem = profileItem
        viewControllers = [exploreController,
                           listController,
                           profileController]

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
        
        setupDefaultUI()
    }
    
    func setupDefaultUI() {
        
        UITabBar.appearance().barTintColor = KPColorPalette.KPMainColor_v2.mainColor_bg
        UITabBar.appearance().unselectedItemTintColor = KPColorPalette.KPMainColor_v2.mainColor_unselect
        UITabBar.appearance().tintColor = KPColorPalette.KPMainColor_v2.mainColor_light
        
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: KPColorPalette.KPTextColor_v2.mainColor_title!,
                                                                            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32)]
        } else {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: KPColorPalette.KPTextColor_v2.mainColor_title!,
                                                                       NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32)]
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let fromView = tabBarController.selectedViewController?.view,
            let toView: UIView = viewController.view {
            
            if fromView == toView {
                return false
            }
            
            UIView.transition(from: fromView,
                              to: toView,
                              duration: 0.3,
                              options: .transitionCrossDissolve) { (_) in
                                
            }
        }
        
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
