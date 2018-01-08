//
//  KPSearchViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import FirebaseDatabase

class KPSearchViewController: KPViewController {

    static let KPSearchViewControllerDefaultCellReuseIdentifier = "cell"
    static let KPSearchViewControllerRecentCellReuseIdentifier = "cell_recent"
    
    weak var mainListController: KPMainListViewController!
    
    var ref: DatabaseReference!

    var dismissButton: KPBounceButton!
    var tableView: UITableView!
    var searchController: UISearchController!

    var shouldShowSearchResults = false
    var emptyResult = false {
        didSet {
            
            if emptyResult {
                emptyContainer.isHidden = false
            } else {
                tableView.isHidden = false
            }
            
            UIView.animate(withDuration: 0.2,
                           animations: { 
                            self.tableView.alpha = self.emptyResult ? 0.0 : 1.0
                            self.emptyContainer.alpha = self.emptyResult ? 1.0 : 0.0
            }) { (_) in
                self.tableView.isHidden = self.emptyResult ? true : false
                self.emptyContainer.isHidden = self.emptyResult ? false : true
            }
        }
    }
    
    var emptyContainer: UIView!
    var emptyImageView: UIImageView!
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setText(text: "目前沒有找到符合的咖啡店")
        return label
    }()
    
    var newStoreButton: UIButton!
    
    
    var initialHeaderContent: [String] = ["最近搜尋紀錄"]
    var recentSearchModel: [KPDataModel] = [KPDataModel]()
    var hotSearchModel: [String] = ["Demo1", "Demo2", "Demo3"]
    
    var displayDataModel: [KPDataModel] = [KPDataModel]()
    var filteredDataModel: [KPDataModel] = [KPDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        KPAnalyticManager.sendPageViewEvent(KPAnalyticsEventValue.page.search_page)

        view.backgroundColor = UIColor.white
        ref = Database.database().reference()
        
        dismissButton = KPBounceButton(frame: CGRect.zero,
                                       image: R.image.icon_back()!)
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.addTarget(self,
                                action: #selector(KPSearchViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        let dismissBarButtonItem = UIBarButtonItem(image: R.image.icon_back(),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(KPSearchViewController.handleDismissButtonOnTapped))
        dismissBarButtonItem.imageInsets = UIEdgeInsetsMake(6, 0, 0, 6)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -5
        navigationItem.leftBarButtonItems = [negativeSpacer, dismissBarButtonItem]
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        view.addSubview(self.tableView)
        tableView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                   "H:|[$self]|"])
        tableView.register(KPSearchViewDefaultCell.self,
                           forCellReuseIdentifier: KPSearchViewController.KPSearchViewControllerDefaultCellReuseIdentifier)
        tableView.register(KPSearchViewRecentCell.self,
                           forCellReuseIdentifier: KPSearchViewController.KPSearchViewControllerRecentCellReuseIdentifier)
        tableView.allowsSelection = true
        
        
        emptyContainer = UIView()
        emptyContainer.isHidden = true
        view.addSubview(emptyContainer)
        emptyContainer.addConstraintForCenterAligningToSuperview(in: .vertical, constant: -48)
        emptyContainer.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        emptyImageView = UIImageView(image: R.image.icon_house_l())
        emptyImageView.contentMode = .scaleAspectFit
        emptyContainer.addSubview(emptyImageView)
        emptyImageView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        emptyImageView.addConstraint(from: "V:|[$self(90)]")
        
        emptyContainer.addSubview(emptyLabel)
        emptyLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        emptyLabel.addConstraint(from: "V:[$view0]-24-[$self]",
                                 views: [emptyImageView])
        emptyLabel.addConstraint(from: "H:|[$self]|")
        
        newStoreButton = UIButton(type: .custom)
        newStoreButton.setTitle("我要新增店家", for: .normal)
        newStoreButton.setBackgroundImage(UIImage(color: KPColorPalette.KPBackgroundColor.mainColor!),
                                                 for: .normal)
        newStoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        newStoreButton.layer.cornerRadius = 4
        newStoreButton.layer.masksToBounds = true
        newStoreButton.addTarget(self,
                                 action: #selector(handleNewStoreButtonOnTap(_:)),
                                 for: .touchUpInside)
        emptyContainer.addSubview(newStoreButton)
        newStoreButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        newStoreButton.addConstraint(from: "V:[$view0]-10-[$self(44)]|",
                                     views: [emptyLabel])
        newStoreButton.addConstraint(forWidth: 176)
        
        configureSearchController()
        readSearchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "搜尋咖啡店名稱..."
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar
    }
    
    func readSearchData() {
        
        ref.child("all_of_user").child("searchHistories").observeSingleEvent(of: .value, with: { (_) in
//            let value = snapshot.value as? NSArray
        }) { (error) in
            print(error.localizedDescription)
        }
        
        if let recentSearch = KPUserDefaults.recentSearch {
            for dataModelJson in recentSearch {
                if let dataModel = KPDataModel(JSON: dataModelJson) {
                    recentSearchModel.append(dataModel)
                }
            }
        }
    }
    
    
    // MARK: UI Event
    @objc func handleDismissButtonOnTapped() {
        self.appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    func handleBackButtonOnTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNewStoreButtonOnTap(_ sender: UIButton) {
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
}

extension KPSearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        if searchString.count < 1 {
            filteredDataModel = []
            tableView.reloadData()
            return
        }
        
//        filteredDataModel = displayDataModel.filter({ (dataModel) -> Bool in
//            return (dataModel.name as NSString).range(of: searchString,
//                                                      options: .caseInsensitive).location != NSNotFound
//        })
        
        KPServiceHandler.sharedHandler.fetchRemoteData(nil,
                                                       nil,
                                                       nil,
                                                       nil,
                                                       nil,
                                                       nil,
                                                       nil,
                                                       searchString) { (results, error) in
                                                        DispatchQueue.main.async {[unowned self] in
                                                            if results != nil {
                                                                self.filteredDataModel = results!
                                                                self.emptyResult = false
                                                            } else {
                                                                self.emptyResult = true
                                                            }
                                                            self.tableView.reloadData()
                                                        }}
    }
}

