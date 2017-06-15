//
//  KPUserProfileViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPUserProfileViewController: KPViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, KPTabViewDelegate {

    var dismissButton:UIButton!
    
    let titles = ["已收藏", "我去過", "已評分", "已評價"]
    
    lazy var userContainer: UIView = {
        let containerView = UIView();
        containerView.backgroundColor = KPColorPalette.KPMainColor.mainColor;
        return containerView;
    }()
    
    lazy var userPhoto: UIImageView = {
        let imageView = UIImageView();
        imageView.backgroundColor = KPColorPalette.KPMainColor.mainColor
        imageView.layer.borderWidth = 2.0;
        imageView.layer.borderColor = UIColor.white.cgColor;
        imageView.layer.cornerRadius = 5.0;
        imageView.layer.masksToBounds = true;
        return imageView;
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel();
        label.font = UIFont.systemFont(ofSize: 16.0);
        label.textColor = KPColorPalette.KPTextColor.whiteColor;
        label.text = "Samuel";
        return label;
    }()
    
    lazy var userCityLabel: UILabel = {
        let label = UILabel();
        label.font = UIFont.systemFont(ofSize: 12.0);
        label.textColor = KPColorPalette.KPTextColor.whiteColor;
        label.text = "Taipei";
        return label;
    }()
    
    lazy var userBioLabel: UILabel = {
        let label = UILabel();
        label.font = UIFont.systemFont(ofSize: 10.0);
        label.textColor = KPColorPalette.KPTextColor.whiteColor;
        label.text = "喜歡鬧，就是愛鬧，鬧到沒有極限的不停地鬧";
        label.numberOfLines = 0;
        return label;
    }()
    
    var tableViews: [UITableView] = []
    var scrollView: UIScrollView!
    var scrollContainer: UIView!
    var tabView: KPTabView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white;
        self.navigationController?.navigationBar.topItem?.title = "個人資料";
        
        self.dismissButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24));
        self.dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        self.dismissButton.setImage(UIImage.init(named: "icon_close")?.withRenderingMode(.alwaysTemplate),
                                    for: .normal);
        self.dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        self.dismissButton.addTarget(self,
                                     action: #selector(KPSettingViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside);
        
        let barItem = UIBarButtonItem.init(customView: self.dismissButton);
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -8;
        self.navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        
        self.dismissButton.addTarget(self,
                                     action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside);
        
//        let navigationBarHeight = self.navigationController?.navigationBar.frame.height;
        
        self.view.addSubview(self.userContainer);
        self.userContainer.addConstraints(fromStringArray: ["V:|[$self]", "H:|[$self]|"]);
        
        self.userContainer.addSubview(self.userPhoto);
        self.userPhoto.addConstraints(fromStringArray: ["H:|-16-[$self(64)]",
                                                        "V:|-16-[$self(64)]-16-|"])
        
        self.userContainer.addSubview(self.userNameLabel);
        self.userNameLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
                                                            "V:|-16-[$self]"],
                                          views: [self.userPhoto]);
        
        self.userContainer.addSubview(self.userCityLabel);
        self.userCityLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]",
                                                            "V:[$view1]-2-[$self]"],
                                          views: [self.userPhoto,
                                                  self.userNameLabel]);
        
        self.userContainer.addSubview(self.userBioLabel);
        self.userBioLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self(150)]",
                                                            "V:[$view1]-4-[$self]"],
                                          views: [self.userPhoto,
                                                  self.userCityLabel]);
        
        tabView = KPTabView(titles: self.titles)
        tabView.delegate = self
        view.addSubview(tabView)
        tabView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self]"], views: [userContainer])
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        view.addSubview(scrollView)
        scrollView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0][$self]|"], views: [tabView])

        scrollContainer = UIView()
        scrollView.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        scrollContainer.addConstraintForHavingSameHeight(with: scrollView)
        
        for (index, _) in self.titles.enumerated() {
            let tableView = UITableView()
            tableView.dataSource = self
            
            tableView.register(KPMainListTableViewCell.self,
                                forCellReuseIdentifier: KPMainListViewController.KPMainListViewCellReuseIdentifier)
            tableView.register(KPDefaultLoadingTableCell.self,
                                forCellReuseIdentifier: KPMainListViewController.KPMainListViewLoadingCellReuseIdentifier)
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
        }
        tableViews.last!.addConstraint(from: "H:[$self]|")
        
        
        if let user = KPUserManager.sharedManager.currentUser {
            if let photoURL = URL(string: user.photoURL ?? "") {
                userPhoto.af_setImage(withURL: photoURL)
            }
            userNameLabel.text = user.displayName
            userCityLabel.text = user.defaultLocation
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleDismissButtonOnTapped() {
        self.appModalController()?.dismissControllerWithDefaultDuration();
    }

    
    func tabView(_: KPTabView, didSelectIndex index: Int) {
        scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width*CGFloat(index), y: 0), animated: true)
    }

    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: KPMainListViewController.KPMainListViewLoadingCellReuseIdentifier, for: indexPath)
    }
    
    // MARK: UIScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenWidth = UIScreen.main.bounds.width
        tabView.currentIndex = Int((scrollView.contentOffset.x+screenWidth/2)/screenWidth)
    }

}
