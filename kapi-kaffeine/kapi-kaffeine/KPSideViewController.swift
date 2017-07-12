//
//  KPSideViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/19.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import SideMenu

class KPSideViewController: KPViewController {

    static let KPSideViewControllerRegionCellReuseIdentifier = "regionCell"
    static let KPSideViewControllerCityCellReuseIdentifier = "cityCell"
    static let defaultRegionContent = [regionData(name:"北部",
                                                  icon:R.image.icon_taipei()!,
                                                  cities:["台北", "基隆", "桃園", "新竹"],
                                                  cityKeys:["taipei", "keelung", "taoyuan", "hsinchu"]),
                                       regionData(name:"東部",
                                                  icon:R.image.icon_taitung()!,
                                                  cities:["宜蘭", "花蓮", "台東", "澎湖"],
                                                  cityKeys:["yilan", "hualien", "taitung", "penghu"]),
                                       regionData(name:"中部",
                                                  icon:R.image.icon_taichung()!,
                                                  cities:["苗栗", "台中", "南投", "彰化", "雲林"],
                                                  cityKeys:["miaoli", "taichung", "nantou", "changhua", "yunlin"]),
                                       regionData(name:"南部",
                                                  icon:R.image.icon_pingtung()!,
                                                  cities:["嘉義", "台南", "高雄", "屏東"],
                                                  cityKeys:["chiayi", "tainan", "kaohsiung", "pingtung"])]
    
    weak var mainController: KPMainViewController!
    var lastY: CGFloat = 0.0
    
    
    var tapGesture: UITapGestureRecognizer!
    
    lazy var userContainer: KPBounceView = {
        let containerView = KPBounceView()
        containerView.backgroundColor = KPColorPalette.KPMainColor.mainColor
        return containerView
    }()
    
