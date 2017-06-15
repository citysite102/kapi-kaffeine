//
//  KPMainViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import SideMenu
import PromiseKit

protocol KPMainViewControllerDelegate {
    var selectedDataModel: KPDataModel? { get }
}

class KPMainViewController: KPViewController {

    var statusBarShouldBeHidden = false
    var searchHeaderView: KPSearchHeaderView!
    var sideBarController: KPSideViewController!
    var opacityView: UIView!
    var percentDrivenTransition: UIPercentDrivenInteractiveTransition!
    var mainListViewController:KPMainListViewController?
    var mainMapViewController:KPMainMapViewController?
    
    var displayDataModel: [KPDataModel]! {
        didSet {
            self.mainListViewController?.displayDataModel = displayDataModel
            self.mainMapViewController?.displayDataModel = displayDataModel
        }
    }

    var currentController: KPViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        view.backgroundColor = UIColor.black
        mainListViewController = KPMainListViewController()
        mainMapViewController = KPMainMapViewController()
        sideBarController = KPSideViewController()
        sideBarController.mainController = self
        
        mainListViewController!.mainController = self
        mainMapViewController!.mainController = self
        
        addChildViewController(mainMapViewController!)
        view.addSubview((mainMapViewController?.view)!)
        mainMapViewController?.didMove(toParentViewController: self)
        _ = mainMapViewController?.view.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                         "V:|[$self]|"])
        
        addChildViewController(mainListViewController!)
        view.addSubview((mainListViewController?.view)!)
        mainListViewController?.didMove(toParentViewController: self)
        _ = mainListViewController?.view.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                          "V:|[$self]|"])
        
        currentController = mainListViewController
        
        searchHeaderView = KPSearchHeaderView()
        view.addSubview(searchHeaderView)
        searchHeaderView.addConstraints(fromStringArray: ["V:|[$self(100)]",
                                                               "H:|[$self]|"])
        
        opacityView = UIView()
        opacityView.backgroundColor = UIColor.black
        opacityView.alpha = 0.0
        opacityView.isHidden = true
        view.addSubview(opacityView)
        opacityView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                          "H:|[$self]|"])
        
        searchHeaderView.menuButton.addTarget(self,
                                              action: #selector(switchSideBar),
                                              for: .touchUpInside)
        searchHeaderView.styleButton.addTarget(self,
                                               action: #selector(changeStyle),
                                               for: .touchUpInside)
        searchHeaderView.searchButton.addTarget(self,
                                                action: #selector(search),
                                                for: .touchUpInside)
        
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: sideBarController)
        menuLeftNavigationController.leftSide = true
        
        
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.menuPresentMode = .menuSlideIn
        SideMenuManager.menuFadeStatusBar = false
        SideMenuManager.menuShadowOpacity = 0.6
        SideMenuManager.menuShadowRadius = 3
        SideMenuManager.menuAnimationFadeStrength = 0.5
        SideMenuManager.menuAnimationTransformScaleFactor = 0.98
        SideMenuManager.menuAnimationBackgroundColor = UIColor.black
        SideMenuManager.menuWidth = 260
        
        if (KPUserManager.sharedManager.currentUser != nil) {
            KPServiceHandler.sharedHandler.fetchRemoteData() { (results: [KPDataModel]) in
                self.displayDataModel = results
            }
        }

    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = self.mainListViewController!.tableView.indexPathForSelectedRow {
            self.mainListViewController!.tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 使用者第一次使用
        if UserDefaults.standard.object(forKey: AppConstant.introShownKey) == nil {
            
            UserDefaults.standard.set(true,
                                      forKey: AppConstant.introShownKey)
            
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets.init(top: 0,
                                                     left: 0,
                                                     bottom: 0,
                                                     right: 0);
            let introController = KPIntroViewController()
            self.present(introController, animated: true, completion: nil)
            
        } else {
            if KPUserManager.sharedManager.currentUser == nil {
                let controller = KPModalViewController()
                controller.edgeInset = UIEdgeInsets.init(top: 0,
                                                         left: 0,
                                                         bottom: 0,
                                                         right: 0);
                let loginController = KPLoginViewController()
                self.present(loginController, animated: true, completion: nil)
            }
        }
        
        
    }
    
    func switchSideBar() {
        
        statusBarShouldBeHidden = true
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        self.opacityView.isHidden = false
        present(SideMenuManager.menuLeftNavigationController!,
                animated: true, completion: nil)
    }
    
    func changeStyle() {
        let iconImage = (self.currentController == self.mainListViewController) ?
            R.image.icon_list()!.withRenderingMode(.alwaysTemplate) :
            R.image.icon_map()!.withRenderingMode(.alwaysTemplate)
        
        var transform   = CATransform3DIdentity
        transform.m34 = -1.0/1000
        
        
        self.mainListViewController?.view.layer.shouldRasterize = true
        self.mainMapViewController?.view.layer.shouldRasterize = true
        
        if self.currentController == self.mainListViewController {
            
            let rightRotateTransform = CATransform3DRotate(transform,
                                                           CGFloat.pi/2,
                                                           0,
                                                           1,
                                                           0)
            
            self.mainListViewController?.view.alpha = 1.0
            self.mainMapViewController?.view.alpha = 0.0
            
            UIView.animateKeyframes(withDuration: 0.8,
                                    delay: 0,
                                    options: .calculationModeCubicPaced,
                                    animations: { 
                                        UIView.addKeyframe(withRelativeStartTime: 0,
                                                           relativeDuration: 0.4,
                                                           animations: { 
                                                            self.mainListViewController?.view.layer.transform =
                                                                CATransform3DScale(rightRotateTransform
                                                                    , 0.8
                                                                    , 0.8
                                                                    , 0.8)
                                                            self.mainMapViewController?.view.layer.transform =
                                                                CATransform3DScale(rightRotateTransform
                                                                    , 0.8
                                                                    , 0.8
                                                                    , 0.8)
                                                            self.mainListViewController?.view.alpha = 0.0
                                                            self.mainMapViewController?.view.alpha = 0.5
                                        })
                                        
                                        UIView.addKeyframe(withRelativeStartTime: 0.4,
                                                           relativeDuration: 0.6,
                                                           animations: { 
                                                            self.currentController = self.mainMapViewController
                                                            
                                                            self.searchHeaderView.styleButton.setImage(iconImage, for: .normal)
                                                            self.mainMapViewController?.collectionView.isHidden = true
                                                            
//                                                            self.mainListViewController?.view.layer.transform =
//                                                                CATransform3DRotate((self.mainListViewController?.view.layer.transform)!,
//                                                                                    CGFloat.pi, 0, 1, 0)
//                                                            self.mainMapViewController?.view.layer.transform =
//                                                                CATransform3DRotate((self.mainMapViewController?.view.layer.transform)!,
//                                                                                    CGFloat.pi, 0, 1, 0)
                                                            
                                                            let backRotateTransform = CATransform3DRotate((self.mainMapViewController?.view.layer.transform)!, -CGFloat.pi/2, 0, 1, 0)
                                                            self.mainListViewController?.view.layer.transform =
                                                                CATransform3DScale(backRotateTransform, 1/0.8, 1/0.8, 1/0.8)
                                                            
                                                            self.mainMapViewController?.view.layer.transform =
                                                                CATransform3DScale(backRotateTransform, 1/0.8, 1/0.8, 1/0.8)
                                                            
                                                            self.mainMapViewController?.view.alpha = 1.0
                                        })
            }, completion: { (_) in
                self.mainListViewController?.view.layer.shouldRasterize = false
                self.mainMapViewController?.view.layer.shouldRasterize = false
                self.mainMapViewController?.collectionView.isHidden = false
            })

        } else {
            let leftRotateTransform = CATransform3DRotate(transform,
                                                          -CGFloat.pi/2,
                                                          0,
                                                          1,
                                                          0)
            
            self.mainListViewController?.view.alpha = 0.0
            self.mainMapViewController?.view.alpha = 1.0
            
            UIView.animateKeyframes(withDuration: 0.8,
                                    delay: 0,
                                    options: .calculationModeCubicPaced,
                                    animations: {
                                        UIView.addKeyframe(withRelativeStartTime: 0,
                                                           relativeDuration: 0.4,
                                                           animations: {
                                                            self.mainListViewController?.view.layer.transform =
                                                                CATransform3DScale(leftRotateTransform
                                                                    , 0.8
                                                                    , 0.8
                                                                    , 0.8)
                                                            self.mainMapViewController?.view.layer.transform =
                                                                CATransform3DScale(leftRotateTransform
                                                                    , 0.8
                                                                    , 0.8
                                                                    , 0.8)
                                                            self.mainListViewController?.view.alpha = 0.5
                                                            self.mainMapViewController?.view.alpha = 0.0
                                        })
                                        
                                        UIView.addKeyframe(withRelativeStartTime: 0.4,
                                                           relativeDuration: 0.6,
                                                           animations: {
                                                            self.currentController = self.mainListViewController
                                                            
                                                            self.searchHeaderView.styleButton.setImage(iconImage, for: .normal)
                                                            self.mainMapViewController?.collectionView.isHidden = true

                                                            self.mainListViewController?.view.layer.transform =
                                                                CATransform3DRotate((self.mainListViewController?.view.layer.transform)!,
                                                                                    -CGFloat.pi, 0, 1, 0)
                                                            self.mainMapViewController?.view.layer.transform =
                                                                CATransform3DRotate((self.mainMapViewController?.view.layer.transform)!,
                                                                                    -CGFloat.pi, 0, 1, 0)
                                                            
                                                            let backRotateTransform =
                                                                CATransform3DRotate((self.mainMapViewController?.view.layer.transform)!, -CGFloat.pi/2, 0, 1, 0)
                                                            self.mainListViewController?.view.layer.transform =
                                                                CATransform3DScale(backRotateTransform, 1/0.8, 1/0.8, 1/0.8)
                                                            
                                                            self.mainMapViewController?.view.layer.transform =
                                                                CATransform3DScale(backRotateTransform, 1/0.8, 1/0.8, 1/0.8)
                                                            
                                                            self.mainListViewController?.view.alpha = 1.0
                                        })
            }, completion: { (_) in
                self.mainListViewController?.view.layer.shouldRasterize = false
                self.mainMapViewController?.view.layer.shouldRasterize = false
                self.mainMapViewController?.collectionView.isHidden = false
            })
        }
    }

    func search() {
        let controller = KPModalViewController()
        controller.edgeInset = UIEdgeInsets.init(top: 0,
                                                 left: 0,
                                                 bottom: 0,
                                                 right: 0)
        controller.presentationStyle = .right
        let searchController = KPSearchViewController()
        searchController.displayDataModel = displayDataModel
        searchController.mainListController = mainListViewController
        let navigationController = UINavigationController.init(rootViewController: searchController)
        controller.contentController = navigationController
        controller.presentModalView()
        
        
//        let controller = KPModalViewController()
//        controller.edgeInset = UIEdgeInsets.init(top: 0,
//                                                 left: 0,
//                                                 bottom: 0,
//                                                 right: 0)
//        let loadingController = KPLoadingViewController()
//        controller.contentController = loadingController
//        controller.presentModalView()
        
    }
    
    func addScreenEdgePanGestureRecognizer(view: UIView, edges: UIRectEdge) {
        let edgePanGesture =
            UIScreenEdgePanGestureRecognizer(target: self,
                                             action: #selector(edgePanGesture(edgePanGesture:)))
        edgePanGesture.edges = edges
        view.addGestureRecognizer(edgePanGesture)
    }
    
    func edgePanGesture(edgePanGesture: UIScreenEdgePanGestureRecognizer) {
        
        let progress = edgePanGesture.translation(in: self.view).x / self.view.bounds.width
        
        if edgePanGesture.state == UIGestureRecognizerState.began {
            self.percentDrivenTransition = UIPercentDrivenInteractiveTransition()
                            if edgePanGesture.edges == UIRectEdge.left {
                self.dismiss(animated: true, completion: nil)
            }
        } else if edgePanGesture.state == UIGestureRecognizerState.changed {
            self.percentDrivenTransition.update(progress/4)
        } else if edgePanGesture.state == UIGestureRecognizerState.cancelled || edgePanGesture.state == UIGestureRecognizerState.ended {
            if progress > 0.5 {
                self.percentDrivenTransition.finish()
            } else {
                self.percentDrivenTransition.cancel()
            }
            self.percentDrivenTransition = nil
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "datailedInformationSegue" {
            let toViewController = segue.destination as UIViewController
            toViewController.transitioningDelegate = self
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! KPInformationViewController
            targetController.informationDataModel = (sender as! KPMainViewControllerDelegate).selectedDataModel
            
            self.addScreenEdgePanGestureRecognizer(view: toViewController.view, edges: .left)
        }
    }
    
}

extension KPMainViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return KPInformationTranstion()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return KPInformationDismissTransition()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) ->
        UIViewControllerInteractiveTransitioning? {
            return self.percentDrivenTransition
    }
}
