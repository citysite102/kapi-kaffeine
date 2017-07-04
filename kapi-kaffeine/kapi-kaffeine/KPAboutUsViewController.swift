//
//  KPAboutUsViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/25.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPAboutUsViewController: KPViewController {

    
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
        
        view.backgroundColor = UIColor.white;
        navigationController?.navigationBar.topItem?.title = "設定";
        
        dismissButton = KPBounceButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24));
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        dismissButton.setImage(UIImage.init(named: "icon_close")?.withRenderingMode(.alwaysTemplate),
                                    for: .normal);
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        dismissButton.addTarget(self,
                                     action: #selector(KPAboutUsViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside);
        
        
        let barItem = UIBarButtonItem.init(customView: dismissButton);
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -8;
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]

        scrollView = UIScrollView();
        scrollView.showsVerticalScrollIndicator = false;
        view.addSubview(scrollView);
        scrollView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                    "H:|[$self]|"]);
        
        containerView = UIView();
        scrollView.addSubview(containerView);
        containerView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                       "V:|[$self]|"]);
        containerView.addConstraintForHavingSameWidth(with: view,
                                                      constant: -32);
        
        iconImageView = UIImageView();
        iconImageView.backgroundColor = KPColorPalette.KPMainColor.mainColor;
        containerView.addSubview(iconImageView);
        iconImageView.addConstraints(fromStringArray: ["V:|-($metric0)-[$self(80)]",
                                                       "H:|[$self(80)]"],
                                          metrics:[32]);
        
        iconTitleView = UIImageView();
        iconTitleView.backgroundColor = KPColorPalette.KPMainColor.grayColor_level2;
        containerView.addSubview(iconTitleView);
        iconTitleView.addConstraints(fromStringArray: ["V:|-($metric0)-[$self(24)]",
                                                       "H:[$view0]-16-[$self(64)]"],
                                          metrics:[32],
                                          views:[iconImageView]);
        
        iconInformationView = UIImageView();
        iconInformationView.backgroundColor = KPColorPalette.KPMainColor.grayColor_level2;
        containerView.addSubview(iconInformationView);
        iconInformationView.addConstraints(fromStringArray: ["V:[$view0]-4-[$self(18)]",
                                                             "H:[$view1]-16-[$self(100)]"],
                                                views:[iconTitleView, iconImageView]);
        
        moreFeatureButton = UIButton();
        moreFeatureButton.backgroundColor = KPColorPalette.KPMainColor.grayColor_level2;
        containerView.addSubview(moreFeatureButton);
        moreFeatureButton.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(24)]",
                                                                "H:[$view1]-16-[$self(92)]"],
                                              views: [iconInformationView, iconImageView]);
        
        productDescriptionTitleLabel = UILabel();
        productDescriptionTitleLabel.font = UIFont.systemFont(ofSize: 18.0);
        productDescriptionTitleLabel.textColor = KPColorPalette.KPTextColor.mainColor;
        productDescriptionTitleLabel.text = "產品介紹";
        containerView.addSubview(productDescriptionTitleLabel);
        productDescriptionTitleLabel.addConstraints(fromStringArray: ["H:|[$self]", "V:[$view0]-24-[$self]"],
                                            views: [iconImageView]);
        
        productDescriptionContentLabel = UILabel();
        productDescriptionContentLabel.font = UIFont.systemFont(ofSize: 14.0);
        productDescriptionContentLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3;
        productDescriptionContentLabel.text = "有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，" +
        "有事情嗎。沒事。有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎，有事情嗎。沒事。";
        productDescriptionContentLabel.textAlignment = .left;
        productDescriptionContentLabel.numberOfLines = 0;
        containerView.addSubview(productDescriptionContentLabel);
        productDescriptionContentLabel.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                             "V:[$view0]-8-[$self]"],
                                                              views: [productDescriptionTitleLabel]);
        
        productMemberTitleLabel = UILabel();
        productMemberTitleLabel.font = UIFont.systemFont(ofSize: 18.0);
        productMemberTitleLabel.textColor = KPColorPalette.KPTextColor.mainColor;
        productMemberTitleLabel.text = "團隊成員";
        containerView.addSubview(productMemberTitleLabel);
        productMemberTitleLabel.addConstraints(fromStringArray: ["H:|[$self]", "V:[$view0]-24-[$self]"],
                                                         metrics: [UIScreen.main.bounds.size.width/2],
                                                         views: [productDescriptionContentLabel]);

        for (index, member) in productMembers.enumerated() {
            
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
            
            
            productMemberContainerViews.append(memberContainer);
            
            if (index <= 1) {
                if index%2 == 0 {
                    containerView.addSubview(memberContainer);
                    memberContainer.addConstraints(fromStringArray: ["H:|[$self(140)]",
                                                                     "V:[$view0]-8-[$self]"],
                                                   views: [productMemberTitleLabel]);
                } else {
                    containerView.addSubview(memberContainer);
                    memberContainer.addConstraints(fromStringArray: ["H:[$self(140)]|",
                                                                     "V:[$view0]-8-[$self]"],
                                                   views: [productMemberTitleLabel]);
                }
            } else {
                if index%2 == 0 {
                    containerView.addSubview(memberContainer);
                        memberContainer.addConstraints(fromStringArray: ["H:|[$self(140)]",
                                                                         "V:[$view0]-16-[$self]"],
                                                       views: [productMemberContainerViews[index-2]]);
                } else {
                    containerView.addSubview(memberContainer);
                        memberContainer.addConstraints(fromStringArray: ["H:[$self(140)]|",
                                                                         "V:[$view0]-16-[$self]"],
                                                       views: [productMemberContainerViews[index-2]]);
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
        
        dataSourceTitleLabel = UILabel();
        dataSourceTitleLabel.font = UIFont.systemFont(ofSize: 18.0);
        dataSourceTitleLabel.textColor = KPColorPalette.KPTextColor.mainColor;
        dataSourceTitleLabel.text = "資料來源";
        containerView.addSubview(dataSourceTitleLabel);
        dataSourceTitleLabel.addConstraints(fromStringArray: ["H:|[$self]", "V:[$view0]-24-[$self]"],
                                                 metrics: [UIScreen.main.bounds.size.width/2],
                                                 views: [productMemberContainerViews.last!]);
        
        dataSourceContentLabel = UILabel();
        dataSourceContentLabel.font = UIFont.systemFont(ofSize: 14.0);
        dataSourceContentLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3;
        dataSourceContentLabel.text = "https://cafenomad.tw/";
        containerView.addSubview(dataSourceContentLabel);
        dataSourceContentLabel.addConstraints(fromStringArray: ["H:|[$self]", "V:[$view0]-8-[$self]-32-|"],
                                                   metrics: [UIScreen.main.bounds.size.width/2],
                                                   views: [dataSourceTitleLabel]);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func handleDismissButtonOnTapped() {
        appModalController()?.dismissControllerWithDefaultDuration();
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
