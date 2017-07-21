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
    KPMainViewControllerDelegate,
    KPSearchFooterViewDelegate {
    
    struct Constant {
        static let KPMainListViewCellReuseIdentifier = "cell"
        static let KPMainListViewLoadingCellReuseIdentifier = "cell_loading"
        static let KPMainListViewAdCellReuseIdentifier = "cell_ad"
        static let adInterval = 12
        static let concurrentAdsCount = 8
        static let adViewHeight = CGFloat(135)
    }
    
    public enum ControllerState {
        case normal
        case loading
        case noInternet
    }
    
    weak var mainController: KPMainViewController!
    
    var statusContainerView: UIView!
    var statusErrorImageView: UIImageView!
    var statusErrorDescriptionLabel: UILabel!
    var statusErrorButton: KPLoadingButton!
    
    
    var tableView: UITableView!
    var satisficationView: KPSatisficationView!
    var expNotificationView: KPExpNotificationView!
    var adLoader: GADAdLoader!
    var oldScrollOffsetY: CGFloat = 80.0
    var currentSearchTagTranslateY: CGFloat = 0.0
    
    lazy var addButton: KPShadowButton = {
        let shadowButton = KPShadowButton()
        shadowButton.backgroundColor = KPColorPalette.KPBackgroundColor.scoreButtonColor!
        shadowButton.button.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.scoreButtonColor!), for: .normal)
        shadowButton.button.setImage(R.image.icon_add(), for: .normal)
        shadowButton.button.tintColor = UIColor.white
        shadowButton.button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        shadowButton.layer.cornerRadius = 28
        return shadowButton
    }()
    
    var currentDataModel: KPDataModel?
    var currentSelectedCell: KPMainListTableViewCell?
    var state: ControllerState! = .loading
    {
        didSet {
            if state == .noInternet {
                statusContainerView.isHidden = false
                tableView.isHidden = true
            } else if state == .normal {
                statusContainerView.isHidden = true
                tableView.isHidden = false
            } else if state == .loading {
                statusContainerView.isHidden = true
                tableView.isHidden = false
            }
        }
    }
    
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
    
    private var searchFooterView: KPSearchFooterView!
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
        
        statusContainerView = UIView()
        statusContainerView.backgroundColor = UIColor.white
        view.addSubview(statusContainerView)
        statusContainerView.addConstraints(fromStringArray: ["V:|-100-[$self]|",
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
        statusErrorDescriptionLabel.setText(text: "你的網路實在太糟糕，快去升級台灣之星5G吧!",
                                            lineSpacing: 3.0)
        
        statusErrorButton = KPLoadingButton(image: nil, title: "讓我再試試")
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
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = false
        view.addSubview(tableView)
        tableView.addConstraints(fromStringArray: ["V:|-100-[$self]-(-40)-|",
                                                   "H:|[$self]|"])
        tableView.register(KPMainListTableViewCell.self,
                                forCellReuseIdentifier: Constant.KPMainListViewCellReuseIdentifier)
        tableView.register(KPDefaultLoadingTableCell.self,
                                forCellReuseIdentifier: Constant.KPMainListViewLoadingCellReuseIdentifier)
        tableView.register(KPMainListNativeExpressCell.self,
                                forCellReuseIdentifier: Constant.KPMainListViewAdCellReuseIdentifier)
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        
//        searchFooterView = KPSearchFooterView()
//        searchFooterView.delegate = self
//        searchFooterView.layer.shadowColor = UIColor.black.cgColor
//        searchFooterView.layer.shadowOpacity = 0.15
//        searchFooterView.layer.shadowOffset = CGSize(width: 0.0, height: -1.0)
//        searchFooterView.isHidden = true
//        view.addSubview(searchFooterView)
//        searchFooterView.addConstraints(fromStringArray: ["V:[$view0][$self(40)]|",
//                                                          "H:|[$self]|"],
//                                        views:[tableView])
        
        snapshotView = UIImageView()
        snapshotView.contentMode = .top
        snapshotView.clipsToBounds = true
        snapshotView.isHidden = true
        view.addSubview(snapshotView)
        snapshotView.addConstraints(fromStringArray: ["V:|-100-[$self]-(-40)-|",
                                                      "H:|[$self]|"])
        
//        view.bringSubview(toFront: searchFooterView)
        
        
//        view.addSubview(addButton)
//        addButton.button.addTarget(self,
//                                   action: #selector(handleAddButtonTapped(_:)), for: .touchUpInside)
//        addButton.addConstraints(fromStringArray: ["H:[$self(56)]-18-|",
//                                                   "V:[$self(56)]-16-|"])
        
        
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
    
    
    // MARK: UI Event
    
    func handleStatusErrorButtonOnTapped() {
        statusErrorButton.isLoading = true
        let fadeTransition = CATransition()
        fadeTransition.duration = 0.2
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.statusErrorDescriptionLabel.setText(text: "你以為按了就用麻？傻子？快去換台灣之星5G吧",
                                                     lineSpacing: 3.0)
            self.statusErrorDescriptionLabel.layer.add(fadeTransition, forKey: nil)
            self.statusErrorButton.isLoading = false
        })
        statusErrorDescriptionLabel.text = ""
        statusErrorDescriptionLabel.layer.add(fadeTransition, forKey: nil)
        CATransaction.commit()
    }
    
    func handleAddButtonTapped(_ sender: UIButton) {
        let controller = KPModalViewController()
        controller.edgeInset = UIEdgeInsets(top: 0,
                                            left: 0,
                                            bottom: 0,
                                            right: 0)
        let newStoreController = KPNewStoreController()
        let navigationController = UINavigationController(rootViewController: newStoreController)
        controller.contentController = navigationController
        controller.presentModalView()
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
    
    func searchFooterView(_ searchFooterView: KPSearchFooterView,
                          didSelectItemWith name: String) {
        print("Footer Name:\(name)")
        satisficationView.showSatisfication()
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let translate: CGFloat = self.currentSearchTagTranslateY < -40 ? -80 : 0.0
        self.currentSearchTagTranslateY = translate
        UIView.animate(withDuration: 0.1) {
            self.mainController.searchHeaderView.searchTagView.transform = CGAffineTransform(translationX: 0,
                                                                                        y: self.currentSearchTagTranslateY/2)
            self.mainController.mainMapViewController?.mapView.transform = CGAffineTransform(translationX: 0,
                                                                                        y: self.currentSearchTagTranslateY/2)
            self.tableView.transform = CGAffineTransform(translationX: 0, y: self.currentSearchTagTranslateY/2)
            self.snapshotView.transform = CGAffineTransform(translationX: 0, y: self.currentSearchTagTranslateY/2)
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 80 {
            if scrollView.contentOffset.y > oldScrollOffsetY {
                // 往下
                currentSearchTagTranslateY = (currentSearchTagTranslateY + oldScrollOffsetY - scrollView.contentOffset.y > -80) ?
                    currentSearchTagTranslateY + oldScrollOffsetY - scrollView.contentOffset.y :
                    -80
            } else {
                // 往上
                let updatedOffset = oldScrollOffsetY - scrollView.contentOffset.y
                currentSearchTagTranslateY = (currentSearchTagTranslateY + updatedOffset <= 0) ?
                    currentSearchTagTranslateY + updatedOffset :
                    0
            }
            
            mainController.searchHeaderView.searchTagView.transform = CGAffineTransform(translationX: 0,
                                                                                        y: currentSearchTagTranslateY/2)
            mainController.mainMapViewController?.mapView.transform = CGAffineTransform(translationX: 0,
                                                                                        y: currentSearchTagTranslateY/2)
            tableView.transform = CGAffineTransform(translationX: 0, y: currentSearchTagTranslateY/2)
            snapshotView.transform = CGAffineTransform(translationX: 0, y: currentSearchTagTranslateY/2)
            oldScrollOffsetY = scrollView.contentOffset.y
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
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier:Constant.KPMainListViewCellReuseIdentifier,
                                                         for: indexPath) as! KPMainListTableViewCell
                
                cell.selectionStyle = .none
                cell.dataModel = self.displayDataModel[indexPath.row] as! KPDataModel
                return cell
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
        if !displayDataModel.isEmpty  && state != .loading, let tableItem = displayDataModel[indexPath.row] as? GADNativeExpressAdView {
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
            self.currentDataModel = dataModel
            self.currentSelectedCell = tableView.cellForRow(at: indexPath) as? KPMainListTableViewCell
            self.snapShotShowing = true
            self.mainController.performSegue(withIdentifier: "datailedInformationSegue", sender: self)
        }
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
