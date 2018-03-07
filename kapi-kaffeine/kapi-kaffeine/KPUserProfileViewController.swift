//
//  KPUserProfileViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPUserProfileViewController: KPViewController,
UITableViewDataSource,
UITableViewDelegate,
UIScrollViewDelegate,
KPTabViewDelegate {

    var dismissButton: KPBounceButton!
    var logOutButton: KPBounceButton!
    var editButton: KPBounceButton!
    
    var backgroundImageView: UIImageView!
    var facebookLoginButton: UIButton!
    var isLogin: Bool! {
        didSet {
            DispatchQueue.main.async {
                if self.isLogin {
                    self.userContainer.isHidden = false
                    self.tabView.isHidden = false
                    self.scrollView.isHidden = false
                    
                    UIView.animate(withDuration: 0.2,
                                   animations: {
                                    self.userContainer.alpha = 1.0
                                    self.tabView.alpha = 1.0
                                    self.scrollView.alpha = 1.0
                                    self.helloLabel.alpha = 0.0
                                    self.introLabel.alpha = 0.0
                                    self.backgroundImageView.alpha = 0.0
                    }, completion: { (success) in
                        self.helloLabel.isHidden = true
                        self.introLabel.isHidden = true
                        self.backgroundImageView.isHidden = true
                    })
                    
                } else {
                    self.helloLabel.isHidden = false
                    self.introLabel.isHidden = false
                    self.backgroundImageView.isHidden = false
                    UIView.animate(withDuration: 0.2,
                                   animations: {
                                    self.userContainer.alpha = 0.0
                                    self.tabView.alpha = 0.0
                                    self.scrollView.alpha = 0.0
                                    self.helloLabel.alpha = 1.0
                                    self.introLabel.alpha = 1.0
                                    self.backgroundImageView.alpha = 1.0
                    }, completion: { (success) in
                        self.userContainer.isHidden = true
                        self.tabView.isHidden = true
                        self.scrollView.isHidden = true
                    })
                }
            }
        }
    }
    
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
        containerView.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        return containerView
    }()
    
    
    lazy var helloLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 64.0)
        label.textColor = KPColorPalette.KPTextColor_v2.mainColor_title
        label.text = "Hello"
        return label
    }()
    
    
    lazy var introLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.numberOfLines = 0
        label.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        label.setText(text: "歡迎加入找咖啡；找咖啡有著各種不一樣、新奇的功能。找咖啡有著各種不一樣、新奇的功能。找咖啡有著各種不一樣、新奇的功能。",
                      lineSpacing: 4.0)
        return label
    }()
    
    lazy var userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = KPColorPalette.KPMainColor_v2.grayColor_level6?.cgColor
        imageView.layer.cornerRadius = 44.0
        imageView.layer.masksToBounds = true
        imageView.image = R.image.demo_profile()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24.0)
        label.textColor = KPColorPalette.KPTextColor_v2.mainColor_title
        label.text = "Hi, 皮卡丘"
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
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
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
        
        backgroundImageView = UIImageView(image: R.image.login_background()!)
        view.addSubview(backgroundImageView)
        backgroundImageView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                             "H:|[$self]|"])
        
        
        view.addSubview(helloLabel)
        helloLabel.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]-120-|"],
                                  metrics: [KPLayoutConstant.intro_horizontal_offset])
        helloLabel.addConstraintForCenterAligningToSuperview(in: .vertical,
                                                             constant: -140)
        
        view.addSubview(introLabel)
        introLabel.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]",
                                                    "H:|-($metric0)-[$self]-120-|"],
                                  metrics: [KPLayoutConstant.intro_horizontal_offset],
                                  views: [helloLabel])
        
        facebookLoginButton = UIButton(frame: CGRect.zero)
        facebookLoginButton.setTitle("Facebook 登入", for: .normal)
        facebookLoginButton.setTitleColor(KPColorPalette.KPTextColor_v2.whiteColor,
                                 for: .normal)
        facebookLoginButton.layer.cornerRadius = 21.0
        facebookLoginButton.layer.masksToBounds = true
        facebookLoginButton.setBackgroundImage(UIImage(color: UIColor(hexString: "#5066af")),
                                               for: .normal)
        facebookLoginButton.titleLabel?.font =
            UIFont.systemFont(ofSize: 18)
        view.addSubview(facebookLoginButton)
        facebookLoginButton.addConstraints(fromStringArray: ["V:[$view0]-24-[$self(42)]",
                                                             "H:|-($metric0)-[$self(180)]"],
                                           metrics: [KPLayoutConstant.intro_horizontal_offset],
                                           views: [introLabel])
        
        facebookLoginButton.addTarget(self,
                             action: #selector(handleLoginButtonOnTapped(sender:)),
                             for: UIControlEvents.touchUpInside)
        
        
        
        view.addSubview(userContainer)
        userContainer.addConstraints(fromStringArray: ["V:|[$self(200)]",
                                                       "H:|[$self]|"])
        
        userContainer.addSubview(userPhoto)
        userPhoto.addConstraints(fromStringArray: ["H:[$self(88)]-40-|",
                                                   "V:|-48-[$self(88)]"])
        
        userContainer.addSubview(userNameLabel)
        userNameLabel.addConstraints(fromStringArray: ["H:|-20-[$self]",
                                                       "V:|-50-[$self]"])
        
        userContainer.addSubview(userBioLabel)
        userBioLabel.addConstraints(fromStringArray: ["H:|-20-[$self(200)]",
                                                      "V:[$view1]-8-[$self]"],
                                          views: [userPhoto,
                                                  userNameLabel])
        userBioLabel.setText(text:"被你看到這個隱藏的內容？！肯定有Bug，快回報給我們吧！肯定有Bug！",
                             lineSpacing: 3.0)
        
        
        
        logOutButton = KPBounceButton(frame: CGRect.zero)
        logOutButton.setTitle("登出", for: .normal)
        logOutButton.setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_subtitle,
                                   for: .normal)
        logOutButton.layer.borderColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle?.cgColor
        logOutButton.layer.borderWidth = 1.0
        logOutButton.layer.cornerRadius = 16.0
        logOutButton.layer.masksToBounds = true
        logOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        userContainer.addSubview(logOutButton)
        logOutButton.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(32)]", "H:|-19-[$self(64)]"],
                                    views: [userBioLabel
            ])
        logOutButton.addTarget(self,
                             action: #selector(handleLogOutButtonOnTapped(sender:)),
                             for: UIControlEvents.touchUpInside)
        
        editButton = KPBounceButton(frame: CGRect.zero)
        editButton.setTitle("編輯", for: .normal)
        editButton.setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_subtitle,
                                   for: .normal)
        editButton.layer.borderColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle?.cgColor
        editButton.layer.borderWidth = 1.0
        editButton.layer.cornerRadius = 16.0
        editButton.layer.masksToBounds = true
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        userContainer.addSubview(editButton)
        editButton.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(32)]", "H:[$view1]-16-[$self(64)]"],
                                    views: [userBioLabel, logOutButton
            ])
        editButton.addTarget(self,
                             action: #selector(handleEditButtonOnTapped(sender:)),
                             for: UIControlEvents.touchUpInside)
        
        
        tabView = KPTabView(titles: tabTitles.map {$0.title})
        tabView.delegate = self
        view.addSubview(tabView)
        tabView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                 "V:[$view0]-8-[$self(44)]"], views: [userContainer])
        
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
            userNameLabel.text = "Hi, \(user.displayName ?? "")"
            userBioLabel.text = user.intro ?? "被你看到這個隱藏的內容？！肯定有Bug，快回報給我們吧！"
            
            for (index, tabTitle) in tabTitles.enumerated() {
                
                if let displayModel = KPUserManager.sharedManager.currentUser?.value(forKey: tabTitle.key) as? [KPDataModel] {
                    tabView.tabs[index].setTitle("\(tabTitle.title) \(displayModel.count)", for: .normal)
                }
            }
        }
        
        view.bringSubview(toFront: tabView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidChanged(notification:)), name: .KPCurrentUserDidChange, object: nil)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = KPUserManager.sharedManager.currentUser {
            isLogin = true
            if let photoURL = URL(string: user.photoURL ?? "") {
                userPhoto.af_setImage(withURL: photoURL)
            }
            userNameLabel.text = "Hi, \(user.displayName ?? "")"
            userBioLabel.text = user.intro ?? "被你看到這個隱藏的內容？！肯定有Bug，快回報給我們吧！"
        } else {
            isLogin = false
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
    
    @objc func handleLogOutButtonOnTapped(sender: UIButton) {
        KPUserManager.sharedManager.logOut()
    }
    
    @objc func handleEditButtonOnTapped(sender: UIButton) {
        
    }
    
    @objc func handleLoginButtonOnTapped(sender: UIButton) {
        KPUserManager.sharedManager.logIn(self)
    }
    
    @objc func handleEditButtonOnTapped() {
        self.navigationController?.pushViewController(KPUserProfileEditorController(), animated: true)
    }
    
    @objc func userDidChanged(notification: Notification) {
        isLogin = (KPUserManager.sharedManager.currentUser != nil)
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
