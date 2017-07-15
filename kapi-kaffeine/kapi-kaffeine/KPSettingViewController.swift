//
//  KPSettingViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/24.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit


enum KPSettingViewCellStyle {
    case normal
    case button
    case switchControl
}

class KPSettingViewController: KPViewController {

    
    struct settingData {
        var title: String
        var information: String?
        var identifier: String
        var cellStyle: KPSettingViewCellStyle
        var handler: (() -> ())?
    }
    
    var dismissButton:UIButton!
    var tableView: UITableView!
    var satisficationView: KPSatisficationView!
    var settingDataContents: [settingData]!
    
    static let KPSettingViewInfoCellReuseIdentifier = "cell"
    static let KPSettingViewSwitchCellReuseIdentifier = "cell-switch"
    static let KPSettingViewButtonCellReuseIdentifier = "cell-button"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = "設定"
        
        dismissButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(6, 7, 8, 7)
        dismissButton.setImage(R.image.icon_close()?.withRenderingMode(.alwaysTemplate),
                                    for: .normal)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.addTarget(self,
                                     action: #selector(KPSettingViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside)
        
        let barItem = UIBarButtonItem(customView: dismissButton)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -7
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        
        dismissButton.addTarget(self,
                                     action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside)
        
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        view.addSubview(tableView)
        tableView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                   "H:|[$self]|"])
        
        tableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: KPSettingViewController.KPSettingViewInfoCellReuseIdentifier)
        tableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: KPSettingViewController.KPSettingViewSwitchCellReuseIdentifier)
        tableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: KPSettingViewController.KPSettingViewButtonCellReuseIdentifier)
        tableView.allowsSelection = true
        
//        settingDataContents = [settingData(title:"應用程式版本",
//                                                information:"1.0.0",
//                                                identifier:KPSettingViewController.KPSettingViewInfoCellReuseIdentifier,
//                                                cellStyle:.normal,
//                                                handler:nil),
//                               settingData(title:"支持我們，讓我們顯示廣告",
//                                           information:nil,
//                                           identifier:KPSettingViewController.KPSettingViewSwitchCellReuseIdentifier,
//                                           cellStyle:.switchControl,
//                                           handler:nil),
//                              settingData(title:"協助填寫問卷，幫助讓產品更好",
//                                        information:nil,
//                                        identifier:KPSettingViewController.KPSettingViewButtonCellReuseIdentifier,
//                                        cellStyle:.button,
//                                        handler:nil)]
        
        settingDataContents = [settingData(title:"應用程式版本",
                                           information:"1.0.0",
                                           identifier:KPSettingViewController.KPSettingViewInfoCellReuseIdentifier,
                                           cellStyle:.normal,
                                           handler:nil),
                               settingData(title:"協助填寫問卷，幫助讓產品更好",
                                           information:nil,
                                           identifier:KPSettingViewController.KPSettingViewButtonCellReuseIdentifier,
                                           cellStyle:.button,
                                           handler:nil)]

        
        if KPUserManager.sharedManager.currentUser != nil {
            settingDataContents.append(
                settingData(title:"登出使用者",
                            information:nil,
                            identifier:KPSettingViewController.KPSettingViewButtonCellReuseIdentifier,
                            cellStyle:.button,
                            handler: {
                                KPUserManager.sharedManager.logOut()
                                self.appModalController()?.dismissControllerWithDefaultDuration()
                }))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleDismissButtonOnTapped() {
        appModalController()?.dismissControllerWithDefaultDuration()
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

extension KPSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1,
                                   reuseIdentifier: self.settingDataContents[indexPath.row].identifier)
        cell.selectionStyle = .none
        self.setupCell(self.settingDataContents[indexPath.row], cell: cell)
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingDataContents.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let handler = self.settingDataContents[indexPath.row].handler {
            handler()
        }
    }
    
    
    func setupCell(_ cellData: settingData, cell: UITableViewCell) {
        
        cell.textLabel?.text = cellData.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cell.textLabel?.textColor = KPColorPalette.KPTextColor.mainColor
        cell.selectionStyle = .none
        
        switch cellData.cellStyle {
        case .normal:
            cell.detailTextLabel?.text = cellData.information
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 16.0)
            cell.detailTextLabel?.textColor = KPColorPalette.KPTextColor.grayColor
        case .button:
            cell.selectionStyle = .default
        case .switchControl:
            let switchControl = UISwitch()
            switchControl.onTintColor = KPColorPalette.KPMainColor.mainColor
            cell.contentView.addSubview(switchControl)
            switchControl.addConstraints(fromStringArray: ["H:[$self]-12-|"])
            switchControl.addConstraintForCenterAligningToSuperview(in: .vertical)
        }
    }

}
