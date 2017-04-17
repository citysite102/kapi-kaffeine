//
//  KPDetailViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/11.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPInformationViewController: UIViewController {

    
    var informationDataModel:KPDataModel!
    var dismissButton:UIButton!
    
    var scrollContainer:UIScrollView!;
    var informationHeaderView: KPInformationHeaderView!;
    var shopInformationView: KPInformationSharedInfoView!;
    var locationInformationView: KPInformationSharedInfoView!;
    var rateInformationView: KPInformationSharedInfoView!;
    var commentInformationView: KPInformationSharedInfoView!;
    var photoInformationView: KPInformationSharedInfoView!;
    var recommendInformationView: KPInformationSharedInfoView!;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        self.navigationController?.navigationBar.topItem?.title = self.informationDataModel.name;
        
        self.dismissButton = UIButton.init();
        self.dismissButton.setImage(UIImage.init(named: "icon_close")?.withRenderingMode(.alwaysTemplate),
                                    for: .normal);
        self.dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        self.dismissButton.addTarget(self,
                                     action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside);
        self.navigationController?.navigationBar.addSubview(self.dismissButton);
        self.dismissButton.addConstraints(fromStringArray: ["H:|-16-[$self(24)]",
                                                            "V:[$self(24)]"]);
        self.dismissButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        self.dismissButton.addConstraintForCenterAligningToSuperview(in: .vertical);
        
        self.scrollContainer = UIScrollView();
        self.scrollContainer.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6;
        self.scrollContainer.delegate = self;
        self.view.addSubview(self.scrollContainer);
        self.scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:|[$self]|"]);
        
        self.informationHeaderView = KPInformationHeaderView();
        self.scrollContainer.addSubview(self.informationHeaderView);
        self.informationHeaderView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                    "V:|[$self]"]);
        
        self.shopInformationView = KPInformationSharedInfoView();
        self.shopInformationView.infoTitleLabel.text = "店家資訊";
        self.scrollContainer.addSubview(self.shopInformationView);
        self.shopInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                  "V:[$view0]-16-[$self(200)]"],
                                                      views: [self.informationHeaderView]);
        
        self.locationInformationView = KPInformationSharedInfoView();
        self.locationInformationView.infoTitleLabel.text = "位置訊息";
        let shopLocationInfoView = KPShopLocationInfoView()
        self.locationInformationView.infoView.addSubview(shopLocationInfoView)
        shopLocationInfoView.dataModel = informationDataModel
        shopLocationInfoView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        self.scrollContainer.addSubview(self.locationInformationView);
        self.locationInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                  "V:[$view0]-16-[$self(240)]"],
                                                views: [self.shopInformationView]);
        
        self.rateInformationView = KPInformationSharedInfoView();
        self.rateInformationView.infoTitleLabel.text = "店家評分";
        self.scrollContainer.addSubview(self.rateInformationView);
        self.rateInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                  "V:[$view0]-16-[$self(228)]"],
                                                views: [self.locationInformationView]);
        
        self.commentInformationView = KPInformationSharedInfoView();
        self.commentInformationView.infoTitleLabel.text = "留言評價";
        self.scrollContainer.addSubview(self.commentInformationView);
        self.commentInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                     "V:[$view0]-16-[$self(180)]"],
                                                    views: [self.rateInformationView]);
        
        self.photoInformationView = KPInformationSharedInfoView();
        self.photoInformationView.infoTitleLabel.text = "店家照片";
        self.scrollContainer.addSubview(self.photoInformationView);
        self.photoInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                   "V:[$view0]-16-[$self(170)]"],
                                                    views: [self.commentInformationView]);
        
        self.recommendInformationView = KPInformationSharedInfoView();
        self.recommendInformationView.infoTitleLabel.text = "你可能也會喜歡";
        self.scrollContainer.addSubview(self.recommendInformationView);
        self.recommendInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                       "V:[$view0]-16-[$self(240)]-32-|"],
                                                     views: [self.photoInformationView]);
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleDismissButtonOnTapped() {
        self.dismiss(animated: true, completion: nil);
    }
    
}

extension KPInformationViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollContainer.contentOffset = CGPoint.init(x: 0,
                                                          y: self.scrollContainer.contentOffset.y);
    };
    
}
