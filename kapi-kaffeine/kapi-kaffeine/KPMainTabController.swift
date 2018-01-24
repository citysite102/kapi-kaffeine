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
        exploreController.tabBarItem = UITabBarItem(title: "探索",
                                                    image: R.image.icon_map(), selectedImage: R.image.icon_cup())
        
        let searchController = KPSearchViewController()
        searchController.tabBarItem = UITabBarItem(title: "搜尋",
                                                   image: R.image.icon_pic(), selectedImage: R.image.icon_cup())
        
        let newStoreController = KPNewStoreController()
        newStoreController.tabBarItem = ESTabBarItem(KPTabBarAddButton(),
                                                     title: nil,
                                                     image: R.image.tab_button_add(),
                                                     selectedImage: R.image.tab_button_add(), tag: 2)
        
        let listController = KPMainViewController()
        listController.tabBarItem = UITabBarItem(title: "清單",
                                                 image: R.image.icon_msg(), selectedImage: R.image.icon_cup())
        
        
        if (KPUserManager.sharedManager.currentUser != nil) {
            
            let profileController = KPUserProfileViewController()
            profileController.tabBarItem = UITabBarItem(title: "我的",
                                                        image: R.image.icon_door(), selectedImage: R.image.icon_cup())
            viewControllers = [exploreController,
                               searchController,
                               newStoreController,
                               listController,
                               profileController]
        } else {
            let loginController = KPLoginViewController()
            loginController.tabBarItem = UITabBarItem(title: "我的",
                                                        image: R.image.icon_door(), selectedImage: R.image.icon_cup())
            viewControllers = [exploreController,
                               searchController,
                               newStoreController,
                               listController,
                               loginController]
        }
        
        
        
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
