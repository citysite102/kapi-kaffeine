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

class KPMainListViewController:
    KPViewController,
    KPMainViewControllerDelegate,
    KPSearchFooterViewDelegate {
    
    static let KPMainListViewCellReuseIdentifier = "cell"
    static let KPMainListViewLoadingCellReuseIdentifier = "cell_loading"
    
    weak var mainController:KPMainViewController!
    var tableView: UITableView!
    
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
//    private var snapShot: UIImage? {
//        get {
//            UIGraphicsBeginImageContextWithOptions(self.tableView.bounds.size,
//                                                   true,
//                                                   UIScreen.main.scale)
//            self.tableView.drawHierarchy(in: self.tableView.bounds,
//                                         afterScreenUpdates: true)
//            let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//            return wholeImage
//        }
//    }
    
    var selectedDataModel: KPDataModel? {
        return currentDataModel
    }
    
    var displayDataModel: [KPDataModel] = [KPDataModel]() {
        didSet {
            dataLoading = false
            self.tableView.isUserInteractionEnabled = true
            self.tableView.allowsSelection = true
            self.tableView.reloadData()
        }
    }
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func searchFooterView(_ searchFooterView: KPSearchFooterView,
                          didSelectItemWith name: String) {
        print("Footer Name:\(name)")
    }
}

extension KPMainListViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !dataLoading {
        
            let cell = tableView.dequeueReusableCell(withIdentifier:KPMainListViewController.KPMainListViewCellReuseIdentifier,
                                                     for: indexPath) as! KPMainListTableViewCell
            
            cell.selectionStyle = .none
            cell.dataModel = self.displayDataModel[indexPath.row]
//            cell.shopStatusContent = (self.displayDataModel[indexPath.row].openTime! as String).replacingOccurrences(of: "~", with: "-")
//            cell.scoreLabel.score = "\(self.displayDataModel[indexPath.row].score!.format(f: ".1"))"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:KPMainListViewController.KPMainListViewLoadingCellReuseIdentifier,
                                                     for: indexPath) as! KPDefaultLoadingTableCell
            return cell
        }
//        let openedTime:[String] = (cell.shopStatusLabel.text?.components(separatedBy: "-"))!
//        let startTime: String = openedTime[0]
//        let endTime: String = openedTime[0]
//        let hourIndex = startTime.index(startTime.startIndex, offsetBy: 2)
//        let minutesIndex = startTime.index(startTime.startIndex, offsetBy: 3)
//        
//        let startHour:Int = Int(startTime.substring(to: hourIndex))!
//        let startMinute:Int = Int(startTime.substring(from: minutesIndex))!
//        
//        let endHour:Int = Int(startTime.substring(to: hourIndex))!
//        let endMinute:Int = Int(startTime.substring(from: minutesIndex))!
//        
//        let currentDateComponent = NSCalendar.current.dateComponents([.hour, .minute], from: Date())
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataLoading ? 8 : self.displayDataModel.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentDataModel = self.displayDataModel[indexPath.row]
        self.mainController.performSegue(withIdentifier: "datailedInformationSegue", sender: self)
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
