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
                    
                    if let user = KPUserManager.sharedManager.currentUser {
                        if let photoURL = URL(string: user.photoURL ?? "") {
                            self.userPhoto.af_setImage(withURL: photoURL)
                        }
                        self.userNameLabel.text = "Hi, \(user.displayName ?? "")"
                        self.userBioLabel.text = user.intro ?? "被你看到這個隱藏的內容？！肯定有Bug，快回報給我們吧！"
                        
                        for (index, tabTitle) in self.tabTitles.enumerated() {
                            
                            if let displayModel = KPUserManager.sharedManager.currentUser?.value(forKey: tabTitle.key) as? [KPDataModel] {
                                self.tabView.tabs[index].setTitle("\(tabTitle.title) \(displayModel.count)", for: .normal)
                            } else if let articleItem = KPUserManager.sharedManager.currentUser?.value(forKey: tabTitle.key) as? [KPArticleItem] {
                                self.tabView.tabs[index].setTitle("\(tabTitle.title) \(articleItem.count)", for: .normal)
                            }
                        }
                    }
                    
                    UIView.animate(withDuration: 0.2,
                                   animations: {
                                    self.userContainer.alpha = 1.0
                                    self.tabView.alpha = 1.0
                                    self.scrollView.alpha = 1.0
                                    self.helloLabel.alpha = 0.0
                                    self.introLabel.alpha = 0.0
                                    self.facebookLoginButton.alpha = 0.0
                                    self.backgroundImageView.alpha = 0.0
                    }, completion: { (success) in
                        self.helloLabel.isHidden = true
                        self.introLabel.isHidden = true
                        self.backgroundImageView.isHidden = true
                        self.facebookLoginButton.isHidden = true
                        self.loadUserContent()
                    })
                    
                } else {
                    self.helloLabel.isHidden = false
                    self.introLabel.isHidden = false
                    self.backgroundImageView.isHidden = false
                    self.facebookLoginButton.isHidden = false
                    UIView.animate(withDuration: 0.2,
                                   animations: {
                                    self.userContainer.alpha = 0.0
                                    self.tabView.alpha = 0.0
                                    self.scrollView.alpha = 0.0
                                    self.helloLabel.alpha = 1.0
                                    self.introLabel.alpha = 1.0
                                    self.backgroundImageView.alpha = 1.0
                                    self.facebookLoginButton.alpha = 1.0
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
                                                     ("已評論", "reviews"),
                                                     ("收藏文章", "articles")]
    let articleTabIndex = 3;
    
    let statusContents:[(icon: UIImage, content: String)] = [(R.image.status_collect()!, "快來收藏你喜愛的店家吧!"),
                                                             (R.image.status_location()!, "你有去過哪些店家呢?"),
                                                             (R.image.status_star()!, "快給你喜愛的店家一些正面的評分吧!"),
                                                             (R.image.status_comment()!, "快來收藏你喜歡的文章吧!")]
    
    lazy var userContainer: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        return containerView
    }()
    
    
    lazy var helloLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 64.0)
        label.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        label.text = "Hello"
        return label
    }()
    
    
    lazy var introLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        label.numberOfLines = 0
        label.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        label.setText(text: "歡迎加入找咖啡；找咖啡有著各種不一樣、新奇的功能。找咖啡有著各種不一樣、新奇的功能。找咖啡有著各種不一樣、新奇的功能喔。",
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
    var articleItems: [KPArticleItem] = []
    var scrollView: UIScrollView!
    var scrollContainer: UIView!
    var tabView: KPTabView!
    
    var isAnimating: Bool = false {
        didSet {
            self.scrollView.isUserInteractionEnabled = !isAnimating
        }
    }
    
    var dataLoading: Bool = true
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
                                                             constant: -160)
        
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
                                           metrics: [KPLayoutConstant.intro_horizontal_offset-2],
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
            tableView.register(KPListArticleCell.self,
                               forCellReuseIdentifier: "cell_article")
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDidChanged(notification:)), name: .KPCurrentUserDidChange, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserContent()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = KPUserManager.sharedManager.currentUser {
            isLogin = true
        } else {
            isLogin = false
        }
        view.bringSubview(toFront: tabView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUserContent() {
        
        self.dataLoading = true
        self.dataloaded = false
        
        if (KPUserManager.sharedManager.currentUser != nil) {
            if !self.dataloaded {
                self.dataLoading = true
                for tableView in self.tableViews {
                    tableView.reloadData()
                }
            }
            KPUserManager.sharedManager.updateUserInformation({ (_) in
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
                    } else if let articleModels = KPUserManager.sharedManager.currentUser?.value(forKey: tabTitle.key) as? [KPArticleItem] {
                        self.articleItems = articleModels;
                        DispatchQueue.main.async {
                            UIView.animate(withDuration: 0.1,
                                           animations: {
                                            self.tableViews[index].alpha = (articleModels.count == 0) ? 0.0 : 1.0
                                            self.statusViews[index].alpha = (articleModels.count != 0) ? 0.0 : 1.0
                            }, completion: { (_) in
                                self.tableViews[index].isHidden = articleModels.count == 0
                                self.statusViews[index].isHidden = (articleModels.count != 0)
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
                self.dataloaded = true
                DispatchQueue.main.async {
                    for tableView in self.tableViews {
                        tableView.reloadData()
                    }
                }
            })
        }
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
        if tableView.tag == articleTabIndex {
            return self.articleItems.count;
        } else {
            return dataLoading ? 6 : self.displayDataModels[tableView.tag].count
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if dataloaded {
            if tableView.tag == articleTabIndex {
                let cell = tableView.dequeueReusableCell(withIdentifier:"cell_article",
                                                         for: indexPath) as! KPListArticleCell
                cell.selectionStyle = .none
                cell.articleTitleLabel.setText(text: self.articleItems[indexPath.row].title!,
                                               lineSpacing: 4)
                cell.articleSubtitleLabel.text = self.articleItems[indexPath.row].articleDescription
                
                if let url = self.articleItems[indexPath.row].imageURL_s ?? self.articleItems[indexPath.row].imageURL_l {
                    cell.articleImageView.af_setImage(withURL: url,
                                                      placeholderImage: drawImage(image: R.image.icon_loading()!,
                                                                                  rectSize: CGSize(width: 76,
                                                                                                   height: 76),
                                                                                  roundedRadius: 3),
                                                      filter: nil,
                                                      progress: nil,
                                                      progressQueue: DispatchQueue.global(),
                                                      imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                                      runImageTransitionIfCached: true,
                                                      completion: { response in
                                                        if let responseImage = response.result.value {
                                                            cell.articleImageView.image =  drawImage(image: responseImage,
                                                                                                  rectSize: CGSize(width: 76,
                                                                                                                   height: 76),
                                                                                                  roundedRadius: 3)
                                                        } else {
                                                            cell.articleImageView.image =  drawImage(image: R.image.icon_noImage()!,
                                                                                                  rectSize: CGSize(width: 76,
                                                                                                                   height: 76),
                                                                                                  roundedRadius: 3)
                                                        }
                    })
                } else {
                    cell.articleImageView.image =  drawImage(image: R.image.icon_noImage()!,
                                                             rectSize: CGSize(width: 76,
                                                                              height: 76),
                                                             roundedRadius: 3)
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier:"cell",
                                                         for: indexPath) as! KPMainListTableViewCell
                
                cell.selectionStyle = .none
                cell.tag = indexPath.row
                cell.dataModel = self.displayDataModels[tableView.tag][indexPath.row]
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:"cell_loading",
                                                     for: indexPath) as! KPDefaultLoadingTableCell
            return cell
        }
    }
    
    // MARK: UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == articleTabIndex {
            let articleController = KPArticleViewController(self.articleItems[indexPath.row].articleID)
            articleController.currentArticleItem = self.articleItems[indexPath.row];
            present(articleController,
                    animated: true,
                    completion: nil)
        } else {
            KPAnalyticManager.sendCellClickEvent(self.displayDataModels[tableView.tag][indexPath.row].name,
                                                 self.displayDataModels[tableView.tag][indexPath.row].averageRate?.stringValue,
                                                 KPAnalyticsEventValue.source.source_profile)
            
            let controller = KPInformationViewController()
            controller.informationDataModel = self.displayDataModels[tableView.tag][indexPath.row]
            self.present(controller,
                         animated: true,
                         completion: nil)
        }
        
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
