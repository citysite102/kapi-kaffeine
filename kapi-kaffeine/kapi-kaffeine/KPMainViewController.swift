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
    case barLoading
    case noInternet
    case failed
}

class KPMainViewController: KPViewController {

    var statusBarShouldBeHidden = false
    var searchHeaderView: KPSearchHeaderView!
    var statusContainer: UIView!
    var statusLabel: UILabel!
    var loadingIndicator: UIActivityIndicatorView!
    var reFetchTapGesture: UITapGestureRecognizer!
    var sideBarController: KPSideViewController!
    var opacityView: UIView!
    var percentDrivenTransition: UIPercentDrivenInteractiveTransition!
    var mainListViewController: KPMainListViewController?
    var mainMapViewController: KPMainMapViewController?
    weak var rootTabViewController: KPMainTabController!
    
    var transitionController: KPPhotoDisplayTransition = KPPhotoDisplayTransition()
    var currentController: KPViewController!
    
    private var displayDataModel: [KPDataModel]!

    func setDisplayDataModel(_ dataModels: [KPDataModel]!, _ animated: Bool!) {
        
        displayDataModel = dataModels
        
        if animated {
            mainListViewController?.state = .loading
            mainMapViewController?.state = .loading
            mainListViewController?.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.mainListViewController?.displayDataModel = self.displayDataModel
                self.mainMapViewController?.allDataModel = self.displayDataModel
                self.searchHeaderView.styleButton.isEnabled = true
                self.searchHeaderView.searchButton.isEnabled = true
                self.searchHeaderView.menuButton.isEnabled = true
                self.searchHeaderView.searchTagView.isUserInteractionEnabled = true
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.mainListViewController?.displayDataModel = self.displayDataModel
                self.mainMapViewController?.allDataModel = self.displayDataModel
                self.searchHeaderView.searchTagView.isUserInteractionEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        mainListViewController = KPMainListViewController()
        mainMapViewController = KPMainMapViewController()
        sideBarController = KPSideViewController()
        sideBarController.mainController = self
        
        mainListViewController!.mainController = self
        mainMapViewController!.mainController = self
        
        currentController = mainListViewController
        
        addChildViewController(mainMapViewController!)
        view.addSubview((mainMapViewController?.view)!)
        mainMapViewController?.didMove(toParentViewController: self)
        mainMapViewController?.view.layer.rasterizationScale = UIScreen.main.scale
        mainMapViewController?.showAllButton.addTarget(self,
                                                       action: #selector(showAllLocation),
                                                       for: .touchUpInside)
        _ = mainMapViewController?.view.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                         "V:|[$self]|"])
        
        addChildViewController(mainListViewController!)
        view.addSubview((mainListViewController?.view)!)
        mainListViewController?.didMove(toParentViewController: self)
        mainListViewController?.view.layer.rasterizationScale = UIScreen.main.scale
        _ = mainListViewController?.view.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                          "V:|[$self]|"])

        
        searchHeaderView = KPSearchHeaderView()
        searchHeaderView.searchTagView.isUserInteractionEnabled = false
        searchHeaderView.searchTagView.delegate = self
        view.addSubview(searchHeaderView)
        searchHeaderView.addConstraints(fromStringArray: ["V:|[$self]",
                                                          "H:|[$self]|"])
        
        searchHeaderView?.filterButton.addTarget(self,
                                                 action: #selector(handlePreferenceButtonOnTapped),
                                                              for: .touchUpInside)
        
        mainListViewController?.mapButton.button.addTarget(self,
                                                           action: #selector(changeStyle),
                                                              for: .touchUpInside)
        mainMapViewController?.mapButton.button.addTarget(self,
                                                          action: #selector(changeStyle),
                                                          for: .touchUpInside)
        
        statusContainer = UIView()
        statusContainer.isHidden = true
        statusContainer.alpha = 0.0
        statusContainer.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level3
        view.addSubview(statusContainer)
        statusContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:[$view0][$self]"],
                                       views:[searchHeaderView])
        
        statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        statusLabel.textColor = UIColor.white
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.setText(text: "啊啊啊，似乎發生了一些問題｡ﾟヽ(ﾟ´Д`)ﾉﾟ｡\n點擊重新抓取資料",
                            lineSpacing: 3.0)
        statusContainer.addSubview(statusLabel)
        statusLabel.addConstraints(fromStringArray: ["V:|-8-[$self]-8-|",
                                                     "H:|-16-[$self]-16-|"])
        
        loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        statusContainer.addSubview(loadingIndicator)
        loadingIndicator.addConstraintForCenterAligningToSuperview(in: .vertical)
        loadingIndicator.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        reFetchTapGesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(handleStatusContainerOnTapped(_:)))
        statusContainer.addGestureRecognizer(reFetchTapGesture)
        
        
        opacityView = UIView()
        opacityView.backgroundColor = UIColor.black
        opacityView.alpha = 0.0
        opacityView.isHidden = true
        view.addSubview(opacityView)
        opacityView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
        
