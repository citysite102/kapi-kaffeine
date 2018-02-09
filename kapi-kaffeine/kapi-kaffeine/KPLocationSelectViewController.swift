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
    
    var tableView: UITableView!
    struct informationData {
        var title: String
        var icon: UIImage
        var handler: () -> ()
    }
    
    var defaultExpandedIndexPath: IndexPath?
    var defaultSelectedIndexPath: IndexPath?
    var selectedCityKey: String! {
        didSet {
            defaultExpandedIndexPath = nil
            regionContents = KPCityRegionModel.defaultRegionData
            
            var expandedIndex: Int?
            var selectedIndex: Int?
            
            for (index, region) in KPCityRegionModel.defaultRegionData.enumerated() {
                for cityKey in region.cityKeys {
                    if cityKey == selectedCityKey {
                        expandedIndex = index
                        selectedIndex = index
                    }
                }
            }
            
            if let expandedIndex = expandedIndex, let selectedIndex = selectedIndex {
                let regionCities = regionContents[expandedIndex]?.cities
                for (index, _) in (regionCities?.enumerated())! {
                    regionContents.insert(nil, at: expandedIndex+index+1)
                }
                defaultExpandedIndexPath = IndexPath(row: expandedIndex, section: 0)
                if tableView != nil {
                    tableView.reloadData()
                    tableView.selectRow(at: defaultSelectedIndexPath,
                                        animated: false,
                                        scrollPosition: .bottom)
                } else {
                    defaultSelectedIndexPath = IndexPath(row: expandedIndex+selectedIndex,
                                                         section: 0)
                }
            }
            
        }
    }
    
    var expandedIndexPath: IndexPath?
    var regionContents = [regionData?]()
    var informationSectionContents = [informationData?]()
    
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
        
        
        if selectedCityKey == nil {
            regionContents = KPCityRegionModel.defaultRegionData
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleDismissButtonOnTapped() {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
}


extension KPLocationSelectViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0.0
        } else {
            return 24.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 10))
        let separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        footerView.addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:|-10-[$self(1)]-13-|",
                                                   "H:|[$self]|"])
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            if regionContents[indexPath.row] != nil {
                let cell = tableView.dequeueReusableCell(withIdentifier:KPLocationSelectViewController.KPCountryCellReuseIdentifier,
                                                         for: indexPath) as! KPRegionTableViewCell
                cell.selectionStyle = .none
                if indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1 {
                    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
                    cell.shouldShowSeparator = false
                } else {
                    cell.shouldShowSeparator = true
                }
                cell.setExpanded(regionContents[indexPath.row]!.expanded, false)
                cell.expandIcon.isHidden = false
                cell.regionIcon.image = regionContents[indexPath.row]?.icon
                cell.regionLabel.text = regionContents[indexPath.row]?.name
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier:KPLocationSelectViewController.KPCityCellReuseIdentifier,
                                                         for: indexPath) as! KPCityTableViewCell
                let regionIndex = getRegionIndex(expandIndex: indexPath.row)
                var regionContent = regionContents[regionIndex]
                cell.cityLabel.text = regionContent?.cities[indexPath.row-regionIndex-1]
                return cell
            }
        } else {
            
            if indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1 {
                tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier:KPSideViewController.KPSideViewControllerRegionCellReuseIdentifier,
                                                     for: indexPath) as! KPRegionTableViewCell
            cell.selectionStyle = .none
            cell.regionLabel.text = informationSectionContents[indexPath.row]?.title
            cell.regionIcon.image = informationSectionContents[indexPath.row]?.icon
            cell.expandIcon.isHidden = true
            cell.setExpanded(false, false)
            return cell
        }
    }
    
    private func getRegionIndex(expandIndex: Int) -> Int {
        
        var selectedIndex = expandIndex
        while selectedIndex > 0 {
            if (regionContents[selectedIndex-1] != nil) {
                break
            }
            selectedIndex-=1
        }
        return selectedIndex-1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            if regionContents[indexPath.row] != nil {
                return 64.0
            } else {
                return 48.0
            }
        } else {
            return 64.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return regionContents.count
        case 1:
            return informationSectionContents.count
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if regionContents[indexPath.row] != nil {

                let regionCities = regionContents[indexPath.row]?.cities
                let cell = tableView.cellForRow(at: indexPath) as! KPRegionTableViewCell

                // 若是最後一行/或是任何一個可展開的區塊 --> 展開
                if indexPath.row + 1 >= regionContents.count || regionContents[indexPath.row+1] != nil {

                    var indexPaths = [IndexPath]()

                    if expandedIndexPath == nil && defaultExpandedIndexPath != nil {
                        expandedIndexPath = defaultSelectedIndexPath
                        defaultExpandedIndexPath = nil
                    }

                    if var expandedIndexPath = expandedIndexPath {

                        if let expandedRigionCities = regionContents[expandedIndexPath.row]?.cities {
                            tableView.beginUpdates()

                            if let expandedCell = tableView.cellForRow(at: expandedIndexPath) as? KPRegionTableViewCell {
                                expandedCell.setExpanded(false, true)
                            }
                            regionContents[expandedIndexPath.row]?.expanded = false
                            regionContents[indexPath.row]?.expanded = true

                            for (index, _) in (expandedRigionCities.enumerated()) {
                                indexPaths.append(NSIndexPath(row: expandedIndexPath.row+index+1, section: 0) as IndexPath)
                                regionContents.remove(at: expandedIndexPath.row+1)
                            }

                            tableView.deleteRows(at: indexPaths, with: .top)
                            cell.setExpanded(true, true)

                            if expandedIndexPath.row < indexPath.row {
                                for (index, _) in (regionCities?.enumerated())! {
                                    regionContents.insert(nil, at: indexPath.row+index+1-(expandedRigionCities.count))
                                    tableView.insertRows(at: [NSIndexPath(row: indexPath.row+index+1-(expandedRigionCities.count),
                                                                          section: 0) as IndexPath],
                                                         with: .top)
                                }
                            } else {
                                for (index, _) in (regionCities?.enumerated())! {
                                    regionContents.insert(nil, at: indexPath.row+index+1)
                                    tableView.insertRows(at: [NSIndexPath(row: indexPath.row+index+1,
                                                                          section: 0) as IndexPath],
                                                         with: .top)
                                }
                            }

                            tableView.endUpdates()
                            self.expandedIndexPath = tableView.indexPath(for: cell)!
                        }

                    } else {
                        tableView.beginUpdates()
                        cell.setExpanded(true, true)
                        regionContents[indexPath.row]?.expanded = true
                        expandedIndexPath = tableView.indexPath(for: cell)
                        //                        expandedCell = cell
                        for (index, _) in (regionCities?.enumerated())! {
                            regionContents.insert(nil, at: indexPath.row+index+1)
                            tableView.insertRows(at: [NSIndexPath(row: indexPath.row+index+1,
                                                                  section: 0) as IndexPath],
                                                 with: .top)
                        }
                        tableView.endUpdates()
                    }
                } else {
                    tableView.beginUpdates()
                    cell.setExpanded(false, true)
                    regionContents[indexPath.row]?.expanded = false
                    //                    if expandedIndexPath == tableView.indexPath(for: cell) {
                    expandedIndexPath = nil
                    //                    }
                    var indexPaths = [IndexPath]()
                    for (index, _) in (regionCities?.enumerated())! {
                        indexPaths.append(NSIndexPath(row: indexPath.row+index+1, section: 0) as IndexPath)
                        regionContents.remove(at: indexPath.row+1)
                    }
                    tableView.deleteRows(at: indexPaths, with: .top)
                    tableView.endUpdates()
                }
            
//            if regionContents[indexPath.row] != nil {
//                let regionCities = regionContents[indexPath.row]?.cities
//                if indexPath.row + 1 >= regionContents.count {
//                    for (index, _) in (regionCities?.enumerated())! {
//                        regionContents.insert(nil, at: indexPath.row+index+1)
//                        tableView.insertRows(at: [NSIndexPath(row: indexPath.row+index+1,
//                                                              section: 0) as IndexPath],
//                                             with: .top)
//
//                    }
//                } else {
//                    if regionContents[indexPath.row+1] != nil {
//                        for (_, _) in (regionCities?.enumerated())! {
//                            UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: [.beginFromCurrentState, .overrideInheritedDuration], animations: {
//
//                                tableView.beginUpdates()
//                                self.regionContents.insert(nil, at: indexPath.row+1)
//                                tableView.insertRows(at: [NSIndexPath(row: indexPath.row+1,
//                                                                      section: 0) as IndexPath],
//                                                     with: .top)
//
//                                tableView.endUpdates()
//
//                            }, completion: nil)
//
//                        }
//                    } else {
//                        var indexPaths = [IndexPath]()
//                        for (index, _) in (regionCities?.enumerated())! {
//                            indexPaths.append(NSIndexPath(row: indexPath.row+index+1, section: 0) as IndexPath)
//
//                            self.regionContents.remove(at: indexPath.row+1)
//                        }
//                        tableView.deleteRows(at: indexPaths, with: .top)
//
//                    }
//                }
            
            } else {
                let regionIndex = getRegionIndex(expandIndex: indexPath.row)
                let regionContent = regionContents[regionIndex]
                dismiss(animated: true, completion: nil)
            }
        } else {
            informationSectionContents[indexPath.row]?.handler()
        }
    }
    
    func resetTableview() {
        expandedIndexPath = nil
        regionContents = KPCityRegionModel.defaultRegionData
        tableView.reloadData()
    }
}

