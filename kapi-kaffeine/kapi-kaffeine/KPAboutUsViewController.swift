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
    var iconInformationLabel: UILabel!
    
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
        
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.topItem?.title = "關於我們"
        
        dismissButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30),
                                       image: R.image.icon_close()!)
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(6, 7, 8, 7)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.addTarget(self,
                                     action: #selector(KPAboutUsViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside)
        
        
        let barItem = UIBarButtonItem(customView: dismissButton)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -7
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]

        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                    "H:|[$self]|"])
        
        containerView = UIView()
        scrollView.addSubview(containerView)
        containerView.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                       "V:|[$self]|"])
        containerView.addConstraintForHavingSameWidth(with: view,
                                                      constant: -32)
        
        iconImageView = UIImageView()
        iconImageView.image = R.image.logo_v2()
        containerView.addSubview(iconImageView)
        iconImageView.addConstraints(fromStringArray: ["V:|-($metric0)-[$self(80)]",
                                                       "H:|[$self(80)]"],
                                          metrics:[32])
        
        iconTitleView = UIImageView()
        iconTitleView.image = R.image.logo_text()
        containerView.addSubview(iconTitleView)
        iconTitleView.addConstraints(fromStringArray: ["V:|-($metric0)-[$self]",
                                                       "H:[$view0]-16-[$self]"],
                                          metrics:[33],
                                          views:[iconImageView])
        
        iconInformationLabel = UILabel()
        iconInformationLabel.font = UIFont.systemFont(ofSize: 16.0)
        iconInformationLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3
        iconInformationLabel.text = "快速找到最適合的咖啡店"
        containerView.addSubview(iconInformationLabel)
        iconInformationLabel.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(20)]",
                                                              "H:[$view1]-16-[$self(220)]"],
                                                views:[iconTitleView,
                                                       iconImageView])
        
        moreFeatureButton = UIButton()
        moreFeatureButton.setBackgroundImage(R.image.button_feature(), for: .normal)
        containerView.addSubview(moreFeatureButton)
        moreFeatureButton.addConstraints(fromStringArray: ["V:[$self(24)]",
                                                           "H:[$view0]-16-[$self(92)]"],
                                              views: [iconImageView])
        moreFeatureButton.addConstraintForAligning(to: .bottom,
                                                   of: iconImageView)
        moreFeatureButton.addTarget(self,
                                    action: #selector(KPAboutUsViewController.handleMoreFeatureButtonOnTapped),
                                    for: .touchUpInside);
        
        
        productDescriptionTitleLabel = UILabel()
        productDescriptionTitleLabel.font = UIFont.systemFont(ofSize: 18.0)
        productDescriptionTitleLabel.textColor = KPColorPalette.KPTextColor.mainColor
        productDescriptionTitleLabel.text = "產品介紹"
        containerView.addSubview(productDescriptionTitleLabel)
        productDescriptionTitleLabel.addConstraints(fromStringArray: ["H:|[$self]", "V:[$view0]-24-[$self]"],
                                            views: [iconImageView])
        
        productDescriptionContentLabel = UILabel()
        productDescriptionContentLabel.font = UIFont.systemFont(ofSize: 14.0)
        productDescriptionContentLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3
        productDescriptionContentLabel.text = "找尋適合的咖啡店一直不是件容易的事，我們希望提供一個解決方案，讓你能輕鬆找到最適合自己的咖啡店，" +
        "不論你想要去咖啡店工作、聚餐、聊天都能快速找到適合的店家。我們將持續優化產品，有任何建議也歡迎隨時來信告訴我們:D"
        productDescriptionContentLabel.textAlignment = .left
        productDescriptionContentLabel.numberOfLines = 0
        containerView.addSubview(productDescriptionContentLabel)
        productDescriptionContentLabel.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                             "V:[$view0]-8-[$self]"],
                                                              views: [productDescriptionTitleLabel])
        
        productMemberTitleLabel = UILabel()
        productMemberTitleLabel.font = UIFont.systemFont(ofSize: 18.0)
        productMemberTitleLabel.textColor = KPColorPalette.KPTextColor.mainColor
        productMemberTitleLabel.text = "團隊成員"
        containerView.addSubview(productMemberTitleLabel)
        productMemberTitleLabel.addConstraints(fromStringArray: ["H:|[$self]", "V:[$view0]-24-[$self]"],
                                                         metrics: [UIScreen.main.bounds.size.width/2],
                                                         views: [productDescriptionContentLabel])

        for (index, member) in productMembers.enumerated() {
            
            let memberContainer = UIView()
            let memberTitleLabel = UILabel()
            let memberNameLabel = UILabel()
            let memberEmailLabel = UILabel()
            
            memberTitleLabel.font = UIFont.systemFont(ofSize: 12.0)
            memberTitleLabel.textColor = KPColorPalette.KPTextColor.mainColor_light
            memberTitleLabel.text = member.title
            
            memberNameLabel.font = UIFont.systemFont(ofSize: 14.0)
            memberNameLabel.textColor = KPColorPalette.KPTextColor.grayColor
            memberNameLabel.text = member.name
            
            memberEmailLabel.font = UIFont.systemFont(ofSize: 12.0)
            memberEmailLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3
            memberEmailLabel.text = member.email
            
            
            productMemberContainerViews.append(memberContainer)
            
            if (index <= 1) {
                if index%2 == 0 {
                    containerView.addSubview(memberContainer)
                    memberContainer.addConstraints(fromStringArray: ["H:|[$self(140)]",
                                                                     "V:[$view0]-8-[$self]"],
                                                   views: [productMemberTitleLabel])
                } else {
                    containerView.addSubview(memberContainer)
                    memberContainer.addConstraints(fromStringArray: ["H:[$self(140)]|",
                                                                     "V:[$view0]-8-[$self]"],
                                                   views: [productMemberTitleLabel])
                }
            } else {
                if index%2 == 0 {
                    containerView.addSubview(memberContainer)
                        memberContainer.addConstraints(fromStringArray: ["H:|[$self(140)]",
                                                                         "V:[$view0]-16-[$self]"],
                                                       views: [productMemberContainerViews[index-2]])
                } else {
                    containerView.addSubview(memberContainer)
                        memberContainer.addConstraints(fromStringArray: ["H:[$self(140)]|",
                                                                         "V:[$view0]-16-[$self]"],
                                                       views: [productMemberContainerViews[index-2]])
                }
            }
            
            
            memberContainer.addSubview(memberTitleLabel)
            memberTitleLabel.addConstraints(fromStringArray: ["V:|[$self]",
                                                              "H:|[$self]"])
            
            memberContainer.addSubview(memberNameLabel)
            memberNameLabel.addConstraints(fromStringArray: ["V:[$view0]-4-[$self]",
                                                             "H:|[$self]"],
                                           views: [memberTitleLabel])
            
            memberContainer.addSubview(memberEmailLabel)
            memberEmailLabel.addConstraints(fromStringArray: ["V:[$view0]-4-[$self]|",
                                                              "H:|[$self]"],
                                            views: [memberNameLabel])
            
        }
        
        dataSourceTitleLabel = UILabel()
        dataSourceTitleLabel.font = UIFont.systemFont(ofSize: 18.0)
        dataSourceTitleLabel.textColor = KPColorPalette.KPTextColor.mainColor
        dataSourceTitleLabel.text = "資料來源"
        containerView.addSubview(dataSourceTitleLabel)
        dataSourceTitleLabel.addConstraints(fromStringArray: ["H:|[$self]", "V:[$view0]-24-[$self]"],
                                                 metrics: [UIScreen.main.bounds.size.width/2],
                                                 views: [productMemberContainerViews.last!])
        
        dataSourceContentLabel = UILabel()
        dataSourceContentLabel.font = UIFont.systemFont(ofSize: 14.0)
        dataSourceContentLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3
        dataSourceContentLabel.text = "https://cafenomad.tw/"
        containerView.addSubview(dataSourceContentLabel)
        dataSourceContentLabel.addConstraints(fromStringArray: ["H:|[$self]", "V:[$view0]-8-[$self]-32-|"],
                                                   metrics: [UIScreen.main.bounds.size.width/2],
                                                   views: [dataSourceTitleLabel])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func handleDismissButtonOnTapped() {
        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    func handleMoreFeatureButtonOnTapped() {
        let controller = KPModalViewController()
        controller.edgeInset = UIEdgeInsets(top: 0,
                                            left: 0,
                                            bottom: 0,
                                            right: 0)
        let introController = KPIntroViewController()
        appModalController()?.present(introController, animated: true, completion: nil)
        
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