//        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: sideBarController)
//        menuLeftNavigationController.leftSide = true
//        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
//        SideMenuManager.menuPresentMode = .menuSlideIn
//        SideMenuManager.menuFadeStatusBar = false
//        SideMenuManager.menuShadowOpacity = 0.6
//        SideMenuManager.menuShadowRadius = 3
//        SideMenuManager.menuAnimationFadeStrength = 0.5
//        SideMenuManager.menuAnimationBackgroundColor = UIColor.black
//        SideMenuManager.menuWidth = 260
        
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening()
        reachabilityManager?.listener = {
            status in
            if reachabilityManager?.isReachable ?? false {
                self.mainListViewController?.state =
                    self.mainListViewController?.state == .normal ? .normal : .loading
                self.mainMapViewController?.state =
                    self.mainMapViewController?.state == .normal ? .normal : .loading
                UIView.animate(withDuration: 0.15,
                               animations: { 
                                self.statusContainer.alpha = 0.0
                }, completion: { (_) in
                    self.statusContainer.isHidden = true
                })
            } else {
                self.mainListViewController?.state = .noInternet
                self.mainMapViewController?.state = .noInternet
                self.searchHeaderView.searchTagView.isUserInteractionEnabled = false
                self.statusContainer.isHidden = false
                UIView.animate(withDuration: 0.15,
                               animations: {
                                self.statusContainer.alpha = 1.0
                })
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchRemoteData),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(windowDidBecomeVisible(_:)),
                                               name: NSNotification.Name.UIWindowDidBecomeVisible,
                                               object: nil)
        
    }
    
    @objc func windowDidBecomeVisible(_ notification:Notification){
        
        let window = notification.object as! UIWindow
        let windows = UIApplication.shared.windows
        
        print("\nwindow目前總數：\(windows.count)")
        print("Become Visible資訊：\(window)")
        print("windowLevel數值：\(window.windowLevel)\n")
    }
    
    @objc func handlePreferenceButtonOnTapped() {
        let controller = KPModalViewController()
        controller.edgeInset = UIEdgeInsets.init(top: 0,
                                                 left: 0,
                                                 bottom: 0,
                                                 right: 0)
        let preferenceController = KPPreferenceSearchViewController()
        let navigationController = UINavigationController.init(rootViewController: preferenceController)
        preferenceController.delegate = self
        
        controller.contentController = navigationController
        controller.presentModalView()
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
//        if !UserDefaults.standard.bool(forKey: AppConstant.introShownKey) {
//
//            UserDefaults.standard.set(true,
//                                      forKey: AppConstant.introShownKey)
//
//            let controller = KPModalViewController()
//            controller.edgeInset = UIEdgeInsets(top: 0,
//                                                left: 0,
//                                                bottom: 0,
//                                                right: 0);
//            let introController = KPIntroViewController()
//            self.present(introController, animated: true, completion: nil)
//        } else {
//            if KPUserManager.sharedManager.currentUser == nil &&
//                !UserDefaults.standard.bool(forKey: AppConstant.cancelLogInKey) {
//                let controller = KPModalViewController()
//                controller.edgeInset = UIEdgeInsets(top: 0,
//                                                    left: 0,
//                                                    bottom: 0,
//                                                    right: 0);
//                let loginController = KPLoginViewController()
//                self.present(loginController, animated: true, completion: nil)
//            }
//        }
    }
    
    
    // MARK: Data
    
    @objc func fetchRemoteData() {
        let rightTop = mainMapViewController?.mapView.projection.visibleRegion().farRight
        let leftBottom = mainMapViewController?.mapView.projection.visibleRegion().nearLeft
        KPServiceHandler.sharedHandler.fetchRemoteData(nil,
                                                       nil,
                                                       nil,
                                                       nil,
                                                       nil,
                                                       rightTop,
                                                       leftBottom,
                                                       nil) { (results, error) in
            DispatchQueue.main.async {
                if results != nil {
                    self.setDisplayDataModel(KPFilter.sharedFilter.currentFilterCafeDatas(),
                                             false)
                    self.updateStatusContainerState(true, nil)
                } else if let requestError = error {
                    self.updateStatusContainerState(false, nil)
                    switch requestError {
                        case .noNetworkConnection:
                            self.mainListViewController?.state = .noInternet
                            self.mainMapViewController?.state = .noInternet
                        default:
                            self.mainMapViewController?.state = .failed
                            print("錯誤萬歲: \(requestError)")
                    }
                }
            }
        }
        
        if (KPUserManager.sharedManager.currentUser != nil) {
            KPUserManager.sharedManager.updateUserInformation()
        }
        
        KPServiceHandler.sharedHandler.fetchTagList()
    }
    
    func reFetchRemoteData(_ showLoading: Bool? = true) {
        mainListViewController?.state = showLoading! ? .loading : .barLoading
        mainListViewController?.tableView.reloadData()
        mainMapViewController?.state = showLoading! ? .loading : .barLoading
        fetchRemoteData()
    }
    
    // MARK: UI Event
    
    func updateStatusContainerState(_ hidden: Bool,
                                    _ completion: (() -> Swift.Void)?) {
        if hidden {
            self.statusLabel.alpha = 1.0
            self.searchHeaderView.searchTagView.isUserInteractionEnabled = true
            self.loadingIndicator.stopAnimating()
            UIView.animate(withDuration: 0.15,
                           animations: { 
                            self.statusContainer.alpha = 0.0
            }, completion: { (_) in
                self.statusContainer.isHidden = true
                completion?()
            })
        } else {
            self.searchHeaderView.searchTagView.isUserInteractionEnabled = false
            self.statusContainer.isHidden = false
            self.statusLabel.alpha = 1.0
            self.loadingIndicator.stopAnimating()
            UIView.animate(withDuration: 0.15,
                           animations: {
                            self.statusContainer.alpha = 1.0
            }, completion: { (_) in
                self.statusContainer.isUserInteractionEnabled = true
                completion?()
            })
        }
    }
    
    @objc func handleStatusContainerOnTapped(_ sender: UITapGestureRecognizer) {
        statusContainer.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       animations: { 
                        self.statusLabel.alpha = 0.0
        }) { (_) in
            self.loadingIndicator.startAnimating()
            self.reFetchRemoteData()
        }
    }
    
    @objc func switchSideBar() {
        
        KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.main_menu_button)
        
        statusBarShouldBeHidden = true
        UIView.animate(withDuration: 0.1) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
        opacityView.isHidden = false
        present(SideMenuManager.default.menuLeftNavigationController!,
                animated: true, completion: nil)
    }
    
    @objc func changeStyle() {
        
        KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.main_switch_mode_button)
        
        let iconImage = (self.currentController == self.mainListViewController) ?
            R.image.icon_list()!.withRenderingMode(.alwaysTemplate) :
            R.image.icon_map()!.withRenderingMode(.alwaysTemplate)
