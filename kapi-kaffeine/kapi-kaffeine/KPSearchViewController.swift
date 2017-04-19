//
//  KPSearchViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/19.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchViewController: UIViewController {

    var searchController: UISearchController!
    var tableView: UITableView!
    
    var displayDataModel: [KPDataModel]! {
        didSet {
            self.tableView.reloadData();
        }
    }
    
    let cities = [
        "臺北市","新北市","桃園市","臺中市","臺南市",
        "高雄市","基隆市","新竹市","嘉義市","新竹縣",
        "苗栗縣","彰化縣","南投縣","雲林縣","嘉義縣",
        "屏東縣","宜蘭縣","花蓮縣","臺東縣","澎湖縣",]
    
    let fullScreenSize = UIScreen.main.bounds.size
    
    var searchArr: [String] = [String](){
        didSet {
            // 重設 searchArr 後重整 tableView
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.view.addSubview(self.tableView);
        self.tableView.addConstraints(fromStringArray: ["V:|-20-[$self]",
                                                        "H:|[$self]|"]);
        self.tableView.register(KPMainListTableViewCell.self,
                                forCellReuseIdentifier: KPMainListViewController.KPMainListViewCellReuseIdentifier);

        
        self.searchController = UISearchController(searchResultsController: nil);
        self.searchController.searchResultsUpdater = self;
        self.searchController.dimsBackgroundDuringPresentation = false;
        self.searchController.searchBar.searchBarStyle = .prominent;
        self.searchController.searchBar.sizeToFit();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension KPSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText =
            searchController.searchBar.text else {
                return
        }
        
        
        self.searchArr = self.cities.filter({ (city) -> Bool in
            
            let cityText: String = city;
            
            return (cityText.range(of: searchText,
                                   options: .caseInsensitive,
                                   range: nil,
                                   locale: nil) != nil);
        })
    }
}

extension KPSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:KPMainListViewController.KPMainListViewCellReuseIdentifier,
                                                 for: indexPath) as! KPMainListTableViewCell;
        
        cell.selectionStyle = .none;
        cell.dataModel = self.displayDataModel[indexPath.row]
        cell.shopStatusContent = (self.displayDataModel[indexPath.row].openTime! as String).replacingOccurrences(of: "~", with: "-");
        cell.scoreLabel.score = "\(self.displayDataModel[indexPath.row].score!.format(f: ".1"))";
        
        return cell;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayDataModel.count;
    }
    
}
