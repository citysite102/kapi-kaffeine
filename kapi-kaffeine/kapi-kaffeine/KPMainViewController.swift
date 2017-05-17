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

    var searchHeaderView: KPSearchHeaderView!
    var sideBarController: KPSideViewController!
    var opacityView: UIView!
    var percentDrivenTransition: UIPercentDrivenInteractiveTransition!;
    var mainListViewController:KPMainListViewController?
    var mainMapViewController:KPMainMapViewController?
    
    var displayDataModel: [KPDataModel]! {
        didSet {
            self.mainListViewController?.displayDataModel = displayDataModel
            self.mainMapViewController?.displayDataModel = displayDataModel
        }
    }

    var currentController: KPViewController! {
        didSet {
            
            if oldValue != nil {
                oldValue?.willMove(toParentViewController: nil);
                oldValue?.view.removeFromSuperview();
                oldValue?.removeFromParentViewController();
            }
            
            self.addChildViewController(currentController!);
            self.view.addSubview((self.currentController?.view)!);
            currentController.didMove(toParentViewController: self);
            currentController.view.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"]);
            
            if (self.searchHeaderView != nil) {
                self.view.bringSubview(toFront: self.searchHeaderView)
                self.view.bringSubview(toFront: self.opacityView)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.mainListViewController = KPMainListViewController();
        self.mainMapViewController = KPMainMapViewController();
        self.sideBarController = KPSideViewController();
        self.sideBarController.mainController = self;
        
        self.mainListViewController!.mainController = self;
        self.mainMapViewController!.mainController = self;
        
        self.currentController = self.mainListViewController;
        
        self.searchHeaderView = KPSearchHeaderView();
        self.view.addSubview(searchHeaderView);
        self.searchHeaderView.addConstraints(fromStringArray: ["V:|[$self(100)]",
                                                               "H:|[$self]|"])
        
        self.opacityView = UIView();
        self.opacityView.backgroundColor = UIColor.black;
        self.opacityView.alpha = 0.5;
        self.opacityView.isHidden = true;
        self.view.addSubview(self.opacityView);
        self.opacityView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                          "H:|[$self]|"]);
        
        self.searchHeaderView.menuButton.addTarget(self,
                                                   action: #selector(switchSideBar),
                                                   for: .touchUpInside)
        self.searchHeaderView.styleButton.addTarget(self,
                                                    action: #selector(changeStyle),
                                                    for: .touchUpInside)
        self.searchHeaderView.searchButton.addTarget(self,
                                                     action: #selector(search),
                                                        for: .touchUpInside)
        
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: sideBarController);
        menuLeftNavigationController.leftSide = true;
        
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.menuPresentMode = .menuSlideIn;
        SideMenuManager.menuFadeStatusBar = false;
        SideMenuManager.menuAnimationTransformScaleFactor = 0.96;
        SideMenuManager.menuAnimationBackgroundColor = UIColor.black;
        SideMenuManager.menuWidth = 260;
        
        
        let KapiDataRequest = KPNomadRequest();
        KapiDataRequest.perform().then { resultArray -> Void in
                self.displayDataModel = resultArray
            }.catch { error in
                print("Error");
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        if let indexPath = self.mainListViewController!.tableView.indexPathForSelectedRow {
            self.mainListViewController!.tableView.deselectRow(at: indexPath, animated: false);
        }
    }
    
    func switchSideBar() {
        DispatchQueue.main.async(execute: {
            if let window = UIApplication.shared.keyWindow {
                window.windowLevel = UIWindowLevelStatusBar + 1
            }
        })
        self.opacityView.isHidden = false;
        present(SideMenuManager.menuLeftNavigationController!,
                animated: true, completion: nil)
    }
    
    func changeStyle() {
        let iconImage = (self.currentController == self.mainListViewController) ?
            R.image.icon_list()!.withRenderingMode(.alwaysTemplate) :
            R.image.icon_map()!.withRenderingMode(.alwaysTemplate);
        
        self.currentController = (self.currentController == self.mainListViewController) ?
            self.mainMapViewController :
            self.mainListViewController;
        self.searchHeaderView.styleButton.setImage(iconImage, for: .normal);
    }

    func search() {
//        let controller = KPModalViewController()
//        controller.edgeInset = UIEdgeInsets.init(top: 0,
//                                                 left: 0,
//                                                 bottom: 0,
//                                                 right: 0);
//        controller.presentationStyle = .right
//        let searchController = KPSearchViewController()
//        searchController.displayDataModel = displayDataModel
//        searchController.mainListController = mainListViewController
//        let navigationController = UINavigationController.init(rootViewController: searchController);
//        controller.contentController = navigationController;
//        controller.presentModalView();
        let controller = KPModalViewController()
        controller.edgeInset = UIEdgeInsets.init(top: 0,
                                                 left: 0,
                                                 bottom: 0,
                                                 right: 0);
        let loadingController = KPLoadingViewController()
        controller.contentController = loadingController;
        controller.presentModalView();
    }
    
    func addScreenEdgePanGestureRecognizer(view: UIView, edges: UIRectEdge) {
        let edgePanGesture =
            UIScreenEdgePanGestureRecognizer(target: self,
                                             action: #selector(edgePanGesture(edgePanGesture:)))
        edgePanGesture.edges = edges;
        view.addGestureRecognizer(edgePanGesture)
    }
    
    func edgePanGesture(edgePanGesture: UIScreenEdgePanGestureRecognizer) {
        
        let progress = edgePanGesture.translation(in: self.view).x / self.view.bounds.width;
        if edgePanGesture.state == UIGestureRecognizerState.began {
            self.percentDrivenTransition = UIPercentDrivenInteractiveTransition();
                            if edgePanGesture.edges == UIRectEdge.left {
                self.dismiss(animated: true, completion: nil);
            }
        } else if edgePanGesture.state == UIGestureRecognizerState.changed {
            self.percentDrivenTransition.update(progress/4);
        } else if edgePanGesture.state == UIGestureRecognizerState.cancelled || edgePanGesture.state == UIGestureRecognizerState.ended {
            if progress > 0.5 {
                self.percentDrivenTransition.finish();
            } else {
                self.percentDrivenTransition.cancel();
            }
            self.percentDrivenTransition = nil;
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
            
            self.addScreenEdgePanGestureRecognizer(view: toViewController.view, edges: .left);
        }
    }
    
}

extension KPMainViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return KPInformationTranstion();
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return KPInformationDismissTransition();
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) ->
        UIViewControllerInteractiveTransitioning? {
            return self.percentDrivenTransition;
    }
}
