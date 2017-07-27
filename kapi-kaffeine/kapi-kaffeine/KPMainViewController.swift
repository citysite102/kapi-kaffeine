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
import Alamofire

protocol KPMainViewControllerDelegate {
    var selectedDataModel: KPDataModel? { get }
}

public enum ControllerState {
    case normal
    case loading
    case noInternet
}

class KPMainViewController: KPViewController {

    var statusBarShouldBeHidden = false
    var searchHeaderView: KPSearchHeaderView!
    var sideBarController: KPSideViewController!
    var opacityView: UIView!
    var percentDrivenTransition: UIPercentDrivenInteractiveTransition!
    var mainListViewController: KPMainListViewController?
    var mainMapViewController: KPMainMapViewController?
    
    var transitionController: KPPhotoDisplayTransition = KPPhotoDisplayTransition()
    
    var displayDataModel: [KPDataModel]! {
        didSet {
//            if oldValue == nil {
                self.mainListViewController?.state = .loading
                self.mainListViewController?.tableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.mainListViewController?.displayDataModel = self.displayDataModel
                    self.mainMapViewController?.allDataModel = self.displayDataModel
                    self.searchHeaderView.styleButton.isEnabled = true
                    self.searchHeaderView.searchButton.isEnabled = true
                    self.searchHeaderView.menuButton.isEnabled = true
                    self.searchHeaderView.searchTagView.isUserInteractionEnabled = true
                    
                }
//            } else {
//                self.mainListViewController?.displayDataModel = self.displayDataModel
//                self.mainMapViewController?.allDataModel = self.displayDataModel
//                self.searchHeaderView.styleButton.isEnabled = true
//                self.searchHeaderView.searchButton.isEnabled = true
//                self.searchHeaderView.menuButton.isEnabled = true
//                self.searchHeaderView.searchTagView.isUserInteractionEnabled = true
//            }
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
        
        
        addChildViewController(mainListViewController!)
        view.addSubview((mainListViewController?.view)!)
        mainListViewController?.didMove(toParentViewController: self)
        mainListViewController?.view.layer.rasterizationScale = UIScreen.main.scale
        _ = mainListViewController?.view.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                          "V:|[$self]|"])
        
        
        addChildViewController(mainMapViewController!)
        view.addSubview((mainMapViewController?.view)!)
        mainMapViewController?.didMove(toParentViewController: self)
        mainMapViewController?.view.layer.rasterizationScale = UIScreen.main.scale
        _ = mainMapViewController?.view.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                         "V:|[$self]|"])

        currentController = mainMapViewController
        
        searchHeaderView = KPSearchHeaderView()
        searchHeaderView.searchButton.isEnabled = false
        searchHeaderView.menuButton.isEnabled = false
        searchHeaderView.styleButton.isEnabled = false
        searchHeaderView.searchTagView.isUserInteractionEnabled = false
        searchHeaderView.searchTagView.delegate = self
        view.addSubview(searchHeaderView)
        searchHeaderView.addConstraints(fromStringArray: ["V:|[$self(104)]",
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
        SideMenuManager.menuAnimationBackgroundColor = UIColor.black
        SideMenuManager.menuWidth = 260
        
        
        
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening()
        reachabilityManager?.listener = {
            status in
            if reachabilityManager?.isReachable ?? false {
                self.mainListViewController?.state =
                    self.mainListViewController?.state == .normal ? .normal : .loading
            } else {
                self.mainListViewController?.state = .noInternet
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchRemoteData),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        
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
        if !UserDefaults.standard.bool(forKey: AppConstant.introShownKey) {
            
            UserDefaults.standard.set(true,
                                      forKey: AppConstant.introShownKey)
            
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: 0,
                                                right: 0);
            let introController = KPIntroViewController()
            self.present(introController, animated: true, completion: nil)
            
        } else {
            if KPUserManager.sharedManager.currentUser == nil &&
                !UserDefaults.standard.bool(forKey: AppConstant.cancelLogInKey) {
                let controller = KPModalViewController()
                controller.edgeInset = UIEdgeInsets(top: 0,
                                                    left: 0,
                                                    bottom: 0,
                                                    right: 0);
                let loginController = KPLoginViewController()
                self.present(loginController, animated: true, completion: nil)
            }
        }
    }
    
    
    
    // MARK: Data
    
    func fetchRemoteData() {
        KPServiceHandler.sharedHandler.fetchRemoteData() { (results: [KPDataModel]?,
            error: NetworkRequestError?) in
            if results != nil {
                self.displayDataModel = results!
            } else if let requestError = error {
                switch requestError {
                    case .noNetworkConnection:
                        self.mainListViewController?.state = .noInternet
                    default:
                        print("錯誤萬歲: \(requestError)")
                }
            }
        }
        
        if (KPUserManager.sharedManager.currentUser != nil) {
            KPUserManager.sharedManager.updateUserInformation()
        }
        
        KPServiceHandler.sharedHandler.fetchTagList()
    }
    
    // MARK: UI Event
    
    func switchSideBar() {
        
        statusBarShouldBeHidden = true
        UIView.animate(withDuration: 0.1) {
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
        
        var transform   = CATransform3DMakeTranslation(0, 2, 0)
        transform.m34 = -1.0/1000
        
        self.mainListViewController?.snapShotShowing = true
        self.mainListViewController?.view.layer.transform = transform
        self.mainMapViewController?.view.layer.transform = transform
        
        
        if self.currentController == self.mainListViewController {
            mainListViewController?.view.alpha = 1.0
            mainMapViewController?.view.alpha = 0.0
            
            if !(self.mainMapViewController?.isCollectionViewShow)! {
                self.mainMapViewController?.collectionView.isHidden = true
            }
            self.mainMapViewController?.view.layer.transform =
                CATransform3DRotate((self.mainMapViewController?.view.layer.transform)!,
                                    CGFloat.pi, 0, 1, 0)
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            self.mainListViewController?.view.layer.transform =
                                CATransform3DScale(CATransform3DRotate(transform,
                                                                       CGFloat.pi/2,
                                                                       0,
                                                                       1,
                                                                       0)
                                    , 0.7
                                    , 0.7
                                    , 0.7)
                            self.mainMapViewController?.view.layer.transform =
                                CATransform3DScale(CATransform3DRotate(transform,
                                                                       -CGFloat.pi/2,
                                                                       0,
                                                                       1,
                                                                       0)
                                    , 0.7
                                    , 0.7
                                    , 0.7)
                            self.mainListViewController?.view.alpha = 0.2
            }, completion: { (_) in
                self.mainListViewController?.view.alpha = 0.0
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: {
                                self.searchHeaderView.styleButton.setImage(iconImage, for: .normal)
                                if !(self.mainMapViewController?.isCollectionViewShow)! {
                                    self.mainMapViewController?.collectionView.isHidden = true
                                }
                                
                                self.mainListViewController?.view.layer.transform =
                                    CATransform3DScale(CATransform3DRotate((self.mainMapViewController?.view.layer.transform)!,
                                                                           -CGFloat.pi/2, 0, 1, 0), 1/0.7, 1/0.7, 1/0.7)
                                
                                self.mainMapViewController?.view.layer.transform =
                                    CATransform3DScale(CATransform3DRotate((self.mainMapViewController?.view.layer.transform)!,
                                                                           CGFloat.pi/2, 0, 1, 0), 1/0.7, 1/0.7, 1/0.7)
                                
                                self.mainMapViewController?.view.alpha = 1.0
                }, completion: { (_) in
                    self.mainMapViewController?.collectionView.isHidden = false
                    self.currentController = self.mainMapViewController
                })
            })

        } else {
            mainListViewController?.view.alpha = 0.0
            mainMapViewController?.view.alpha = 1.0
            
            
            if !(self.mainMapViewController?.isCollectionViewShow)! {
                self.mainMapViewController?.collectionView.isHidden = true
            }
            self.mainListViewController?.view.layer.transform =
                CATransform3DRotate((self.mainListViewController?.view.layer.transform)!,
                                    CGFloat.pi, 0, 1, 0)
            
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            self.mainListViewController?.view.layer.transform =
                                CATransform3DScale(CATransform3DRotate(transform,
                                                                       CGFloat.pi/2,
                                                                       0,
                                                                       1,
                                                                       0)
                                    , 0.7
                                    , 0.7
                                    , 0.7)
                            self.mainMapViewController?.view.layer.transform =
                                CATransform3DScale(CATransform3DRotate(transform,
                                                                       -CGFloat.pi/2,
                                                                       0,
                                                                       1,
                                                                       0)
                                    , 0.7
                                    , 0.7
                                    , 0.7)
                            self.mainMapViewController?.view.alpha = 0.2
            }, completion: { (_) in
                self.mainMapViewController?.view.alpha = 0.0
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: {
                                self.searchHeaderView.styleButton.setImage(iconImage, for: .normal)
                                self.mainListViewController?.view.layer.transform =
                                    CATransform3DScale(CATransform3DRotate((self.mainListViewController?.view.layer.transform)!,
                                                                           -CGFloat.pi/2, 0, 1, 0), 1/0.7, 1/0.7, 1/0.7)
                                
                                self.mainMapViewController?.view.layer.transform =
                                    CATransform3DScale(CATransform3DRotate((self.mainMapViewController?.view.layer.transform)!,
                                                                           -CGFloat.pi/2, 0, 1, 0), 1/0.7, 1/0.7, 1/0.7)
                                
                                self.mainListViewController?.view.alpha = 1.0
                }, completion: { (_) in
                    self.mainListViewController?.snapShotShowing = false
                    self.mainMapViewController?.collectionView.isHidden = false
                    self.currentController = self.mainListViewController
                })
            })
        }
    }

    func search() {
        let controller = KPModalViewController()
        controller.edgeInset = UIEdgeInsets(top: 0,
                                            left: 0,
                                            bottom: 0,
                                            right: 0)
        controller.presentationStyle = .right
        let searchController = KPSearchViewController()
        searchController.displayDataModel = displayDataModel
        searchController.mainListController = mainListViewController
        let navigationController = UINavigationController(rootViewController: searchController)
        controller.contentController = navigationController
        controller.presentModalView()
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
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! KPInformationViewController
            
            toViewController.transitioningDelegate = self
            targetController.informationDataModel = (sender as! KPMainViewControllerDelegate).selectedDataModel
            
            addScreenEdgePanGestureRecognizer(view: toViewController.view, edges: .left)
        }
    }
    
}


