//
//  KPSearchViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/15.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchViewController: UIViewController {

    static let KPSearchViewControllerDefaultCellReuseIdentifier = "cell";
    static let KPSearchViewControllerRecentCellReuseIdentifier = "cell_recent";
    
    var dismissButton:UIButton!
    var tableView: UITableView!
    
    var displayDataModel: [KPDataModel] = [KPDataModel]()
    var filteredDataModel: [KPDataModel] = [KPDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white;
        
        self.dismissButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24));
        self.dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        self.dismissButton.setImage(UIImage.init(named: "icon_close")?.withRenderingMode(.alwaysTemplate),
                                    for: .normal);
        self.dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        self.dismissButton.addTarget(self,
                                     action: #selector(KPSearchConditionViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside);
        
        let barItem = UIBarButtonItem.init(customView: self.dismissButton);
        self.navigationItem.leftBarButtonItem = barItem;
        
        self.dismissButton.addTarget(self,
                                     action: #selector(KPSearchViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside);
        
        self.tableView = UITableView();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.view.addSubview(self.tableView);
        self.tableView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                        "H:|[$self]|"]);
        self.tableView.register(KPSearchViewDefaultCell.self,
                                forCellReuseIdentifier: KPSearchViewController.KPSearchViewControllerDefaultCellReuseIdentifier);
        self.tableView.register(KPSearchViewRecentCell.self,
                                forCellReuseIdentifier: KPSearchViewController.KPSearchViewControllerRecentCellReuseIdentifier);
        self.tableView.allowsSelection = true;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleDismissButtonOnTapped() {
        self.appModalController()?.dismissControllerWithDefaultDuration();
    }
}

extension KPSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:KPSearchViewController.KPSearchViewControllerDefaultCellReuseIdentifier,
                                                 for: indexPath) as! KPSearchViewDefaultCell;
        cell.demoLabel.text = self.displayDataModel[indexPath.row].name
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
//        self.currentDataModel = self.displayDataModel[indexPath.row];
//        self.mainController.performSegue(withIdentifier: "datailedInformationSegue", sender: self);
    }
}
