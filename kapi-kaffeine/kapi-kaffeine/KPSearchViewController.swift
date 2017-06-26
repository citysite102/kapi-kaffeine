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

    var dismissButton:UIButton!
    var tableView: UITableView!
    var searchController: UISearchController!

    var shouldShowSearchResults = false
    
    var displayDataModel: [KPDataModel] = [KPDataModel]()
    var filteredDataModel: [KPDataModel] = [KPDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        ref = Database.database().reference()
        
        dismissButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24))
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        dismissButton.setImage(R.image.icon_close()?.withRenderingMode(.alwaysTemplate),
                                    for: .normal)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.addTarget(self,
                                action: #selector(KPSearchViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
//        let barItem = UIBarButtonItem.init(customView: self.dismissButton)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
//        navigationItem.rightBarButtonItems = [negativeSpacer, barItem]
        navigationItem.leftBarButtonItems = [negativeSpacer, UIBarButtonItem.init(image: R.image.icon_back(),
                                                                                  style: .plain,
                                                                                  target: self,
                                                                                  action: #selector(KPSearchViewController.handleDismissButtonOnTapped))]
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
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
        
        ref.child("all_of_user").child("searchHistories").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSArray
        }) { (error) in
            print(error.localizedDescription)
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
        let cell = tableView.dequeueReusableCell(withIdentifier:KPSearchViewController.KPSearchViewControllerDefaultCellReuseIdentifier,
                                                 for: indexPath) as! KPSearchViewDefaultCell
        if shouldShowSearchResults {
            cell.shopNameLabel.text = self.filteredDataModel[indexPath.row].name
        } else {
            cell.shopNameLabel.text = self.displayDataModel[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let searchTitleLabel = KPSearchViewHeaderLabel()
        return searchTitleLabel
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredDataModel.count
        } else {
            return displayDataModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoController = KPInformationViewController()
        if shouldShowSearchResults {
            infoController.informationDataModel = filteredDataModel[indexPath.row]
        } else {
            infoController.informationDataModel = displayDataModel[indexPath.row]
        }
        self.navigationController?.pushViewController(infoController, animated: true)
    }
}
