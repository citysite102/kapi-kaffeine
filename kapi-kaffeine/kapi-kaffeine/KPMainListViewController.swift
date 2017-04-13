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

class KPMainListViewController: UIViewController {
    
    static let KPMainListViewCellReuseIdentifier = "cell";
    
    weak var mainController:KPMainViewController!
    var tableView: UITableView!
    var selectedDataModel:KPDataModel!
    
    var displayDataModel: [KPDataModel]! {
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
        self.tableView.addConstraints(fromStringArray: ["V:|-100-[$self]|",
                                                        "H:|[$self]|"]);
        self.tableView.register(KPMainListTableViewCell.self,
                                forCellReuseIdentifier: KPMainListViewController.KPMainListViewCellReuseIdentifier);
        
        if let dataURL = Bundle.main.url(forResource: "cafes",
                                         withExtension: "json") {
            do {
                let data = try String(contentsOf: dataURL)
                self.displayDataModel = Mapper<KPDataModel>().mapArray(JSONString: data) ?? []
            } catch {
                print("Failed to load cafes.json file")
            }
        }
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
        cell.shopNameLabel.text = self.displayDataModel[indexPath.row].name;
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayDataModel.count;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedDataModel = self.displayDataModel[indexPath.row];
        self.mainController.performSegue(withIdentifier: "datailedInformationSegue", sender: self);
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