//        self.mainListViewController?.snapShotShowing = true
        
        if self.currentController == self.mainListViewController {
            mainListViewController?.view.alpha = 1.0
            mainMapViewController?.view.alpha = 0.0
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            self.mainListViewController?.view.alpha = 0
            }, completion: { (_) in
                self.mainListViewController?.view.alpha = 0.0
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: {
                                self.mainMapViewController?.view.alpha = 1
                }, completion: { (_) in
                    self.currentController = self.mainMapViewController
                })
            })
            
        } else {
            mainListViewController?.view.alpha = 0.0
            mainMapViewController?.view.alpha = 1.0
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            self.mainMapViewController?.view.alpha = 0
            }, completion: { (_) in
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               options: .curveEaseOut,
                               animations: {
                                self.mainListViewController?.view.alpha = 1.0
                }, completion: { (_) in
                    self.mainListViewController?.snapShotShowing = false
                    self.currentController = self.mainListViewController
                })
            })
        }
        
        
//        let iconImage = (self.currentController == self.mainListViewController) ?
//            R.image.icon_list()!.withRenderingMode(.alwaysTemplate) :
//            R.image.icon_map()!.withRenderingMode(.alwaysTemplate)
//
//        var transform   = CATransform3DMakeTranslation(0, 2, 0)
//        transform.m34 = -1.0/1000
//
//        self.mainListViewController?.snapShotShowing = true
//        self.mainListViewController?.view.layer.transform = transform
//        self.mainMapViewController?.view.layer.transform = transform
//
//
//        if self.currentController == self.mainListViewController {
//            mainListViewController?.view.alpha = 1.0
//            mainMapViewController?.view.alpha = 0.0
//
//            if !(self.mainMapViewController?.isCollectionViewShow)! {
//                self.mainMapViewController?.collectionView.isHidden = true
//            }
//            self.mainMapViewController?.view.layer.transform =
//                CATransform3DRotate((self.mainMapViewController?.view.layer.transform)!,
//                                    CGFloat.pi, 0, 1, 0)
//
//            UIView.animate(withDuration: 0.5,
//                           delay: 0,
//                           options: .curveEaseIn,
//                           animations: {
//                            self.mainListViewController?.view.layer.transform =
//                                CATransform3DScale(CATransform3DRotate(transform,
//                                                                       CGFloat.pi/2,
//                                                                       0,
//                                                                       1,
//                                                                       0)
//                                    , 0.7
//                                    , 0.7
//                                    , 0.7)
//                            self.mainMapViewController?.view.layer.transform =
//                                CATransform3DScale(CATransform3DRotate(transform,
//                                                                       -CGFloat.pi/2,
//                                                                       0,
//                                                                       1,
//                                                                       0)
//                                    , 0.7
//                                    , 0.7
//                                    , 0.7)
//                            self.mainListViewController?.view.alpha = 0.2
//            }, completion: { (_) in
//                self.mainListViewController?.view.alpha = 0.0
//                UIView.animate(withDuration: 0.5,
//                               delay: 0,
//                               options: .curveEaseOut,
//                               animations: {
//                                self.searchHeaderView.styleButton.setImage(iconImage, for: .normal)
//                                if !(self.mainMapViewController?.isCollectionViewShow)! {
//                                    self.mainMapViewController?.collectionView.isHidden = true
//                                }
//
//                                self.mainListViewController?.view.layer.transform =
//                                    CATransform3DScale(CATransform3DRotate((self.mainMapViewController?.view.layer.transform)!,
//                                                                           -CGFloat.pi/2, 0, 1, 0), 1/0.7, 1/0.7, 1/0.7)
//
//                                self.mainMapViewController?.view.layer.transform =
//                                    CATransform3DScale(CATransform3DRotate((self.mainMapViewController?.view.layer.transform)!,
//                                                                           CGFloat.pi/2, 0, 1, 0), 1/0.7, 1/0.7, 1/0.7)
//
//                                self.mainMapViewController?.view.alpha = 1.0
//                }, completion: { (_) in
//                    self.mainMapViewController?.collectionView.isHidden = false
//                    self.currentController = self.mainMapViewController
//                })
//            })
//
//        } else {
//            mainListViewController?.view.alpha = 0.0
//            mainMapViewController?.view.alpha = 1.0
//
//
//            if !(self.mainMapViewController?.isCollectionViewShow)! {
//                self.mainMapViewController?.collectionView.isHidden = true
//            }
//            self.mainListViewController?.view.layer.transform =
//                CATransform3DRotate((self.mainListViewController?.view.layer.transform)!,
//                                    CGFloat.pi, 0, 1, 0)
//
//
//            UIView.animate(withDuration: 0.5,
//                           delay: 0,
//                           options: .curveEaseIn,
//                           animations: {
//                            self.mainListViewController?.view.layer.transform =
//                                CATransform3DScale(CATransform3DRotate(transform,
//                                                                       CGFloat.pi/2,
//                                                                       0,
//                                                                       1,
//                                                                       0)
//                                    , 0.7
//                                    , 0.7
//                                    , 0.7)
//                            self.mainMapViewController?.view.layer.transform =
//                                CATransform3DScale(CATransform3DRotate(transform,
//                                                                       -CGFloat.pi/2,
//                                                                       0,
//                                                                       1,
//                                                                       0)
//                                    , 0.7
//                                    , 0.7
//                                    , 0.7)
//                            self.mainMapViewController?.view.alpha = 0.2
//            }, completion: { (_) in
//                self.mainMapViewController?.view.alpha = 0.0
//                UIView.animate(withDuration: 0.5,
//                               delay: 0,
//                               options: .curveEaseOut,
//                               animations: {
//                                self.searchHeaderView.styleButton.setImage(iconImage, for: .normal)
//                                self.mainListViewController?.view.layer.transform =
//                                    CATransform3DScale(CATransform3DRotate((self.mainListViewController?.view.layer.transform)!,
//                                                                           -CGFloat.pi/2, 0, 1, 0), 1/0.7, 1/0.7, 1/0.7)
//
//                                self.mainMapViewController?.view.layer.transform =
//                                    CATransform3DScale(CATransform3DRotate((self.mainMapViewController?.view.layer.transform)!,
//                                                                           -CGFloat.pi/2, 0, 1, 0), 1/0.7, 1/0.7, 1/0.7)
//
//                                self.mainListViewController?.view.alpha = 1.0
//                }, completion: { (_) in
//                    self.mainListViewController?.snapShotShowing = false
//                    self.mainMapViewController?.collectionView.isHidden = false
//                    self.currentController = self.mainListViewController
//                })
//            })
//        }
    }

    @objc func search() {
        
        KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.main_search_button)
        
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
    
    @objc func showAllLocation() {
        
        searchHeaderView.searchTagView.deselectAllSearchTag()
        mainListViewController?.state = .loading
        mainMapViewController?.state = .loading
        mainMapViewController?.showAllButton.isHidden = true
        mainListViewController?.tableView.reloadData()
        KPFilter.sharedFilter.restoreDefaultSettings()
        searchHeaderView.searchTagView.preferenceHintButton.hintCount = 0
        
        DispatchQueue.main.async {
            self.setDisplayDataModel(KPFilter.sharedFilter.currentFilterCafeDatas(),
                                     true)
        }
    }
    
    func addScreenEdgePanGestureRecognizer(view: UIView, edges: UIRectEdge) {
        let edgePanGesture =
            UIScreenEdgePanGestureRecognizer(target: self,
                                             action: #selector(edgePanGesture(edgePanGesture:)))
        edgePanGesture.edges = edges
        view.addGestureRecognizer(edgePanGesture)
    }
    
    @objc func edgePanGesture(edgePanGesture: UIScreenEdgePanGestureRecognizer) {
        
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

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return KPInformationTranstion()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let navigationController = dismissed as? UINavigationController {
            if let informationViewcontroller = navigationController.viewControllers.first as? KPInformationViewController {
                if informationViewcontroller.dismissWithDefaultType {
                    
                    let transition = KPInformationDismissTransition()
                    transition.defaultDimissed = true
                    
                    return transition
                }
            }
        }
        
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
        mainMapViewController?.state = .loading
        mainMapViewController?.showAllButton.isHidden = false
        mainListViewController?.tableView.reloadData()
        
        DispatchQueue.global().async {
            switch searchTag {
            case .wifi:
                KPFilter.sharedFilter.wifiRate = 5
                KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.quick_wifi_button)
            case .socket:
                KPFilter.sharedFilter.socket = 1
                KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.quick_socket_button)
            case .limitTime:
                KPFilter.sharedFilter.limited_time = 2
                KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.quick_time_button)
            case .opening:
                KPFilter.sharedFilter.currentOpening = true
                KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.quick_open_button)
            case .highRate:
                KPFilter.sharedFilter.averageRate = 4
                KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.quick_rate_button)
            case .clear:
                self.mainMapViewController?.showAllButton.isHidden = true
                KPAnalyticManager.sendButtonClickEvent(KPAnalyticsEventValue.button.quick_clear_button)
                KPFilter.sharedFilter.restoreDefaultSettings()
            }
            
            DispatchQueue.main.async {
                self.setDisplayDataModel(KPFilter.sharedFilter.currentFilterCafeDatas(), true)
            }
        }
    }
    
    func searchTagDidDeselect(_ searchTag: searchTagType) {
        
        mainListViewController?.state = .loading
        mainMapViewController?.state = .loading
        mainMapViewController?.showAllButton.isHidden = (searchHeaderView.searchTagView.preferenceHintButton.hintCount == 0)
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
            case .clear:
                break
            }
            
            let filteredData = KPFilter.sharedFilter.currentFilterCafeDatas()
            
            DispatchQueue.main.async {
                self.setDisplayDataModel(filteredData, true)
            }
        }
        
    }
    
    func searchConditionControllerDidSearch(_ searchConditionController: KPPreferenceSearchViewController) {
        
        mainListViewController?.state = .loading
        mainMapViewController?.state = .loading
        mainMapViewController?.showAllButton.isHidden = false
        mainListViewController?.tableView.reloadData()
  
        // 各個 rating
        
        if searchConditionController.sortSegmentedControl.selectedSegmentIndex == 0 {
            KPFilter.sharedFilter.sortedby = .distance
        } else if searchConditionController.sortSegmentedControl.selectedSegmentIndex == 1 {
            KPFilter.sharedFilter.sortedby = .rates
        }
        
        
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
        
        
//        KPFilter.sharedFilter.limited_time = (searchConditionController.timeRadioBoxOne.groupValue as! Int)
//        KPFilter.sharedFilter.socket = (searchConditionController.socketRadioBoxOne.groupValue as! Int)
        
        if let index = self.searchHeaderView.searchTagView.headerTagContents.index(of: .limitTime) {
            if KPFilter.sharedFilter.limited_time == 2 {
                self.searchHeaderView.searchTagView.collectionView.selectItem(at: IndexPath.init(row: index, section: 0),
                                                                              animated: false,
                                                                              scrollPosition: [])
            } else {
                self.searchHeaderView.searchTagView.collectionView.deselectItem(at: IndexPath.init(row: index, section: 0),
                                                                                animated: false)
            }
        }
    
        if let index = self.searchHeaderView.searchTagView.headerTagContents.index(of: .socket) {
            if KPFilter.sharedFilter.socket == 1 {
                self.searchHeaderView.searchTagView.collectionView.selectItem(at: IndexPath.init(row: index, section: 0),
                                                                              animated: false,
                                                                              scrollPosition: [])
            } else {
                self.searchHeaderView.searchTagView.collectionView.deselectItem(at: IndexPath.init(row: index, section: 0),
                                                                                animated: false)
            }
        }
        
        
        // 時間
//        if searchConditionController.businessCheckBoxOne.checkBox.checkState == .checked {
//            // 不設定
//            KPFilter.sharedFilter.currentOpening = false
//            KPFilter.sharedFilter.searchTime = nil
//
//            // 取消 營業中 的tag
//            if let index = self.searchHeaderView.searchTagView.headerTagContents.index(of: .opening) {
//                self.searchHeaderView.searchTagView.collectionView.deselectItem(at: IndexPath.init(row: index, section:0),
//                                                                                animated: false)
//            }
//
//        } else if  searchConditionController.businessCheckBoxThree.checkBox.checkState == .checked {
//            // 特定時段
//            KPFilter.sharedFilter.currentOpening = false
//            if let startTime = searchConditionController.timeSupplementView.startTime,
//                let endTime = searchConditionController.timeSupplementView.endTime {
//                KPFilter.sharedFilter.searchTime = "\(startTime)~\(endTime)"
//            }
//
//            // 取消 營業中 的tag
//            if let index = self.searchHeaderView.searchTagView.headerTagContents.index(of: .opening) {
//                self.searchHeaderView.searchTagView.collectionView.deselectItem(at: IndexPath.init(row: index, section:0),
//                                                                                animated: false)
//            }
//
//        } else if searchConditionController.businessCheckBoxTwo.checkBox.checkState == .checked {
//            // 目前營業中
//            KPFilter.sharedFilter.currentOpening = true
//
//            // 選取 營業中 的tag
//            if let index = self.searchHeaderView.searchTagView.headerTagContents.index(of: .opening) {
//                self.searchHeaderView.searchTagView.collectionView.selectItem(at: IndexPath.init(row: index, section: 0),
//                                                                              animated: false,
//                                                                              scrollPosition: [])
//            }
//        }
//
        
//        KPFilter.sharedFilter.standingDesk = searchConditionController.othersCheckBoxOne.checkBox.checkState == .checked ? true : false
        
        
        // 更新選取tag的數量
        self.searchHeaderView.searchTagView.preferenceHintButton.hintCount =
        self.searchHeaderView.searchTagView.collectionView.indexPathsForSelectedItems?.count ?? 0
        
        DispatchQueue.global().async {
            let filteredData = KPFilter.sharedFilter.currentFilterCafeDatas()
            
            DispatchQueue.main.async {
                self.setDisplayDataModel(filteredData, true)
            }
        }
    }
    
}
