//
//  KPLocationSelectViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2018/2/5.
//  Copyright © 2018年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPLocationSelectViewController: KPViewController {

    static let KPCountryCellReuseIdentifier = "countryCell"
    static let KPCityCellReuseIdentifier = "cityCell"
    
    var tableView = UITableView()
    
    var expandedIndex: Int?
    var cityData: [CountryData] = KPCityDataModel.sharedData
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        navigationController?.navigationBar.topItem?.title = "選擇地區"
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let barLeftItem = UIBarButtonItem(title: "取消",
                                          style: .plain,
                                          target: self,
                                          action: #selector(handleDismissButtonOnTapped))
        barLeftItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.mainContent), NSAttributedStringKey.foregroundColor: UIColor.gray],
                                           for: .normal)
        
        navigationItem.leftBarButtonItem = barLeftItem
        
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        view.addSubview(tableView)
        tableView.addConstraints(fromStringArray: ["V:|-8-[$self]|",
                                                   "H:|[$self]|"])
        tableView.register(KPRegionTableViewCell.self,
                           forCellReuseIdentifier: KPLocationSelectViewController.KPCountryCellReuseIdentifier)
        tableView.register(KPCityTableViewCell.self,
                           forCellReuseIdentifier: KPLocationSelectViewController.KPCityCellReuseIdentifier)
        
    }
    
//    override open var preferredStatusBarStyle: UIStatusBarStyle {
//        return .default
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleDismissButtonOnTapped() {
        dismiss(animated: true, completion: nil)
//        appModalController()?.dismissControllerWithDefaultDuration()
    }
}


extension KPLocationSelectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cityData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 64
        } else {
            return 48
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == expandedIndex {
            return cityData[section].cities.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier:KPLocationSelectViewController.KPCountryCellReuseIdentifier,
                                                     for: indexPath) as! KPRegionTableViewCell
            cell.selectionStyle = .none
            
            if indexPath.section == cityData.count - 1 {
                cell.shouldShowSeparator = false
            } else {
                cell.shouldShowSeparator = true
            }
            
            if let expandedIndex = expandedIndex,
               indexPath.section == expandedIndex {
                cell.setExpanded(true, false)
            } else {
                cell.setExpanded(false, false)
            }
            cell.expandIcon.isHidden = false
            cell.regionIcon.image = cityData[indexPath.section].icon
            cell.regionLabel.text = cityData[indexPath.section].name
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:KPLocationSelectViewController.KPCityCellReuseIdentifier,
                                                     for: indexPath) as! KPCityTableViewCell
            cell.cityLabel.text = cityData[indexPath.section].cities[indexPath.row-1].name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            tableView.beginUpdates()

            if let expandedIndex = expandedIndex {
                if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: expandedIndex)) as? KPRegionTableViewCell {
                    cell.setExpanded(false, true)
                }
                var deleteIndexPaths = [IndexPath]()
                for (index, _) in cityData[expandedIndex].cities.enumerated() {
                    deleteIndexPaths.append(IndexPath(row: index + 1, section: expandedIndex))
                }
                tableView.deleteRows(at: deleteIndexPaths, with: .top)
            }
            
            if expandedIndex != indexPath.section {
                expandedIndex = indexPath.section
                if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section)) as? KPRegionTableViewCell {
                    cell.setExpanded(true, true)
                }
                var insertIndexPaths = [IndexPath]()
                for (index, _) in cityData[indexPath.section].cities.enumerated() {
                    insertIndexPaths.append(IndexPath(row: index + 1, section: indexPath.section))
                }
                tableView.insertRows(at: insertIndexPaths, with: .top)
            } else {
                expandedIndex = nil
            }
            
            tableView.endUpdates()
        }
    }
    
}

