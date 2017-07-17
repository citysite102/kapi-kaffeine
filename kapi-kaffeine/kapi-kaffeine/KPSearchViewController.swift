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
    
    
    var initialHeaderContent: [String] = ["最近搜尋紀錄"]
    var recentSearchModel: [KPDataModel] = [KPDataModel]()
    var hotSearchModel: [String] = ["Demo1", "Demo2", "Demo3"]
    
    var displayDataModel: [KPDataModel] = [KPDataModel]()
    var filteredDataModel: [KPDataModel] = [KPDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        ref = Database.database().reference()
        
        dismissButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30),
                                       image: R.image.icon_back()!)
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.addTarget(self,
                                action: #selector(KPSearchViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -5
        navigationItem.leftBarButtonItems = [negativeSpacer, UIBarButtonItem.init(image: R.image.icon_back(),
                                                                                  style: .plain,
                                                                                  target: self,
                                                                                  action: #selector(KPSearchViewController.handleDismissButtonOnTapped))]
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
    func handleDismissButtonOnTapped() {
        self.appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    func handleBackButtonOnTapped() {
        self.navigationController?.popViewController(animated: true)
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
        
        filteredDataModel = displayDataModel.filter({ (dataModel) -> Bool in
            return (dataModel.name as NSString).range(of: searchString,
                                                      options: .caseInsensitive).location != NSNotFound
        })
        tableView.reloadData()
    }
}

extension KPSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if shouldShowSearchResults {
            let cell = tableView.dequeueReusableCell(withIdentifier:KPSearchViewController.KPSearchViewControllerDefaultCellReuseIdentifier,
                                                     for: indexPath) as! KPSearchViewDefaultCell
            cell.shopNameLabel.text = filteredDataModel[indexPath.row].name
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
            
        } else {
            infoController.informationDataModel = displayDataModel[indexPath.row]
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
