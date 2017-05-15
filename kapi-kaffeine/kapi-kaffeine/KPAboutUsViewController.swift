//
//  KPAboutUsViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/25.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPAboutUsViewController: UIViewController {

    
    struct relateiveLink {
        var icon: UIImage
        var link: URL
    }
    
    struct memberData {
        var title: String
        var name: String
        var email: String
        var relative: [relateiveLink]?
    }
    
    var dismissButton:KPBounceButton!
    
    var scrollView: UIScrollView!
    var containerView: UIView!
    
    var iconImageView: UIImageView!
    var iconTitleView: UIImageView!
    var iconInformationView: UIImageView!
    
    var moreFeatureButton: UIButton!
    
    var productDescriptionTitleLabel: UILabel!
    var productDescriptionContentLabel: UILabel!
    
    var productMemberTitleLabel: UILabel!
    var productMembers: [memberData] = {
        return [memberData(title: "Designer",
                           name: "Simon",
                           email: "a97210230@gmail.com",
                           relative: [relateiveLink(icon: UIImage.init(named: "icon_map")!,
                                                    link: URL.init(string: "www.yahoo.com.tw")!)]),
                memberData(title: "Android Developer",
                           name: "Yalan",
                           email: "a97210230@gmail.com",
                           relative: [relateiveLink(icon: UIImage.init(named: "icon_map")!,
                                                    link: URL.init(string: "www.yahoo.com.tw")!)]),
                memberData(title: "iOS Developer",
                           name: "Samuel",
                           email: "a97210230@gmail.com",
                           relative: [relateiveLink(icon: UIImage.init(named: "icon_map")!,
                                                    link: URL.init(string: "www.yahoo.com.tw")!)]),
                memberData(title: "iOS Developer",
                           name: "Shou",
                           email: "a97210230@gmail.com",
                           relative: [relateiveLink(icon: UIImage.init(named: "icon_map")!,
                                                    link: URL.init(string: "www.yahoo.com.tw")!)])]
    }()
    var productMemberContainerViews: [UIView] = [UIView]()
    
    var dataSourceTitleLabel: UILabel!
    var dataSourceContentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white;
        self.navigationController?.navigationBar.topItem?.title = "設定";
        
        self.dismissButton = KPBounceButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24));
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

        self.scrollView = UIScrollView();
        self.scrollView.showsVerticalScrollIndicator = false;
        self.view.addSubview(self.scrollView);
        self.scrollView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                         "H:|[$self]|"]);
        
        self.containerView = UIView();
        self.scrollView.addSubview(self.containerView);
        self.containerView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|", "V:|[$self]|"]);
        self.containerView.addConstraintForHavingSameWidth(with: self.view,
                                                           constant: -32);
        
        self.iconImageView = UIImageView();
        self.iconImageView.backgroundColor = KPColorPalette.KPMainColor.mainColor;
        self.containerView.addSubview(self.iconImageView);
        self.iconImageView.addConstraints(fromStringArray: ["V:|-($metric0)-[$self(80)]",
                                                            "H:|[$self(80)]"],
                                          metrics:[32]);
        
        self.iconTitleView = UIImageView();
        self.iconTitleView.backgroundColor = KPColorPalette.KPMainColor.grayColor_level2;
        self.containerView.addSubview(self.iconTitleView);
        self.iconTitleView.addConstraints(fromStringArray: ["V:|-($metric0)-[$self(24)]",
                                                            "H:[$view0]-16-[$self(64)]"],
                                          metrics:[32],
                                          views:[self.iconImageView]);
        
        self.iconInformationView = UIImageView();
        self.iconInformationView.backgroundColor = KPColorPalette.KPMainColor.grayColor_level2;
        self.containerView.addSubview(self.iconInformationView);
        self.iconInformationView.addConstraints(fromStringArray: ["V:[$view0]-4-[$self(18)]",
                                                                  "H:[$view1]-16-[$self(100)]"],
                                                views:[self.iconTitleView, self.iconImageView]);
        
        self.moreFeatureButton = UIButton();
        self.moreFeatureButton.backgroundColor = KPColorPalette.KPMainColor.grayColor_level2;
        self.containerView.addSubview(self.moreFeatureButton);
        self.moreFeatureButton.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(24)]",
                                                                "H:[$view1]-16-[$self(92)]"],
                                              views: [self.iconInformationView, self.iconImageView]);
        
        self.productDescriptionTitleLabel = UILabel();
        self.productDescriptionTitleLabel.font = UIFont.systemFont(ofSize: 15.0);
        self.productDescriptionTitleLabel.textColor = KPColorPalette.KPTextColor.mainColor;
        self.productDescriptionTitleLabel.text = "產品介紹";
        self.containerView.addSubview(self.productDescriptionTitleLabel);
        self.productDescriptionTitleLabel.addConstraints(fromStringArray: ["H:|[$self]", "V:[$view0]-24-[$self]"],
                                            views: [self.iconImageView]);
        
        self.productDescriptionContentLabel = UILabel();
        self.productDescriptionContentLabel.font = UIFont.systemFont(ofSize: 13.0);
        self.productDescriptionContentLabel.textColor = KPColorPalette.KPTextColor.grayColor_level2;
        self.productDescriptionContentLabel.text = "有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，" +
        "有事情嗎。沒事。有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎。沒事。";
        self.productDescriptionContentLabel.textAlignment = .left;
        self.productDescriptionContentLabel.numberOfLines = 0;
        self.containerView.addSubview(self.productDescriptionContentLabel);
        self.productDescriptionContentLabel.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                             "V:[$view0]-8-[$self]"],
                                                              views: [self.productDescriptionTitleLabel]);
        
        self.productMemberTitleLabel = UILabel();
        self.productMemberTitleLabel.font = UIFont.systemFont(ofSize: 15.0);
        self.productMemberTitleLabel.textColor = KPColorPalette.KPTextColor.mainColor;
        self.productMemberTitleLabel.text = "團隊成員";
        self.containerView.addSubview(self.productMemberTitleLabel);
        self.productMemberTitleLabel.addConstraints(fromStringArray: ["H:|[$self]", "V:[$view0]-24-[$self]"],
                                                         metrics: [UIScreen.main.bounds.size.width/2],
                                                         views: [self.productDescriptionContentLabel]);

        for (index, member) in self.productMembers.enumerated() {
            
            let memberContainer = UIView();
            let memberTitleLabel = UILabel();
            let memberNameLabel = UILabel();
            let memberEmailLabel = UILabel();
            
            memberTitleLabel.font = UIFont.systemFont(ofSize: 12.0);
            memberTitleLabel.textColor = KPColorPalette.KPTextColor.mainColor_light;
            memberTitleLabel.text = member.title;
            
            memberNameLabel.font = UIFont.systemFont(ofSize: 14.0);
            memberNameLabel.textColor = KPColorPalette.KPTextColor.grayColor;
            memberNameLabel.text = member.name;
            
            memberEmailLabel.font = UIFont.systemFont(ofSize: 12.0);
            memberEmailLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3;
            memberEmailLabel.text = member.email;
            
            
            self.productMemberContainerViews.append(memberContainer);
            
            if (index <= 1) {
                if index%2 == 0 {
                    self.containerView.addSubview(memberContainer);
                    memberContainer.addConstraints(fromStringArray: ["H:|[$self(140)]",
                                                                     "V:[$view0]-8-[$self]"],
                                                   views: [self.productMemberTitleLabel]);
                } else {
                    self.containerView.addSubview(memberContainer);
                    memberContainer.addConstraints(fromStringArray: ["H:[$self(140)]|",
                                                                     "V:[$view0]-8-[$self]"],
                                                   views: [self.productMemberTitleLabel]);
                }
            } else {
                if index%2 == 0 {
                    self.containerView.addSubview(memberContainer);
                        memberContainer.addConstraints(fromStringArray: ["H:|[$self(140)]",
                                                                         "V:[$view0]-16-[$self]"],
                                                       views: [self.productMemberContainerViews[index-2]]);
                } else {
                    self.containerView.addSubview(memberContainer);
                        memberContainer.addConstraints(fromStringArray: ["H:[$self(140)]|",
                                                                         "V:[$view0]-16-[$self]"],
                                                       views: [self.productMemberContainerViews[index-2]]);
                }
            }
            
            
            memberContainer.addSubview(memberTitleLabel);
            memberTitleLabel.addConstraints(fromStringArray: ["V:|[$self]",
                                                              "H:|[$self]"])
            
            memberContainer.addSubview(memberNameLabel);
            memberNameLabel.addConstraints(fromStringArray: ["V:[$view0]-4-[$self]",
                                                             "H:|[$self]"],
                                           views: [memberTitleLabel]);
            
            memberContainer.addSubview(memberEmailLabel);
            memberEmailLabel.addConstraints(fromStringArray: ["V:[$view0]-4-[$self]|",
                                                              "H:|[$self]"],
                                            views: [memberNameLabel]);
            
        }
        
        self.dataSourceTitleLabel = UILabel();
        self.dataSourceTitleLabel.font = UIFont.systemFont(ofSize: 15.0);
        self.dataSourceTitleLabel.textColor = KPColorPalette.KPTextColor.mainColor;
        self.dataSourceTitleLabel.text = "資料來源";
        self.containerView.addSubview(self.dataSourceTitleLabel);
        self.dataSourceTitleLabel.addConstraints(fromStringArray: ["H:|[$self]", "V:[$view0]-24-[$self]"],
                                                 metrics: [UIScreen.main.bounds.size.width/2],
                                                 views: [self.productMemberContainerViews.last!]);
        
        self.dataSourceContentLabel = UILabel();
        self.dataSourceContentLabel.font = UIFont.systemFont(ofSize: 13.0);
        self.dataSourceContentLabel.textColor = KPColorPalette.KPTextColor.mainColor;
        self.dataSourceContentLabel.text = "https://cafenomad.tw/";
        self.containerView.addSubview(self.dataSourceContentLabel);
        self.dataSourceContentLabel.addConstraints(fromStringArray: ["H:|[$self]", "V:[$view0]-8-[$self]-32-|"],
                                                   metrics: [UIScreen.main.bounds.size.width/2],
                                                   views: [self.dataSourceTitleLabel]);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func handleDismissButtonOnTapped() {
        self.appModalController()?.dismissControllerWithDefaultDuration();
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
