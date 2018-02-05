//
//  KPMainListViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import AlamofireImage
import ObjectMapper
import PromiseKit
import GoogleMobileAds

class KPMainListViewController:
    KPViewController,
    KPMainViewControllerDelegate {
    
    struct Constant {
        static let KPMainListViewCellReuseIdentifier = "cell"
        static let KPMainListViewAddCellReuseIdentifier = "cell_add"
        static let KPMainListViewLoadingCellReuseIdentifier = "cell_loading"
        static let KPMainListViewAdCellReuseIdentifier = "cell_ad"
        static let adInterval = 12
        static let concurrentAdsCount = 8
        static let adViewHeight = CGFloat(135)
    }
    
    weak var mainController: KPMainViewController!
    
    var statusContainerView: UIView!
    var statusErrorImageView: UIImageView!
    var statusErrorDescriptionLabel: UILabel!
    var statusErrorButton: KPLoadingButton!
    
    var sortContainerView: UIView!
    var sortLabel: UILabel!
    var sortIcon: UIImageView!
    var actionController: UIAlertController!
    var tableView: UITableView!
    var satisficationView: KPSatisficationView!
    var expNotificationView: KPExpNotificationView!
    var adLoader: GADAdLoader!
    var oldScrollOffsetY: CGFloat = 80.0
    var currentSearchTagTranslateY: CGFloat = 0.0
    var currentDataModel: KPDataModel?
    var currentSelectedCell: KPMainListTableViewCell?
    var state: ControllerState! = .loading
    {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if state == .noInternet {
                statusContainerView.isHidden = false
                tableView.isHidden = true
            } else if state == .normal {
                statusContainerView.isHidden = true
                tableView.isHidden = false
            } else if state == .loading {
                statusContainerView.isHidden = true
                tableView.isHidden = false
            } else if state == .barLoading {
                statusContainerView.isHidden = true
                tableView.isHidden = false
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
    }

    lazy var mapButton: KPShadowButton = {
        let shadowButton = KPShadowButton()
        shadowButton.button.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.whiteColor!), for: .normal)
        shadowButton.button.setImage(R.image.icon_map(), for: .normal)
        shadowButton.button.setTitle("地圖",
                                     for: .normal)
        shadowButton.button.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor,
                                          for: .normal)
        shadowButton.button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        shadowButton.button.tintColor = KPColorPalette.KPMainColor_v2.mainColor
        shadowButton.button.imageView?.contentMode = .scaleAspectFit
        shadowButton.button.imageEdgeInsets = UIEdgeInsets(top: 8,
                                                           left: 8,
                                                           bottom: 8,
                                                           right: 16)
        shadowButton.layer.cornerRadius = 20
        return shadowButton
    }()
    
    
    // Ads
    var adsAdded: Bool = false
    var snapShotShowing: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.snapShotShowing != oldValue && self.snapShotShowing {
                    self.snapshotView.image = self.tableView.screenshotForVisible()
                    self.snapshotView.isHidden = false
                    self.tableView.isHidden = true
                } else if self.snapShotShowing != oldValue {
                    self.snapshotView.isHidden = true
                    self.tableView.isHidden = (self.state == .noInternet ? true : false)
                }
            }
        }
    }
    
    var snapshotView: UIImageView!
    var selectedDataModel: KPDataModel? {
        return currentDataModel
    }
    
    var displayDataModel: [AnyObject] = [AnyObject]() {
        didSet {
            if state == .noInternet {
                self.dismissStatusErrorContent({ 
                    self.state = .normal
                })
            } else {
                state = .normal
                if let displayModel = displayDataModel.first as? KPDataModel, displayModel.identifier != "empty" {
                    let emptyModel = KPDataModel(JSON: ["cafe_id": "empty"])
                    displayDataModel.insert(emptyModel!, at: 0)
                }
                self.tableView.isUserInteractionEnabled = true
                self.tableView.allowsSelection = true
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if !adsAdded {
                    self.addNativeExpressAds()
                }
            }
        }
    }
    
    var adsToLoad: [GADNativeExpressAdView] = [GADNativeExpressAdView]()
    var adsLoaded: [GADNativeExpressAdView] = [GADNativeExpressAdView]()
    var loadStateForAds = [GADNativeExpressAdView: Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KPAnalyticManager.sendPageViewEvent(KPAnalyticsEventValue.page.list_page)
        
        view.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        
        statusContainerView = UIView()
        statusContainerView.backgroundColor = UIColor.white
        view.addSubview(statusContainerView)
        statusContainerView.addConstraints(fromStringArray: ["V:|-120-[$self]|",
                                                             "H:|[$self]|"])
        
        statusErrorImageView = UIImageView(image: R.image.image_sorry())
        statusContainerView.addSubview(statusErrorImageView)
        statusErrorImageView.addConstraint(forHeight: 130)
        statusErrorImageView.contentMode = .scaleAspectFit
        statusErrorImageView.addConstraintForCenterAligningToSuperview(in: .horizontal, constant: 4)
        statusErrorImageView.addConstraintForCenterAligningToSuperview(in: .vertical, constant: -88)
        
        
        statusErrorDescriptionLabel = UILabel()
        statusErrorDescriptionLabel.font = UIFont.systemFont(ofSize: 16.0)
        statusErrorDescriptionLabel.numberOfLines = 0
        statusErrorDescriptionLabel.textColor = KPColorPalette.KPTextColor.mainColor
        statusErrorDescriptionLabel.textAlignment = .center
        statusContainerView.addSubview(statusErrorDescriptionLabel)
        statusErrorDescriptionLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        statusErrorDescriptionLabel.addConstraints(fromStringArray: ["V:[$view0]-20-[$self]",
                                                                     "H:[$self(200)]"],
                                                   views: [statusErrorImageView])
        statusErrorDescriptionLabel.setText(text: "被你發現了！網路好像有點問題耶...",
                                            lineSpacing: 3.0)
        
        statusErrorButton = KPLoadingButton(image: nil, title: "再試試")
        statusErrorButton.setTitleColor(UIColor.white, for: .normal)
        statusErrorButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.mainColor!),
                                        for: .normal)
        statusErrorButton.layer.cornerRadius = 3.0
        statusErrorButton.layer.masksToBounds = true
        statusErrorButton.replaceText = true
        statusErrorButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        statusErrorButton.addTarget(self,
                                    action: #selector(KPMainListViewController.handleStatusErrorButtonOnTapped),
                                    for: .touchUpInside)
        statusContainerView.addSubview(statusErrorButton)
        statusErrorButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        statusErrorButton.addConstraints(fromStringArray: ["V:[$view0]-72-[$self(36)]",
                                                           "H:[$self(160)]"],
                                         views: [statusErrorImageView])
        
        sortContainerView = UIView()
        sortContainerView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        view.addSubview(sortContainerView)
        sortContainerView.addConstraints(fromStringArray: ["V:|-140-[$self(32)]",
                                                           "H:|[$self]|"])
        
        let sortTapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(handleSortOptionTapped))
        sortContainerView.addGestureRecognizer(sortTapGesture)
        
        sortLabel = UILabel()
        sortLabel.font = UIFont.boldSystemFont(ofSize: 13.0)
        sortLabel.text = "依照距離排列"
        sortLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor
        sortContainerView.addSubview(sortLabel)
        sortLabel.addConstraints(fromStringArray: ["H:|-12-[$self]"])
        sortLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        sortIcon = UIImageView(image: R.image.icon_sort()!)
        sortIcon.tintColor = KPColorPalette.KPMainColor_v2.mainColor
        sortContainerView.addSubview(sortIcon)
        sortIcon.addConstraints(fromStringArray: ["H:[$view0]-4-[$self(12)]",
                                                  "V:[$self(12)]"], views: [sortLabel])
        sortIcon.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        actionController = UIAlertController(title: nil,
                                             message: nil,
                                             preferredStyle: .actionSheet)
        let sortDistance = UIAlertAction(title: "依照距離排列",
                                         style: .default) { (_) in
                                            self.sortLabel.text = "依照距離排列"
        }
        
        let sortRate = UIAlertAction(title: "依照評分排列",
                                        style: .default) {(_) in
                                            self.sortLabel.text = "依照評分排列"
        }
        
        let cancelButton = UIAlertAction(title: "取消",
                                         style: .destructive) { (_) in
                                            print("取消")
        }
        
        actionController.addAction(sortDistance)
        actionController.addAction(sortRate)
        actionController.addAction(cancelButton)
        
        
        
        tableView = UITableView()
        tableView.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = false
        tableView.separatorColor = UIColor.clear
        tableView.delaysContentTouches = false
        view.addSubview(tableView)
        tableView.addConstraints(fromStringArray: ["V:[$view0][$self]-(-40)-|",
                                                   "H:|[$self]|"],
                                 views:[sortContainerView])
        tableView.register(KPMainListAddCell.self,
                           forCellReuseIdentifier: Constant.KPMainListViewAddCellReuseIdentifier
                           )
        tableView.register(KPMainListTableViewCell.self,
                                forCellReuseIdentifier: Constant.KPMainListViewCellReuseIdentifier)
        tableView.register(KPDefaultLoadingTableCell.self,
                                forCellReuseIdentifier: Constant.KPMainListViewLoadingCellReuseIdentifier)
        tableView.register(KPMainListNativeExpressCell.self,
                                forCellReuseIdentifier: Constant.KPMainListViewAdCellReuseIdentifier)
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        
        snapshotView = UIImageView()
        snapshotView.contentMode = .top
        snapshotView.clipsToBounds = true
        snapshotView.isHidden = true
        view.addSubview(snapshotView)
        snapshotView.addConstraints(fromStringArray: ["V:[$view0][$self]-(-40)-|",
                                                      "H:|[$self]|"],
                                    views:[sortContainerView])

        view.addSubview(mapButton)
        mapButton.addConstraints(fromStringArray: ["V:[$self(40)]",
                                                   "H:[$self(88)]"])
        mapButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        mapButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -24).isActive = true

        
        satisficationView = KPSatisficationView()
        expNotificationView = KPExpNotificationView()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.snapShotShowing = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    // MARK: Animation
    func dismissStatusErrorContent(_ completion:(() -> Void)?) {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: { 
                        self.statusErrorImageView.transform = CGAffineTransform(translationX: 0, y: -30)
                        self.statusErrorDescriptionLabel.transform = CGAffineTransform(translationX: 0, y: -30)
                        self.statusErrorButton.transform = CGAffineTransform(translationX: 0, y: -30)
                        self.statusErrorImageView.alpha = 0
                        self.statusErrorDescriptionLabel.alpha = 0
                        self.statusErrorButton.alpha = 0
        }) { (_) in
            completion?()
            self.statusErrorImageView.transform = .identity
            self.statusErrorDescriptionLabel.transform = .identity
            self.statusErrorButton.transform = .identity
            self.statusErrorImageView.alpha = 1.0
            self.statusErrorDescriptionLabel.alpha = 1.0
            self.statusErrorButton.alpha = 1.0
        }
    }
    
    @objc func handleSortOptionTapped() {
        present(actionController,
                animated: true,
                completion: nil)
        actionController.view.tintColor = KPColorPalette.KPMainColor_v2.mainColor
    }
    
    @objc func handleStatusErrorButtonOnTapped() {
        statusErrorButton.isLoading = true
        let fadeTransition = CATransition()
        fadeTransition.duration = 0.2
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.statusErrorDescriptionLabel.setText(text: "你以為按了就有用麻？其實是沒用的啦？",
                                                     lineSpacing: 3.0)
            self.statusErrorDescriptionLabel.layer.add(fadeTransition, forKey: nil)
            self.statusErrorButton.isLoading = false
        })
        statusErrorDescriptionLabel.text = ""
        statusErrorDescriptionLabel.layer.add(fadeTransition, forKey: nil)
        CATransaction.commit()
    }
    
    // MARK: Ads
    
    func addNativeExpressAds() {
        
        adsAdded = true
        if adsToLoad.isEmpty && adsLoaded.count == 0 {
            var index = Constant.adInterval
            var copiedDisplayDataModel = displayDataModel
            tableView.layoutIfNeeded()
            
            while index < displayDataModel.count {
                if adsToLoad.count < Constant.concurrentAdsCount {
                    
                    let adSize = GADAdSizeFromCGSize(CGSize(width: tableView.contentSize.width,
                                                            height: Constant.adViewHeight))
                    
                    guard let adView = GADNativeExpressAdView(adSize: adSize) else {
                        print("GADNativeExpressAdView failed to initialize at index \(index)")
                        return
                    }
                    adView.adUnitID = "ca-app-pub-3940256099942544/2562852117"
                    adView.rootViewController = self
                    adView.delegate = self
                    
                    adsToLoad.append(adView)
                    loadStateForAds[adView] = false
                    
                    copiedDisplayDataModel.insert(adView, at: index)
                }
                index += Constant.adInterval
            }
            displayDataModel = copiedDisplayDataModel
            adsAdded = false
            preloadNextAd()
        } else if !adsLoaded.isEmpty {
            var index = Constant.adInterval
            var copiedDisplayDataModel = displayDataModel
            for position in 0..<adsLoaded.count {
                if index < displayDataModel.count {
                    copiedDisplayDataModel.insert(adsLoaded[position], at: index)
                    index += Constant.adInterval
                } else {
                    break
                }
            }
            displayDataModel = copiedDisplayDataModel
            adsAdded = false
        }
    }
    
    func preloadNextAd() {
        if !adsToLoad.isEmpty {
            let ad = adsToLoad.removeFirst()
            ad.load(GADRequest())
            adsLoaded.append(ad)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}

extension KPMainListViewController: GADNativeExpressAdViewDelegate {
    
    func nativeExpressAdViewDidReceiveAd(_ nativeExpressAdView: GADNativeExpressAdView) {
        loadStateForAds[nativeExpressAdView] = true
        preloadNextAd()
    }
    
    func nativeExpressAdView(_ nativeExpressAdView: GADNativeExpressAdView,
                             didFailToReceiveAdWithError error: GADRequestError) {
        print("Failed to receive ad: \(error.localizedDescription)")
        preloadNextAd()
    }
}

extension KPMainListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 80 &&
            (scrollView.contentOffset.y + scrollView.frameSize.height) < scrollView.contentSize.height {
//            if scrollView.contentOffset.y > oldScrollOffsetY {
//                // 往下
//                currentSearchTagTranslateY = (currentSearchTagTranslateY + oldScrollOffsetY - scrollView.contentOffset.y > -80) ?
//                    currentSearchTagTranslateY + oldScrollOffsetY - scrollView.contentOffset.y :
//                    -80
//            } else {
//                // 往上
//                let updatedOffset = oldScrollOffsetY - scrollView.contentOffset.y
//                currentSearchTagTranslateY = (currentSearchTagTranslateY + updatedOffset <= 0) ?
//                    currentSearchTagTranslateY + updatedOffset :
//                    0
//            }
//            
//            mainController.searchHeaderView.searchTagView.transform = CGAffineTransform(translationX: 0,
//                                                                                        y: currentSearchTagTranslateY/2)
//            mainController.mainMapViewController?.mapView.transform = CGAffineTransform(translationX: 0,
//                                                                                        y: currentSearchTagTranslateY/2)
//            tableView.transform = CGAffineTransform(translationX: 0, y: currentSearchTagTranslateY/2)
//            snapshotView.transform = CGAffineTransform(translationX: 0, y: currentSearchTagTranslateY/2)
//            oldScrollOffsetY = scrollView.contentOffset.y
//        }
          
            var translate: CGFloat
            var opacity: CGFloat
            var buttonTranslate: CGFloat
            
            if scrollView.contentOffset.y > oldScrollOffsetY {
                // 往下
                translate = -108
                buttonTranslate = 120
                opacity = 0
            } else {
                // 往上
                translate = 0.0
                buttonTranslate = 0
                opacity = 1.0
            }
            
            self.currentSearchTagTranslateY = translate
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            self.mainController.searchHeaderView.searchTagView.transform = CGAffineTransform(translationX: 0,
                                                                                                             y: self.currentSearchTagTranslateY/2)
                            self.mainController.searchHeaderView.searchTagView.alpha = opacity
                            self.mainController.mainMapViewController?.mapView.transform = CGAffineTransform(translationX: 0,
                                                                                                             y: self.currentSearchTagTranslateY/2)
                            self.mainController.mainMapViewController?.searchNearButton.transform = CGAffineTransform(translationX: 0,
                                                                                                                      y: self.currentSearchTagTranslateY/2)
                            self.sortContainerView.transform = CGAffineTransform(translationX: 0, y: self.currentSearchTagTranslateY/2)
                            self.tableView.transform = CGAffineTransform(translationX: 0, y: self.currentSearchTagTranslateY/2)
                            self.snapshotView.transform = CGAffineTransform(translationX: 0, y: self.currentSearchTagTranslateY/2)
                            
            }, completion: { (_) in
                self.oldScrollOffsetY = scrollView.contentOffset.y
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if state == .normal {
            if let nativeExpressAdView = displayDataModel[indexPath.row] as? GADNativeExpressAdView {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constant.KPMainListViewAdCellReuseIdentifier,
                                                         for: indexPath) as! KPMainListNativeExpressCell
                
                for subview in cell.contentView.subviews {
                    subview.removeFromSuperview()
                }
                
                cell.contentView.addSubview(nativeExpressAdView)
                nativeExpressAdView.center = cell.contentView.center
                
                return cell
            } else  {
                let displayModel = displayDataModel[indexPath.row] as? KPDataModel
                if displayModel?.identifier == "empty" {
                    let cell = tableView.dequeueReusableCell(withIdentifier:Constant.KPMainListViewAddCellReuseIdentifier,
                                                             for: indexPath) as! KPMainListAddCell
                    cell.selectionStyle = .none
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier:Constant.KPMainListViewCellReuseIdentifier,
                                                             for: indexPath) as! KPMainListTableViewCell
                    
                    cell.selectionStyle = .none
                    cell.dataModel = self.displayDataModel[indexPath.row] as! KPDataModel
                    return cell
                }
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:Constant.KPMainListViewLoadingCellReuseIdentifier,
                                                     for: indexPath) as! KPDefaultLoadingTableCell
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !displayDataModel.isEmpty  && state != .barLoading  && state != .loading, let tableItem = displayDataModel[indexPath.row] as? GADNativeExpressAdView {
            let isAdLoaded = loadStateForAds[tableItem]
            return isAdLoaded == true ? Constant.adViewHeight : 0
        }
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state == .normal ? displayDataModel.count : 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dataModel = self.displayDataModel[indexPath.row] as? KPDataModel {
            
            if dataModel.identifier == "empty" {
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
            } else {
                KPAnalyticManager.sendCellClickEvent(dataModel.name,
                                                     dataModel.averageRate?.stringValue,
                                                     KPAnalyticsEventValue.source.source_list)
                
                self.currentDataModel = dataModel
                self.currentSelectedCell = tableView.cellForRow(at: indexPath) as? KPMainListTableViewCell
                self.snapShotShowing = true
                self.mainController.performSegue(withIdentifier: "datailedInformationSegue", sender: self)
            }
        }
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
