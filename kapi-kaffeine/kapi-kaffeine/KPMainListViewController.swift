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
    
    static let KPMainListViewCellReuseIdentifier = "cell"
    static let KPMainListViewLoadingCellReuseIdentifier = "cell_loading"
    static let KPMainListViewAdCellReuseIdentifier = "cell_ad"
    static let adInterval = 12
    static let concurrentAdsCount = 20
    static let adViewHeight = CGFloat(135)
    
    weak var mainController:KPMainViewController!
    var tableView: UITableView!
    var adLoader: GADAdLoader!
    
    var currentDataModel:KPDataModel?
    var dataLoading: Bool = true
    var snapShotShowing: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.snapShotShowing != oldValue && self.snapShotShowing {
                    self.snapshotView.image = self.tableView.screenshotForVisible()
                    self.snapshotView.isHidden = false
                    self.tableView.isHidden = true
                } else if self.snapShotShowing != oldValue {
                    self.snapshotView.isHidden = true
                    self.tableView.isHidden = false
                }
            }
        }
    }
    
    private var searchFooterView: KPSearchFooterView!
    private var snapshotView: UIImageView!
    
    var selectedDataModel: KPDataModel? {
        return currentDataModel
    }
    
    var displayDataModel: [AnyObject] = [AnyObject]() {
        didSet {
            if dataLoading {
                dataLoading = false
                self.tableView.isUserInteractionEnabled = true
                self.tableView.allowsSelection = true
                self.addNativeExpressAds()
                self.preloadNextAd()
                self.tableView.reloadData()
            }
        }
    }
    
    var adsToLoad: [GADNativeExpressAdView] = [GADNativeExpressAdView]()
    var loadStateForAds = [GADNativeExpressAdView: Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = false
        view.addSubview(tableView)
        tableView.addConstraints(fromStringArray: ["V:|-100-[$self]",
                                                        "H:|[$self]|"])
        tableView.register(KPMainListTableViewCell.self,
                                forCellReuseIdentifier: KPMainListViewController.KPMainListViewCellReuseIdentifier)
        tableView.register(KPDefaultLoadingTableCell.self,
                                forCellReuseIdentifier: KPMainListViewController.KPMainListViewLoadingCellReuseIdentifier)
        tableView.register(KPMainListNativeExpressCell.self,
                                forCellReuseIdentifier: KPMainListViewController.KPMainListViewAdCellReuseIdentifier)
        
        tableView.allowsSelection = false
        tableView.rowHeight = UITableViewAutomaticDimension
        
        searchFooterView = KPSearchFooterView()
        searchFooterView.delegate = self
        searchFooterView.layer.shadowColor = UIColor.black.cgColor
        searchFooterView.layer.shadowOpacity = 0.15
        searchFooterView.layer.shadowOffset = CGSize.init(width: 0.0, height: -1.0)
        view.addSubview(searchFooterView)
        searchFooterView.addConstraints(fromStringArray: ["V:[$view0][$self(40)]|", "H:|[$self]|"],
                                             views:[tableView])
        
        snapshotView = UIImageView()
        snapshotView.contentMode = .top
        snapshotView.clipsToBounds = true
        snapshotView.isHidden = true
        view.addSubview(snapshotView)
        snapshotView.addConstraints(fromStringArray: ["V:|-100-[$self][$view0]",
                                                      "H:|[$self]|"],
                                    views: [searchFooterView])
        
        view.bringSubview(toFront: searchFooterView)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.snapShotShowing = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func addNativeExpressAds() {
        var index = KPMainListViewController.adInterval
        tableView.layoutIfNeeded()
        while index < displayDataModel.count {
            let adSize = GADAdSizeFromCGSize(CGSize(width: tableView.contentSize.width,
                                                    height: KPMainListViewController.adViewHeight))

            
            if adsToLoad.count < KPMainListViewController.concurrentAdsCount {
                guard let adView = GADNativeExpressAdView.init(adSize: adSize) else {
                    print("GADNativeExpressAdView failed to initialize at index \(index)")
                    return
                }
                adView.adUnitID = "ca-app-pub-3940256099942544/2562852117"
                adView.rootViewController = self
                adView.delegate = self
                
                displayDataModel.insert(adView, at: index)
                adsToLoad.append(adView)
                loadStateForAds[adView] = false
            }
            index += KPMainListViewController.adInterval
        }
    }
    
    func preloadNextAd() {
        if !adsToLoad.isEmpty {
            let ad = adsToLoad.removeFirst()
            ad.load(GADRequest())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func searchFooterView(_ searchFooterView: KPSearchFooterView,
                          didSelectItemWith name: String) {
        print("Footer Name:\(name)")
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !dataLoading {
            
            if let nativeExpressAdView = displayDataModel[indexPath.row] as? GADNativeExpressAdView {
                let cell = tableView.dequeueReusableCell(withIdentifier: KPMainListViewController.KPMainListViewAdCellReuseIdentifier,
                                                         for: indexPath) as! KPMainListNativeExpressCell
                
                for subview in cell.contentView.subviews {
                    subview.removeFromSuperview()
                }
                
                cell.contentView.addSubview(nativeExpressAdView)
                nativeExpressAdView.center = cell.contentView.center
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier:KPMainListViewController.KPMainListViewCellReuseIdentifier,
                                                         for: indexPath) as! KPMainListTableViewCell
                
                cell.selectionStyle = .none
                cell.dataModel = self.displayDataModel[indexPath.row] as! KPDataModel
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:KPMainListViewController.KPMainListViewLoadingCellReuseIdentifier,
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
        if !displayDataModel.isEmpty, let tableItem = displayDataModel[indexPath.row] as? GADNativeExpressAdView {
            let isAdLoaded = loadStateForAds[tableItem]
            return isAdLoaded == true ? KPMainListViewController.adViewHeight : 0
        }
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataLoading ? 8 : self.displayDataModel.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let dataModel = self.displayDataModel[indexPath.row] as? KPDataModel {
            self.currentDataModel = dataModel
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
