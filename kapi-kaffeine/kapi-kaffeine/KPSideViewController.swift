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
    var lastY: CGFloat = 0.0
    
    lazy var userContainer: UIView = {
        let containerView = UIView();
        containerView.backgroundColor = KPColorPalette.KPMainColor.buttonColor;
        return containerView;
    }()
    
    lazy var userPhoto: UIImageView = {
        let imageView = UIImageView();
        imageView.backgroundColor = KPColorPalette.KPMainColor.mainColor;
        imageView.layer.borderWidth = 2.0;
        imageView.layer.borderColor = UIColor.white.cgColor;
        imageView.layer.cornerRadius = 5.0;
        imageView.layer.masksToBounds = true;
        return imageView;
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel();
        label.font = UIFont.systemFont(ofSize: 14.0);
        label.textColor = KPColorPalette.KPTextColor.whiteColor;
        label.text = "訪客一號";
        return label;
    }()
    
    lazy var chooseLabel: UILabel = {
        let label = UILabel();
        label.font = UIFont.systemFont(ofSize: 12.0);
        label.textColor = KPColorPalette.KPMainColor.buttonColor;
        label.text = "請選擇你所在的城市";
        return label;
    }()
    
    var tableView: UITableView!
    
    
    struct regionData {
        var name: String
        var icon: UIImage
        var cities: [String]
    }
    
    struct informationData {
        var title: String
        var icon: UIImage
        var handler: () -> ()
    }
    
    
    var regionContents = [regionData?]()
    var regionIconNames = ["icon_taipei", "icon_taitung", "icon_pingtung"]
    
    var informationSectionContents = [informationData?]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        
        self.view.addSubview(self.userContainer);
        self.userContainer.addConstraints(fromStringArray: ["V:|[$self(140)]", "H:|[$self]|"]);
        
        self.userContainer.addSubview(self.userPhoto);
        self.userPhoto.addConstraints(fromStringArray: ["H:|-16-[$self(64)]",
                                                        "V:|-16-[$self(64)]"])
        
        self.userContainer.addSubview(self.userNameLabel);
        self.userNameLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                            "V:[$view0]-8-[$self]"],
                                          views: [self.userPhoto]);
        
        self.view.addSubview(self.chooseLabel);
        self.chooseLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                          "V:[$view0]-16-[$self]"],
                                        views: [self.userContainer]);
        
        self.tableView = UITableView();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorColor = UIColor.clear;
