//
//  KPUserProfileViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPUserProfileViewController: KPViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, KPTabViewDelegate {

    var dismissButton: KPBounceButton!
    var editButton: KPBounceButton!
    
    let tabTitles: [(title: String, key: String)] = [("已收藏", "favorites"),
                                                     ("我去過", "visits"),
                                                     ("已評分", "rates"),
                                                     ("已評論", "reviews")]
    
    let statusContents:[(icon: UIImage, content: String)] = [(R.image.status_collect()!, "快來收藏你喜愛的店家吧!"),
                                                             (R.image.status_location()!, "你有去過哪些店家呢?"),
                                                             (R.image.status_star()!, "快給你喜愛的店家一些正面的評分吧!"),
                                                             (R.image.status_comment()!, "快給你喜愛的店家一些正面的評論吧!")]
    
    lazy var userContainer: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor_light
        return containerView
    }()
    
    lazy var userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor
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
        label.font = UIFont.boldSystemFont  (ofSize: 16.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        label.text = "我是一隻蟲"
        return label
    }()
    
    lazy var userCityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        label.text = "Taipei"
        return label
    }()
    
    lazy var userBioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        label.text = "被你看到這個隱藏的內容？！肯定有Bug，快回報給我們吧！"
        label.numberOfLines = 0
        return label
    }()
    
    var tableViews: [UITableView] = []
    var statusViews: [KPStatusView] = []
    var displayDataModels: [[KPDataModel]] = []
    var scrollView: UIScrollView!
    var scrollContainer: UIView!
    var tabView: KPTabView!
    
    var isAnimating: Bool = false {
        didSet {
            self.scrollView.isUserInteractionEnabled = !isAnimating
        }
    }
    
    var dataLoading: Bool = false
    var dataloaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KPAnalyticManager.sendPageViewEvent(KPAnalyticsEventValue.page.profile_page)
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = "個人資料"
        navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                                    for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

        dismissButton = KPBounceButton(frame: CGRect.zero,
                                       image: R.image.icon_close()!)
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(6, 0, 8, 14)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.addTarget(self,
                                action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        
        let barItem = UIBarButtonItem(customView: dismissButton)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -7
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        

        editButton = KPBounceButton(frame: CGRect.zero,
                                    image: R.image.icon_edit()!)
        editButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        editButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        editButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        editButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        editButton.addTarget(self,
                             action: #selector(KPUserProfileViewController.handleEditButtonOnTapped),
                             for: .touchUpInside)
        
        
        let rightBarItem = UIBarButtonItem(customView: editButton)
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        navigationItem.rightBarButtonItems = [negativeSpacer, rightBarItem]
        
        view.addSubview(userContainer)
        userContainer.addConstraints(fromStringArray: ["V:|[$self]",
                                                       "H:|[$self]|"])
        
        userContainer.addSubview(userPhoto)
        userPhoto.addConstraints(fromStringArray: ["H:|-16-[$self(64)]",
                                                   "V:|-16-[$self(64)]-16-|"])
        
        userContainer.addSubview(userNameLabel)
        userNameLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
                                                       "V:|-16-[$self]"],
                                          views: [userPhoto])
        
        userContainer.addSubview(userCityLabel)
        userCityLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
                                                       "V:[$view1]-2-[$self]"],
                                          views: [userPhoto,
                                                  userNameLabel])
        
        userContainer.addSubview(userBioLabel)
        userBioLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self(150)]",
                                                      "V:[$view1]-4-[$self]"],
                                          views: [userPhoto,
                                                  userCityLabel])
        
        
        tabView = KPTabView(titles: tabTitles.map {$0.title})
        tabView.delegate = self
        view.addSubview(tabView)
        tabView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                 "V:[$view0][$self(44)]"], views: [userContainer])
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                    "V:[$view0][$self]|"], views: [tabView])

        scrollContainer = UIView()
        scrollView.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self]|"])
        scrollContainer.addConstraintForHavingSameHeight(with: scrollView)
        
        for (index, _) in tabTitles.enumerated() {
            let tableView = UITableView()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tag = index
            tableView.separatorColor = UIColor.clear
            tableView.register(KPMainListTableViewCell.self,
                                forCellReuseIdentifier: "cell")
            tableView.register(KPDefaultLoadingTableCell.self,
                                forCellReuseIdentifier: "cell_loading")
            tableView.estimatedRowHeight = 80
            
            scrollContainer.addSubview(tableView)
            tableView.addConstraint(from: "V:|[$self]|")
            tableView.addConstraintForHavingSameWidth(with: view)
            
            let statusView = KPStatusView.init(statusContents[index].icon,
                                               statusContents[index].content)
            statusView.isHidden = true
            scrollContainer.addSubview(statusView)
            statusView.addConstraint(from: "V:|-72-[$self]")
            statusView.addConstraint(forWidth: 220)
            statusView.addConstraintForCenterAligning(to: tableView,
                                                      in: .horizontal)
            
            if tableViews.count > 0 {
                tableView.addConstraint(from: "H:[$view0][$self]", views: [tableViews[index-1]])
            } else {
                tableView.addConstraint(from: "H:|[$self]")
            }
            
            tableViews.append(tableView)
            statusViews.append(statusView)
            
            displayDataModels.append([])
            
        }
        tableViews.last!.addConstraint(from: "H:[$self]|")
        
        
        if let user = KPUserManager.sharedManager.currentUser {
            if let photoURL = URL(string: user.photoURL ?? "") {
                userPhoto.af_setImage(withURL: photoURL)
            }
            userNameLabel.text = user.displayName ?? ""
            userCityLabel.text = user.defaultLocation ?? ""
            userBioLabel.text = user.intro ?? ""
            
            for (index, tabTitle) in tabTitles.enumerated() {
                
                if let displayModel = KPUserManager.sharedManager.currentUser?.value(forKey: tabTitle.key) as? [KPDataModel] {
                    tabView.tabs[index].setTitle("\(tabTitle.title) \(displayModel.count)", for: .normal)
                }
            }
        }
        
        view.bringSubview(toFront: tabView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if let user = KPUserManager.sharedManager.currentUser {
            if let photoURL = URL(string: user.photoURL ?? "") {
                userPhoto.af_setImage(withURL: photoURL)
            }
            userNameLabel.text = user.displayName ?? ""
            userCityLabel.text = user.defaultLocation ?? ""
            userBioLabel.text = user.intro ?? ""
        }
        
        if !dataloaded {
        
            dataLoading = true
            for tableView in self.tableViews {
                tableView.reloadData()
            }
            
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.5) {

                for (index, tabTitle) in self.tabTitles.enumerated() {
                    if let displayModel = KPUserManager.sharedManager.currentUser?.value(forKey: tabTitle.key) as? [KPDataModel] {
                        self.displayDataModels[index] = displayModel
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.1,
                                           animations: { 
                                            self.tableViews[index].alpha = (displayModel.count == 0) ? 0.0 : 1.0
                                            self.statusViews[index].alpha = (displayModel.count != 0) ? 0.0 : 1.0
                            }, completion: { (_) in
                                self.tableViews[index].isHidden = displayModel.count == 0
                                self.statusViews[index].isHidden = (displayModel.count != 0)
                            })
                        }
                    } else {
                        self.displayDataModels[index] = []
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.1,
                                           animations: { 
                                            self.tableViews[index].alpha = 0.0
                                            self.statusViews[index].alpha = 1.0
                            }, completion: { (_) in
                                self.tableViews[index].isHidden = true
                                self.statusViews[index].isHidden = false
                            })
                        }
                    }
                }
                self.dataLoading = false
                DispatchQueue.main.async {
                    for tableView in self.tableViews {
                        tableView.reloadData()
                    }
                }
                
            }
            dataloaded = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleDismissButtonOnTapped() {
        self.appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    func handleEditButtonOnTapped() {
        self.navigationController?.pushViewController(KPUserProfileEditorController(), animated: true)
    }

    
    func tabView(_: KPTabView, didSelectIndex index: Int) {
        isAnimating = true
        UIView.animate(withDuration: 0.25, animations: { 
            self.scrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.width*CGFloat(index), y: 0)
        }) { (complete) in
            self.isAnimating = false
        }
    }

    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLoading ? 6 : self.displayDataModels[tableView.tag].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if !dataLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier:"cell",
                                                     for: indexPath) as! KPMainListTableViewCell
            
            cell.selectionStyle = .none
            cell.dataModel = self.displayDataModels[tableView.tag][indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"cell_loading",
                                                     for: indexPath) as! KPDefaultLoadingTableCell
            return cell
        }
    }
    
    // MARK: UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        KPAnalyticManager.sendCellClickEvent(self.displayDataModels[tableView.tag][indexPath.row].name,
                                             self.displayDataModels[tableView.tag][indexPath.row].averageRate?.stringValue,
                                             KPAnalyticsEventValue.source.source_profile)
        
        let controller = KPInformationViewController()
        controller.informationDataModel = self.displayDataModels[tableView.tag][indexPath.row]
        controller.showBackButton = true
        self.navigationController?.pushViewController(controller, animated: true)
        
        for tableView in self.tableViews {
            if let indexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPath, animated: false)
            }
        }
    }
    
    // MARK: UIScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView is UITableView {
            return
        }
        
        if isAnimating {
            return
        }
        let screenWidth = UIScreen.main.bounds.width
        tabView.currentIndex = Int((scrollView.contentOffset.x+screenWidth/2)/screenWidth)
    }

}