extension KPSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if shouldShowSearchResults {
            let cell = tableView.dequeueReusableCell(withIdentifier:KPSearchViewController.KPSearchViewControllerDefaultCellReuseIdentifier,
                                                     for: indexPath) as! KPSearchViewDefaultCell
            cell.shopNameLabel.text = filteredDataModel[indexPath.row].name
            cell.rateLabel.text = String(format: "%.1f", filteredDataModel[indexPath.row].averageRate?.doubleValue ?? 0.0)
            
            if let distanceInMeter = filteredDataModel[indexPath.row].distanceInMeter {
                var distance = distanceInMeter
                var unit = "m"
                if distance > 1000 {
                    unit = "km"
                    distance = distance/1000
                }
                cell.distanceLabel.text = String(format: "%.1f%@", distance, unit)
            } else {
                cell.distanceLabel.text = "-"
            }
            
            return cell
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier:KPSearchViewController.KPSearchViewControllerRecentCellReuseIdentifier,
                                                     for: indexPath) as! KPSearchViewRecentCell
                cell.shopNameLabel.text = recentSearchModel[indexPath.row].name
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier:KPSearchViewController.KPSearchViewControllerDefaultCellReuseIdentifier,
                                                         for: indexPath) as! KPSearchViewDefaultCell
                cell.shopNameLabel.text = displayDataModel[indexPath.row].name
                cell.rateLabel.text = String(format: "%.1f", displayDataModel[indexPath.row].averageRate?.doubleValue ?? 0.0)
                
                if let distanceInMeter = displayDataModel[indexPath.row].distanceInMeter {
                    var distance = distanceInMeter
                    var unit = "m"
                    if distance > 1000 {
                        unit = "km"
                        distance = distance/1000
                    }
                    cell.distanceLabel.text = String(format: "%.1f%@", distance, unit)
                } else {
                    cell.distanceLabel.text = "-"
                }
                
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchTitleLabel = KPSearchViewHeaderLabel()
        if shouldShowSearchResults {
            searchTitleLabel.headerLabel.text = "搜尋結果"
        } else {
            searchTitleLabel.headerLabel.text = initialHeaderContent[section]
        }
        return searchTitleLabel
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if shouldShowSearchResults {
            return 1
        } else {
            // 暫時不處理熱門搜尋
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56.0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredDataModel.count
        } else {
            return recentSearchModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoController = KPInformationViewController()
        
        if shouldShowSearchResults {
            infoController.informationDataModel = filteredDataModel[indexPath.row]
            
            if var recentSearch = KPUserDefaults.recentSearch {
                if recentSearch.count >= 5 {
                    recentSearch.removeLast()
                }
                
                let dataModel = filteredDataModel[indexPath.row].toJSON()
                let duplicatedModel = recentSearchModel.first(where: { (model) -> Bool in
                    return model.identifier == filteredDataModel[indexPath.row].identifier
                })
                
                if duplicatedModel == nil {
                    recentSearch.insert(dataModel, at: 0)
                    KPUserDefaults.recentSearch = recentSearch
                }
            } else {
                let recentSearch = [filteredDataModel[indexPath.row].toJSON()]
                KPUserDefaults.recentSearch = recentSearch
            }
            
            KPAnalyticManager.sendCellClickEvent(filteredDataModel[indexPath.row].name,
                                                 filteredDataModel[indexPath.row].averageRate?.stringValue,
                                                 KPAnalyticsEventValue.source.source_search)
            
            
        } else {
            infoController.informationDataModel = recentSearchModel[indexPath.row]
            
            KPAnalyticManager.sendCellClickEvent(recentSearchModel[indexPath.row].name,
                                                 recentSearchModel[indexPath.row].averageRate?.stringValue,
                                                 KPAnalyticsEventValue.source.source_search)
        }
        
        if searchController.searchBar.isFirstResponder {
            searchController.searchBar.endEditing(true)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.navigationController?.pushViewController(infoController, animated: true)
            }
        } else {
            self.navigationController?.pushViewController(infoController, animated: true)
        }
    }
}