//        self.tableView.bounces = false;
        self.view.addSubview(self.tableView);
        self.tableView.addConstraints(fromStringArray: ["V:[$view0]-16-[$self]|",
                                                        "H:|[$self]|"],
                                      views: [self.chooseLabel]);
        self.tableView.register(KPRegionTableViewCell.self,
                                forCellReuseIdentifier: KPSideViewController.KPSideViewControllerRegionCellReuseIdentifier);
        self.tableView.register(KPCityTableViewCell.self,
                                forCellReuseIdentifier: KPSideViewController.KPSideViewControllerCityCellReuseIdentifier);

        self.regionContents = [regionData(name:"北部",
                                          icon:UIImage.init(named: "icon_taitung")!,
                                          cities:["台北", "中壢", "月球"]),
                               regionData(name:"東部",
                                          icon:UIImage.init(named: "icon_taitung")!,
                                          cities:["外太空", "黑洞", "冥王星"]),
                               regionData(name:"中南部",
                                          icon:UIImage.init(named: "icon_taitung")!,
                                          cities:["台北", "台中"])];
        
        self.informationSectionContents = [informationData(title:"關於我們",
                                                           icon:UIImage.init(named: "icon_taitung")!,
                                                           handler:{()->() in
                                                            let controller = KPModalViewController()
                                                            controller.contentSize = CGSize.init(width: 320,
                                                                                                 height: 568);
                                                            let aboutUsController = KPAboutUsViewController()
                                                            let navigationController = UINavigationController.init(rootViewController: aboutUsController);
                                                            
                                                            
                                                            controller.contentController = navigationController;
//                                                            controller.presentModalView();
                                                            self.dismiss(animated: true,
                                                                         completion: {
                                                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2,
                                                                                                          execute: { 
//                                                                                   controller.presentModalView();
                                                                            })
//                                                                  controller.presentModalView();
                                                            })
                                            }),
                                           informationData(title:"聯絡我們",
                                                           icon:UIImage.init(named: "icon_taitung")!,
                                                           handler:{()->() in
                                                            let controller = KPModalViewController()
                                                            controller.edgeInset = UIEdgeInsets.init(top: 0,
                                                                                                     left: 0,
                                                                                                     bottom: 0,
                                                                                                     right: 0);
                                                            let profileController = KPUserProfileViewController()
                                                            let navigationController = UINavigationController.init(rootViewController: profileController);
                                                            controller.contentController = navigationController;
                                                            controller.presentModalView();
                                           }),
                                           informationData(title:"粉絲專頁",
                                                           icon:UIImage.init(named: "icon_taitung")!,
                                                           handler:{()->() in
                                                            print("粉絲專頁")}),
                                           informationData(title:"幫我們評分",
                                                           icon:UIImage.init(named: "icon_taitung")!,
                                                           handler:{()->() in
                                                            print("幫我們評分")}),
                                           informationData(title:"設定",
                                                           icon:UIImage.init(named: "icon_taitung")!,
                                                           handler:{()->() in
                                                            let controller = KPModalViewController()
                                                            controller.edgeInset = UIEdgeInsets.init(top: 0,
                                                                                                     left: 0,
                                                                                                     bottom: 0,
                                                                                                     right: 0);
                                                            let settingController = KPSettingViewController()
                                                            let navigationController = UINavigationController.init(rootViewController: settingController);
                                                            controller.contentController = navigationController;
                                                            controller.presentModalView();
                                           }),
        ]
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
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let currentY = scrollView.contentOffset.y
//        let currentBottomY = scrollView.frame.size.height + currentY
//        if currentY > lastY {
//            tableView.bounces = true
//        } else {
//            if currentBottomY < scrollView.contentSize.height + scrollView.contentInset.bottom {
//                tableView.bounces = false
//            }
//        }
//        lastY = scrollView.contentOffset.y < 0 ? 0 : scrollView.contentOffset.y
//    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0.0;
        } else {
            return 24.0;
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: 1, height: 10));
        let separator = UIView();
        separator.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6;
        footerView.addSubview(separator);
        separator.addConstraints(fromStringArray: ["V:|-10-[$self(1)]-13-|",
                                                   "H:|[$self]|"]);
        return footerView;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            if self.regionContents[indexPath.row] != nil {
                let cell = tableView.dequeueReusableCell(withIdentifier:KPSideViewController.KPSideViewControllerRegionCellReuseIdentifier,
                                                         for: indexPath) as! KPRegionTableViewCell;
                cell.regionLabel.text = self.regionContents[indexPath.row]?.name;
                return cell;
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier:KPSideViewController.KPSideViewControllerCityCellReuseIdentifier,
                                                         for: indexPath) as! KPCityTableViewCell;
                let regionIndex = self.getRegionIndex(expandIndex: indexPath.row);
                var regionContent = self.regionContents[regionIndex];
                cell.cityLabel.text = regionContent?.cities[indexPath.row-regionIndex-1];
                return cell;
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:KPSideViewController.KPSideViewControllerRegionCellReuseIdentifier,
                                                     for: indexPath) as! KPRegionTableViewCell;
            cell.regionLabel.text = self.informationSectionContents[indexPath.row]?.title;
            cell.regionIcon.image = self.informationSectionContents[indexPath.row]?.icon;
            cell.expanded = false;
            return cell;
        }
    }
    
    private func getRegionIndex(expandIndex: Int) -> Int {
       
        var selectedIndex = expandIndex;
        while selectedIndex > 0 {
            if (self.regionContents[selectedIndex-1] != nil) {
                break;
            }
            selectedIndex-=1;
        }
        return selectedIndex-1;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            if self.regionContents[indexPath.row] != nil {
                return 48.0;
            } else {
                return 40.0;
            }
        } else {
            return 48.0;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.regionContents.count
        case 1:
            return self.informationSectionContents.count
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if self.regionContents[indexPath.row] != nil {
                
                let regionCities = self.regionContents[indexPath.row]?.cities;
                
                let cell = tableView.cellForRow(at: indexPath) as! KPRegionTableViewCell;
                
                tableView.beginUpdates()
                
                // 若是最後一行/或是任何一個可展開的區塊 --> 展開
                if indexPath.row + 1 >= self.regionContents.count || self.regionContents[indexPath.row+1] != nil {
                    cell.expanded = true;
                    
                    for (index, _) in (regionCities?.enumerated())! {
                        self.regionContents.insert(nil, at: indexPath.row+index+1);
                        self.tableView.insertRows(at: [NSIndexPath.init(row: indexPath.row+index+1,
                                                                        section: 0) as IndexPath],
                                                  with: .top);
                    }
                } else {
                    cell.expanded = false;
                    
                    var indexPaths = [IndexPath]()
                    for (index, _) in (regionCities?.enumerated())! {
                        indexPaths.append(NSIndexPath.init(row: indexPath.row+index+1, section: 0) as IndexPath);
                        self.regionContents.remove(at: indexPath.row+1);
                    }
                    self.tableView.deleteRows(at: indexPaths, with: .top);
                }
                tableView.endUpdates()

            /*可調整時間的做法
            if self.regionContents[indexPath.row] != nil {
                if indexPath.row + 1 >= self.regionContents.count {
                    for (index, _) in (regionCities?.enumerated())! {
                        self.regionContents.insert(nil, at: indexPath.row+index+1);
                        self.tableView.insertRows(at: [NSIndexPath.init(row: indexPath.row+index+1,
                                                                        section: 0) as IndexPath],
                                                  with: .top);
                        
                    }
                } else {
                    if self.regionContents[indexPath.row+1] != nil {
                        for (_, _) in (regionCities?.enumerated())! {
                            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState, .overrideInheritedDuration], animations: {
                                
                                self.tableView.beginUpdates()
                                self.regionContents.insert(nil, at: indexPath.row+1);
                                self.tableView.insertRows(at: [NSIndexPath.init(row: indexPath.row+1,
                                                                                section: 0) as IndexPath],
                                                          with: .top);
                                
                                self.tableView.endUpdates()
                                
                            }, completion: nil)
                            
                        }
                    } else {
                        var indexPaths = [IndexPath]()
                        for (index, _) in (regionCities?.enumerated())! {
                            indexPaths.append(NSIndexPath.init(row: indexPath.row+index+1, section: 0) as IndexPath);
                                
                            self.regionContents.remove(at: indexPath.row+1);
                        }
                        self.tableView.deleteRows(at: indexPaths, with: .top);
                        
                    }
                }
                 */
                
            } else {
                
            }
        } else {
            self.informationSectionContents[indexPath.row]?.handler();
        }
    }
}