    lazy var userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = KPColorPalette.KPMainColor.mainColor
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 5.0
        imageView.layer.masksToBounds = true
        imageView.image = R.image.demo_profile()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        label.text = "訪客一號"
        return label
    }()
    
    var userExpView: KPExpView!
    
    lazy var chooseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPMainColor.mainColor
        label.text = "請選擇你所在的城市"
        return label
    }()
    
    var tableView: UITableView!
    
    
    struct regionData {
        var name: String
        var icon: UIImage
        var cities: [String]
        var cityKeys: [String]
    }
    
    struct informationData {
        var title: String
        var icon: UIImage
        var handler: () -> ()
    }
    
    
    
    
    var regionContents = [regionData?]()
    var informationSectionContents = [informationData?]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(userContainer)
        userContainer.addConstraints(fromStringArray: ["V:|[$self(150)]",
                                                       "H:|[$self]|"])
        
        userContainer.addSubview(userPhoto)
        userPhoto.addConstraints(fromStringArray: ["H:|-16-[$self(64)]",
                                                   "V:|-16-[$self(64)]"])
        
        userContainer.addSubview(userNameLabel)
        userNameLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                       "V:[$view0]-8-[$self]"],
                                          views: [userPhoto])
        
        userExpView = KPExpView()
        userContainer.addSubview(userExpView)
        userExpView.addConstraints(fromStringArray: ["H:|-16-[$self(100)]",
                                                     "V:[$self(26)]-12-|"])

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(KPSideViewController.handleUserContainerOnTapped(_:)))
        userContainer.addGestureRecognizer(tapGesture)
        
        view.addSubview(chooseLabel)
        chooseLabel.addConstraints(fromStringArray: ["H:|-16-[$self]",
                                                     "V:[$view0]-16-[$self]"],
                                        views: [userContainer])
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        view.addSubview(tableView)
        tableView.addConstraints(fromStringArray: ["V:[$view0]-16-[$self]|",
                                                   "H:|[$self]|"],
                                      views: [chooseLabel])
        tableView.register(KPRegionTableViewCell.self,
                                forCellReuseIdentifier: KPSideViewController.KPSideViewControllerRegionCellReuseIdentifier)
        tableView.register(KPCityTableViewCell.self,
                                forCellReuseIdentifier: KPSideViewController.KPSideViewControllerCityCellReuseIdentifier)

        regionContents = KPSideViewController.defaultRegionContent
        
        informationSectionContents = [informationData(title:"關於我們",
                                                      icon:R.image.icon_cup()!,
                                                      handler:{()->() in
                                                            
                                                        let controller = KPModalViewController()
                                                        controller.edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                                                        let aboutUsController = KPAboutUsViewController()
                                                        let navigationController = UINavigationController(rootViewController: aboutUsController)
                                                        controller.contentController = navigationController
                                                        controller.presentModalView(self, UIModalPresentationStyle.fullScreen)
                                    }),
                                      informationData(title:"聯絡我們",
                                                      icon:R.image.icon_msg()!,
                                                      handler:{()->() in
                                                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                            UIApplication.shared.open(URL(string: "fb-messenger://user-thread/KAPIFind")!,
                                                                                      options: [:], completionHandler: { (completion) in
                                                                                        
                                                            })
                                                        }
                                        }),
                                        informationData(title:"粉絲專頁",
                                                       icon:R.image.icon_fanpage()!,
                                                       handler:{()->() in
                                                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                            
                                                            if let pageURL = URL(string: "fb://profile/255181958274780"),
                                                                UIApplication.shared.canOpenURL(pageURL) {
                                                                UIApplication.shared.open(pageURL,
                                                                                          options: [:],
                                                                                          completionHandler: { (completion) in
                                                                                            
                                                                })
                                                            } else {
                                                                UIApplication.shared.open(URL(string: "https://facebook.com")!,
                                                                                          options: [:],
                                                                                          completionHandler: nil)
                                                            }
                                                            
                                                        }
                                        }),
                                        informationData(title:"幫我們評分",
                                                       icon:R.image.icon_star()!,
                                                       handler:{()->() in
                                                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                            KPPopoverView.popoverDefaultStyleContent("尚未開放",
                                                                                                     "改天再來吧，再見。",
                                                                                                     "遵命", { (content) in
                                                                                                        content.popoverView.dismiss()
                                                            })
                                                        }
                                        }),
                                        informationData(title:"設定",
                                                       icon:R.image.icon_setting()!,
                                                       handler:{()->() in
                                                        let controller = KPModalViewController()
                                                        controller.edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                                                        let settingController = KPSettingViewController()
                                                        let navigationController = UINavigationController(rootViewController: settingController)
                                                        controller.contentController = navigationController
                                                        controller.presentModalView(self,
                                                                                    UIModalPresentationStyle.fullScreen)
                                       })
        ]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainController.opacityView.isHidden = true
        mainController.statusBarShouldBeHidden = false
        UIView.animate(withDuration: 0.15) {
            self.mainController.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    func handleUserContainerOnTapped(_ sender: UITapGestureRecognizer) {
        let controller = KPModalViewController()
        controller.edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let profileController = KPUserProfileViewController()
        let navigationController = UINavigationController(rootViewController: profileController)
        controller.contentController = navigationController
        controller.presentModalView(self, UIModalPresentationStyle.fullScreen)
    }
}



