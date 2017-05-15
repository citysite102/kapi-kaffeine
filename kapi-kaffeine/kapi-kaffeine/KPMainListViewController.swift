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

class KPMainListViewController: UIViewController, KPMainViewControllerDelegate {
    
    static let KPMainListViewCellReuseIdentifier = "cell";
    
    weak var mainController:KPMainViewController!
    var searchFooterView: KPSearchFooterView!
    var tableView: UITableView!
    var currentDataModel:KPDataModel?
    
    var selectedDataModel: KPDataModel? {
        return self.currentDataModel
    }
    
    var displayDataModel: [KPDataModel] = [KPDataModel]() {
        didSet {
            self.tableView.reloadData();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.view.addSubview(self.tableView);
        self.tableView.addConstraints(fromStringArray: ["V:|-100-[$self]",
                                                        "H:|[$self]|"]);
        self.tableView.register(KPMainListTableViewCell.self,
                                forCellReuseIdentifier: KPMainListViewController.KPMainListViewCellReuseIdentifier);
        self.tableView.allowsSelection = true;
        
        self.searchFooterView = KPSearchFooterView();
        self.searchFooterView.layer.shadowColor = UIColor.black.cgColor;
        self.searchFooterView.layer.shadowOpacity = 0.15;
        self.searchFooterView.layer.shadowOffset = CGSize.init(width: 0.0, height: -1.0);
        self.view.addSubview(searchFooterView);
        self.searchFooterView.addConstraints(fromStringArray: ["V:[$view0][$self(40)]|", "H:|[$self]|"],
                                             views:[self.tableView]);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
 
}

extension KPMainListViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:KPMainListViewController.KPMainListViewCellReuseIdentifier,
                                                 for: indexPath) as! KPMainListTableViewCell;
        
        cell.selectionStyle = .none;
        cell.dataModel = self.displayDataModel[indexPath.row]
        cell.shopStatusContent = (self.displayDataModel[indexPath.row].openTime! as String).replacingOccurrences(of: "~", with: "-");
        cell.scoreLabel.score = "\(self.displayDataModel[indexPath.row].score!.format(f: ".1"))";
        
        
//        let openedTime:[String] = (cell.shopStatusLabel.text?.components(separatedBy: "-"))!;
//        let startTime: String = openedTime[0];
//        let endTime: String = openedTime[0];
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
        
        return cell;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayDataModel.count;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentDataModel = self.displayDataModel[indexPath.row];
        self.mainController.performSegue(withIdentifier: "datailedInformationSegue", sender: self);
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
