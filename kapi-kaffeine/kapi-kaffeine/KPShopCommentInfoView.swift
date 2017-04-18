//
//  KPShopCommentInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopCommentInfoView: UIView {

    static let KPShopCommentInfoCellReuseIdentifier = "cell";
    
    weak var mainController:KPMainViewController!
    var tableView: UITableView!
    var selectedDataModel:KPDataModel!
    
    var displayDataModel: [KPDataModel]! {
        didSet {
            self.tableView.reloadData();
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
        
        self.tableView = UITableView();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.addSubview(self.tableView);
        self.tableView.addConstraints(fromStringArray: ["V:|[$self(340)]|",
                                                        "H:|[$self]|"]);
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.tableView = UITableView();
//        self.tableView.delegate = self;
//        self.tableView.dataSource = self;
//        self.addSubview(self.tableView);
//        self.tableView.addConstraints(fromStringArray: ["V:|[$self]|",
//                                                        "H:|[$self]|"]);
//        self.tableView.register(KPMainListTableViewCell.self,
//                                forCellReuseIdentifier: KPShopCommentInfoView.KPShopCommentInfoCellReuseIdentifier);
//        
//        if let dataURL = Bundle.main.url(forResource: "cafes",
//                                         withExtension: "json") {
//            do {
//                let data = try String(contentsOf: dataURL)
//                self.displayDataModel = Mapper<KPDataModel>().mapArray(JSONString: data) ?? []
//            } catch {
//                print("Failed to load cafes.json file")
//            }
//        }
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//        
//    }
    
}

extension KPShopCommentInfoView: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:KPShopCommentInfoView.KPShopCommentInfoCellReuseIdentifier,
                                                 for: indexPath) as! KPMainListTableViewCell;
        
        cell.selectionStyle = .none;
        cell.shopNameLabel.text = self.displayDataModel[indexPath.row].name;
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedDataModel = self.displayDataModel[indexPath.row];
        self.mainController.performSegue(withIdentifier: "datailedInformationSegue", sender: self);
    }
}