extension KPSideViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        separator.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
        footerView.addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:|-10-[$self(1)]-13-|",
                                                   "H:|[$self]|"])
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            if regionContents[indexPath.row] != nil {
                let cell = tableView.dequeueReusableCell(withIdentifier:KPSideViewController.KPSideViewControllerRegionCellReuseIdentifier,
                                                         for: indexPath) as! KPRegionTableViewCell
                cell.selectionStyle = .none
                cell.expanded = false
                cell.expandIcon.isHidden = false
                cell.regionIcon.image = regionContents[indexPath.row]?.icon
                cell.regionLabel.text = regionContents[indexPath.row]?.name
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier:KPSideViewController.KPSideViewControllerCityCellReuseIdentifier,
                                                         for: indexPath) as! KPCityTableViewCell
                cell.selectionStyle = .none
                let regionIndex = getRegionIndex(expandIndex: indexPath.row)
                var regionContent = regionContents[regionIndex]
                cell.cityLabel.text = regionContent?.cities[indexPath.row-regionIndex-1]
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:KPSideViewController.KPSideViewControllerRegionCellReuseIdentifier,
                                                     for: indexPath) as! KPRegionTableViewCell
            cell.selectionStyle = .none
            cell.regionLabel.text = informationSectionContents[indexPath.row]?.title
            cell.regionIcon.image = informationSectionContents[indexPath.row]?.icon
            cell.expandIcon.isHidden = true
            cell.expanded = false
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            if regionContents[indexPath.row] != nil {
                return 48.0
            } else {
                return 40.0
            }
        } else {
            return 48.0
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
                
                tableView.beginUpdates()
                
                // 若是最後一行/或是任何一個可展開的區塊 --> 展開
                if indexPath.row + 1 >= regionContents.count || regionContents[indexPath.row+1] != nil {
                    cell.expanded = true
                    
                    for (index, _) in (regionCities?.enumerated())! {
                        regionContents.insert(nil, at: indexPath.row+index+1)
                        tableView.insertRows(at: [NSIndexPath(row: indexPath.row+index+1,
                                                                        section: 0) as IndexPath],
                                                  with: .top)
                    }
                } else {
                    cell.expanded = false
                    
                    var indexPaths = [IndexPath]()
                    for (index, _) in (regionCities?.enumerated())! {
                        indexPaths.append(NSIndexPath(row: indexPath.row+index+1, section: 0) as IndexPath)
                        regionContents.remove(at: indexPath.row+1)
                    }
                    tableView.deleteRows(at: indexPaths, with: .top)
                }
                tableView.endUpdates()

            /*可調整時間的做法
            if regionContents[indexPath.row] != nil {
                if indexPath.row + 1 >= regionContents.count {
                    for (index, _) in (regionCities?.enumerated())! {
                        regionContents.insert(nil, at: indexPath.row+index+1)
                        tableView.insertRows(at: [NSIndexPath(row: indexPath.row+index+1,
                                                                        section: 0) as IndexPath],
                                                  with: .top)
                        
                    }
                } else {
                    if regionContents[indexPath.row+1] != nil {
                        for (_, _) in (regionCities?.enumerated())! {
                            UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState, .overrideInheritedDuration], animations: {
                                
                                tableView.beginUpdates()
                                regionContents.insert(nil, at: indexPath.row+1)
                                tableView.insertRows(at: [NSIndexPath(row: indexPath.row+1,
                                                                                section: 0) as IndexPath],
                                                          with: .top)
                                
                                tableView.endUpdates()
                                
                            }, completion: nil)
                            
                        }
                    } else {
                        var indexPaths = [IndexPath]()
                        for (index, _) in (regionCities?.enumerated())! {
                            indexPaths.append(NSIndexPath(row: indexPath.row+index+1, section: 0) as IndexPath)
                 
                            regionContents.remove(at: indexPath.row+1)
                        }
                        tableView.deleteRows(at: indexPaths, with: .top)
                        
                    }
                }
                 */
                
            } else {
                let regionIndex = getRegionIndex(expandIndex: indexPath.row)
                let regionContent = regionContents[regionIndex]
                let cityName = regionContent?.cityKeys[indexPath.row-regionIndex-1]
                mainController.mainListViewController?.dataLoading = true
                mainController.displayDataModel = KPFilter.filterData(source: KPMainViewController.allDataModel,
                                                                      withCity: cityName!)
                mainController.searchHeaderView.titleLabel.text = regionContent?.cities[indexPath.row-regionIndex-1]
                dismiss(animated: true, completion: nil)
                resetTableview()
            }
        } else {
            informationSectionContents[indexPath.row]?.handler()
        }
    }
    
    func resetTableview() {
        regionContents = KPSideViewController.defaultRegionContent
        tableView.reloadData()
    }
}