//extension KPMainViewController: ImageTransitionProtocol {
//    
//    func tranisitionSetup(){
//        
//    }
//    
//    func tranisitionCleanup(){
//        
//    }
//    
//    func imageWindowFrame() -> CGRect{
//        let convertedRect = self.mainListViewController?.view.convert((self.mainListViewController?.currentSelectedCell?.shopImageView.frame)!,
//                                                                      from: (self.mainListViewController?.currentSelectedCell?.shopImageView)!)
//        return convertedRect!
//    }
//}


//extension KPMainViewController: UIViewControllerTransitioningDelegate {
//    
//    func animationController(forPresented presented: UIViewController,
//                             presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if let navigationController = presented as? UINavigationController {
//            if let informationViewcontroller = navigationController.viewControllers.first as? KPInformationViewController {
//                transitionController.setupImageTransition((self.mainListViewController?.currentSelectedCell?.shopImageView.image)!,
//                                                          fromDelegate: self,
//                                                          toDelegate: informationViewcontroller)
//                
//                return transitionController
//            } else {
//                return nil
//            }
//        } else {
//            return nil
//        }
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if let informationViewcontroller = dismissed as? KPInformationViewController {
//            transitionController.setupImageTransition((self.mainListViewController?.currentSelectedCell?.shopImageView.image)!,
//                                                      fromDelegate: informationViewcontroller,
//                                                      toDelegate: self)
//            return transitionController
//            
//        } else {
//            return nil
//        }
//    }
//}

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

extension KPMainViewController: KPSearchTagViewDelegate, KPSearchConditionViewControllerDelegate {
    
    func searchTagDidSelect(_ searchTag: searchTagType) {
        
        mainListViewController?.state = .loading
        mainListViewController?.tableView.reloadData()
        
        DispatchQueue.global().async {
            switch searchTag {
            case .wifi:
                KPFilter.sharedFilter.wifiRate = 5
            case .socket:
                KPFilter.sharedFilter.socket = 1
            case .limitTime:
                KPFilter.sharedFilter.limited_time = 1
            case .opening:
                KPFilter.sharedFilter.currentOpening = true
            case .highRate:
                KPFilter.sharedFilter.averageRate = 4.5
            }
            
            DispatchQueue.main.async {
                self.displayDataModel = KPFilter.sharedFilter.currentFilterCafeDatas()
            }
        }
    }
    
    func searchTagDidDeselect(_ searchTag: searchTagType) {
        
        mainListViewController?.state = .loading
        mainListViewController?.tableView.reloadData()
        
        DispatchQueue.global().async {
            switch searchTag {
            case .wifi:
                KPFilter.sharedFilter.wifiRate = 0
            case .socket:
                KPFilter.sharedFilter.socket = 4
            case .limitTime:
                KPFilter.sharedFilter.limited_time = 4
            case .opening:
                KPFilter.sharedFilter.currentOpening = false
            case .highRate:
                KPFilter.sharedFilter.averageRate = 0
            }
            
            let filteredData = KPFilter.sharedFilter.currentFilterCafeDatas()
            
            DispatchQueue.main.async {
                self.displayDataModel = filteredData
            }
        }
        
    }
    
    func searchConditionControllerDidSearch(_ searchConditionController: KPSearchConditionViewController) {
        
        mainListViewController?.state = .loading
        mainListViewController?.tableView.reloadData()
        
        
        
    
        // 各個 rating
        
        // Wifi
        KPFilter.sharedFilter.wifiRate  = Double(searchConditionController.ratingViews[0].currentRate)
        if KPFilter.sharedFilter.wifiRate >= 4, let index = self.searchHeaderView.searchTagView.headerTagContents.index(of: .wifi) {
            self.searchHeaderView.searchTagView.collectionView.selectItem(at: IndexPath.init(row: index, section: 0),
                                                                          animated: false,
                                                                          scrollPosition: [])
        } else if let index = self.searchHeaderView.searchTagView.headerTagContents.index(of: .wifi) {
            self.searchHeaderView.searchTagView.collectionView.deselectItem(at: IndexPath.init(row: index, section:0),
                                                                            animated: false)
        }
        
        KPFilter.sharedFilter.quietRate = Double(searchConditionController.ratingViews[1].currentRate)
        KPFilter.sharedFilter.cheapRate = Double(searchConditionController.ratingViews[2].currentRate)
        KPFilter.sharedFilter.seatRate = Double(searchConditionController.ratingViews[3].currentRate)
        KPFilter.sharedFilter.tastyRate = Double(searchConditionController.ratingViews[4].currentRate)
        KPFilter.sharedFilter.foodRate = Double(searchConditionController.ratingViews[5].currentRate)
        KPFilter.sharedFilter.musicRate = Double(searchConditionController.ratingViews[6].currentRate)
        
        
        
        
        // 時間
        if searchConditionController.businessCheckBoxOne.checkBox.checkState == .checked {
            // 不設定
            KPFilter.sharedFilter.currentOpening = false
            KPFilter.sharedFilter.searchTime = nil
            
            // 取消 營業中 的tag
            if let index = self.searchHeaderView.searchTagView.headerTagContents.index(of: .limitTime) {
                self.searchHeaderView.searchTagView.collectionView.deselectItem(at: IndexPath.init(row: index, section:0),
                                                                                animated: false)
            }
            
        } else if  searchConditionController.businessCheckBoxThree.checkBox.checkState == .checked {
            // 特定時段
            KPFilter.sharedFilter.currentOpening = false
            if let startTime = searchConditionController.timeSupplementView.startTime,
                let endTime = searchConditionController.timeSupplementView.endTime {
                KPFilter.sharedFilter.searchTime = "\(startTime)~\(endTime)"
            }
            
            // 取消 營業中 的tag
            if let index = self.searchHeaderView.searchTagView.headerTagContents.index(of: .limitTime) {
                self.searchHeaderView.searchTagView.collectionView.deselectItem(at: IndexPath.init(row: index, section:0),
                                                                                animated: false)
            }
            
        } else if searchConditionController.businessCheckBoxTwo.checkBox.checkState == .checked {
            // 目前營業中
            KPFilter.sharedFilter.currentOpening = true
            
            // 選取 營業中 的tag
            if let index = self.searchHeaderView.searchTagView.headerTagContents.index(of: .limitTime) {
                self.searchHeaderView.searchTagView.collectionView.selectItem(at: IndexPath.init(row: index, section: 0),
                                                                              animated: false,
                                                                              scrollPosition: [])
            }
        }
        
        
        KPFilter.sharedFilter.standingDesk = searchConditionController.othersCheckBoxOne.checkBox.checkState == .checked ? true : false
        
        
        // 更新選取tag的數量
        self.searchHeaderView.searchTagView.preferenceHintButton.hintCount =
        self.searchHeaderView.searchTagView.collectionView.indexPathsForSelectedItems?.count ?? 0
        
        DispatchQueue.global().async {
            let filteredData = KPFilter.sharedFilter.currentFilterCafeDatas()
            
            DispatchQueue.main.async {
                self.displayDataModel = filteredData
            }
        }
    }
    
}
