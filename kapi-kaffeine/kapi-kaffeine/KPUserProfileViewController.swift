//
//  KPUserProfileViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPUserProfileViewController: KPViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, KPTabViewDelegate {

    var dismissButton: UIButton!
    var editButton: UIButton!
    
    let tabTitles: [(title: String, key: String)] = [("已收藏", "favorites"),
                                                     ("我去過", "visits"),
                                                     ("已評分", "rates"),
                                                     ("已評價", "reviews")]
    
    lazy var userContainer: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = KPColorPalette.KPMainColor.mainColor_light
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
        label.font = UIFont.boldSystemFont  (ofSize: 16.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        label.text = "Samuel"
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
        label.text = "喜歡鬧，就是愛鬧，鬧到沒有極限的不停地鬧"
        label.numberOfLines = 0
        return label
    }()
    
    var tableViews: [UITableView] = []
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
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = "個人資料"

        self.dismissButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        self.dismissButton.setImage(R.image.icon_close(),
                                    for: .normal)
        self.dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        self.dismissButton.addTarget(self,
                                     action: #selector(KPUserProfileViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside)
        
        self.editButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        self.editButton.setImage(R.image.icon_edit(),
                                 for: .normal)
        self.editButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        self.editButton.addTarget(self,
                                  action: #selector(KPUserProfileViewController.handleEditButtonOnTapped),
                                  for: .touchUpInside)

        
        let barItem = UIBarButtonItem(customView: self.dismissButton)
        let rightBarItem = UIBarButtonItem(customView: self.editButton)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        self.navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        self.navigationItem.rightBarButtonItems = [negativeSpacer, rightBarItem]
        
        self.dismissButton.addTarget(self,
                                     action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside)
        
        self.view.addSubview(self.userContainer)
        self.userContainer.addConstraints(fromStringArray: ["V:|[$self]", "H:|[$self]|"])
        
        self.userContainer.addSubview(self.userPhoto)
        self.userPhoto.addConstraints(fromStringArray: ["H:|-16-[$self(64)]",
                                                        "V:|-16-[$self(64)]-16-|"])
        
        self.userContainer.addSubview(self.userNameLabel)
        self.userNameLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
                                                            "V:|-16-[$self]"],
                                          views: [self.userPhoto])
        
        self.userContainer.addSubview(self.userCityLabel)
        self.userCityLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
                                                            "V:[$view1]-2-[$self]"],
                                          views: [self.userPhoto,
                                                  self.userNameLabel])
        
        self.userContainer.addSubview(self.userBioLabel)
        self.userBioLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self(150)]",
                                                            "V:[$view1]-4-[$self]"],
                                          views: [self.userPhoto,
                                                  self.userCityLabel])
        
        
        tabView = KPTabView(titles: self.tabTitles.map {$0.title})
        tabView.delegate = self
        view.addSubview(tabView)
        tabView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self]"], views: [userContainer])
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self]|"], views: [tabView])

        scrollContainer = UIView()
        scrollView.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        scrollContainer.addConstraintForHavingSameHeight(with: scrollView)
        
        for (index, _) in tabTitles.enumerated() {
            let tableView = UITableView()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tag = index
            tableView.register(KPMainListTableViewCell.self,
                                forCellReuseIdentifier: "cell")
            tableView.register(KPDefaultLoadingTableCell.self,
                                forCellReuseIdentifier: "cell_loading")
            tableView.estimatedRowHeight = 80
            
            scrollContainer.addSubview(tableView)
            tableView.addConstraint(from: "V:|[$self]|")
            tableView.addConstraintForHavingSameWidth(with: view)
            
            if tableViews.count > 0 {
                tableView.addConstraint(from: "H:[$view0][$self]", views: [tableViews[index-1]])
            } else {
                tableView.addConstraint(from: "H:|[$self]")
            }
            
            tableViews.append(tableView)
            
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
            
            for (index, tabTitle) in self.tabTitles.enumerated() {
                
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
                    } else {
                        self.displayDataModels[index] = []
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
        let controller = KPInformationViewController()
        controller.informationDataModel = self.displayDataModels[tableView.tag][indexPath.row]
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
