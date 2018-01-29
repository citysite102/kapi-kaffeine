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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
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
//        let exploreItem = ESTabBarItem.init(ESTabBarItemContentView(),
//                                            title: nil,
//                                            image: R.image.icon_explore(),
//                                            selectedImage: R.image.icon_explore())
        let exploreItem = UITabBarItem(title: "探索",
                                       image: R.image.icon_explore(),
                                       selectedImage: R.image.icon_explore())
        exploreItem.imageInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        exploreController.tabBarItem = exploreItem
        
        let searchController = KPSearchViewController()
        let searchItem = UITabBarItem(title: "搜尋",
                                      image: R.image.icon_search(),
                                      selectedImage: R.image.icon_search())
        searchItem.imageInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        searchController.tabBarItem = searchItem
        
        let newStoreController = KPNewStoreController()
        newStoreController.tabBarItem = ESTabBarItem(KPTabBarAddButton(),
                                                     title: nil,
                                                     image: R.image.tab_button_add(),
                                                     selectedImage: R.image.tab_button_add(), tag: 2)
        
        let listController = UIStoryboard.init(name: "Main",
                                               bundle: nil).instantiateViewController(withIdentifier: "mainViewController") as! KPMainViewController
        listController.tabBarItem = UITabBarItem(title: "清單",
                                                 image: R.image.icon_listView(),
                                                 selectedImage: R.image.icon_listView())
        
        let profileItem = UITabBarItem(title: "我的",
                                       image: R.image.icon_profile(),
                                       selectedImage: R.image.icon_profile())
        profileItem.imageInsets = UIEdgeInsetsMake(2, 2, 2, 2)
        
        if (KPUserManager.sharedManager.currentUser != nil) {
            
            let profileController = KPUserProfileViewController()
            profileController.tabBarItem = profileItem
            viewControllers = [exploreController,
                               searchController,
                               newStoreController,
                               listController,
                               profileController]
        } else {
            let loginController = KPLoginViewController()
            loginController.tabBarItem = profileItem
            viewControllers = [exploreController,
                               searchController,
                               newStoreController,
                               listController,
                               loginController]
        }
        
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = KPColorPalette.KPMainColor_v2.textColor_level4
        UITabBar.appearance().tintColor = KPColorPalette.KPMainColor_v2.mainColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
