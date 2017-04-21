//
//  KPSideViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/19.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSideViewController: UIViewController {

    static let KPSideViewControllerRegionCellReuseIdentifier = "regionCell";
    static let KPSideViewControllerCityCellReuseIdentifier = "cityCell";
    
    weak var mainController: KPMainViewController!
    var userContainer: UIView!
    var userPhoto: UIImageView!
    var userNameLabel: UILabel!
    
    var tableView: UITableView!
    
    
    struct regionData {
        
        public var name: String
        public var cities: [String]
        
        init(name: String, cities: [String]?) {
            self.name = name
            self.cities = cities!
        }
    }
    
    
    var regionContents = [regionData?]()
    var regionIconNames = ["icon_taipei", "icon_taitung", "icon_pingtung"]
//    var regionData = ["北部": ["台北", "中壢"],
//                      "東部": ["外太空", "黑洞", "冥王星"],
//                      "中南部": ["台中"],
//                      ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        
        self.userContainer = UIView();
        self.userContainer.backgroundColor = KPColorPalette.KPMainColor.buttonColor;
        self.view.addSubview(self.userContainer);
        self.userContainer.addConstraints(fromStringArray: ["V:|[$self(140)]", "H:|[$self]|"]);
        
        self.userPhoto = UIImageView();
        self.userPhoto.backgroundColor = KPColorPalette.KPMainColor.mainColor;
        self.userPhoto.layer.borderWidth = 2.0;
        self.userPhoto.layer.borderColor = UIColor.white.cgColor;
        self.userPhoto.layer.cornerRadius = 5.0;
        self.userPhoto.layer.masksToBounds = true;
        self.userContainer.addSubview(self.userPhoto);
        self.userPhoto.addConstraints(fromStringArray: ["H:|-16-[$self(64)]",
                                                        "V:|-16-[$self(64)]"])
        
        self.userNameLabel = UILabel();
        self.userNameLabel.font = UIFont.systemFont(ofSize: 14.0);
        self.userNameLabel.textColor = KPColorPalette.KPTextColor.whiteColor;
        self.userNameLabel.text = "訪客一號";
        self.userContainer.addSubview(self.userNameLabel);
        self.userNameLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                            "V:[$view0]-8-[$self]"],
                                          views: [self.userPhoto]);
        
        self.tableView = UITableView();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = UIColor.clear;
        self.view.addSubview(self.tableView);
        self.tableView.addConstraints(fromStringArray: ["V:[$view0]-32-[$self]|",
                                                        "H:|[$self]|"],
                                      views: [self.userContainer]);
        self.tableView.register(KPRegionTableViewCell.self,
                                forCellReuseIdentifier: KPSideViewController.KPSideViewControllerRegionCellReuseIdentifier);
        self.tableView.register(KPCityTableViewCell.self,
                                forCellReuseIdentifier: KPSideViewController.KPSideViewControllerCityCellReuseIdentifier);
        self.tableView.allowsSelection = true;
        
        self.regionContents = [regionData(name:"北部", cities:["台北", "中壢"]),
                               regionData(name:"東部", cities:["外太空", "黑洞", "冥王星"]),
                               regionData(name:"中南部", cities:["台北", "台中"])];
//        self.regionContents = [regionData(name:"北部", cities:["台北"]),
//                               regionData(name:"東部", cities:["外太空"]),
//                               regionData(name:"中南部", cities:["台北"])];
//        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        DispatchQueue.main.async(execute: {
            if let window = UIApplication.shared.keyWindow {
                window.windowLevel = UIWindowLevelStatusBar - 1;
            }
        })
        self.mainController.opacityView.isHidden = true;
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

extension KPSideViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.regionContents[indexPath.row] != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier:KPSideViewController.KPSideViewControllerRegionCellReuseIdentifier,
                                                     for: indexPath) as! KPRegionTableViewCell;
            return cell;
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:KPSideViewController.KPSideViewControllerCityCellReuseIdentifier,
                                                     for: indexPath) as! KPCityTableViewCell;
            return cell;
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.regionContents[indexPath.row] != nil {
            return 48.0;
        } else {
            return 40.0;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.regionContents.count;
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let regionCities = self.regionContents[indexPath.row]?.cities;

        
        if self.regionContents[indexPath.row] != nil {
//            UIView.beginAnimations(nil, context: nil);
//            UIView.setAnimationDuration(0.5);
//            CATransaction.begin()
//            CATransaction.setAnimationDuration(5.0);
//            CATransaction.setCompletionBlock({
//                print("Finished");
//            })
            
            tableView.beginUpdates()
            if indexPath.row + 1 >= self.regionContents.count {
                for (index, _) in (regionCities?.enumerated())! {
                    self.regionContents.insert(nil, at: indexPath.row+index+1);
                    self.tableView.insertRows(at: [NSIndexPath.init(row: indexPath.row+index+1,
                                                                    section: 0) as IndexPath],
                                              with: .top);
                    
                }
            } else {
                if self.regionContents[indexPath.row+1] != nil {
                    for (index, _) in (regionCities?.enumerated())! {
                        self.regionContents.insert(nil, at: indexPath.row+index+1);
                        self.tableView.insertRows(at: [NSIndexPath.init(row: indexPath.row+index+1,
                                                                        section: 0) as IndexPath],
                                                  with: .top);
                        
                    }
                } else {
                    var indexPaths = [IndexPath]()
                    for (index, _) in (regionCities?.enumerated())! {
                        indexPaths.append(NSIndexPath.init(row: indexPath.row+index+1, section: 0) as IndexPath);
                            
                        self.regionContents.remove(at: indexPath.row+1);
//                        self.tableView.deleteRows(at: [NSIndexPath.init(row: indexPath.row+1,
//                                                                        section: 0) as IndexPath], with: .top);
                        
                    }
                    self.tableView.deleteRows(at: indexPaths, with: .top);
                    
                }
            }
            tableView.endUpdates()
//            CATransaction.commit();
//            UIView.commitAnimations()
        } else {
//            for (index, _) in (regionCities?.enumerated())! {
//                self.regionContents.insert(nil, at: indexPath.row+index+1);
//                self.tableView.insertRows(at: [NSIndexPath.init(row: indexPath.row+index+1, section: 0) as IndexPath],
//                                          with: .top);
//                
//            }
//            for (index, _) in (regionCities?.enumerated())! {
//                self.regionContents.
//                self.tableView.insertRows(at: [NSIndexPath.init(row: indexPath.row+index+1, section: 0) as IndexPath],
//                                          with: .top);
//                
//            }
        }
    }
}


