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
        self.dismissButton.addConstraints(fromStringArray: ["H:|-8-[$self(24)]",
                                                            "V:[$self(24)]"]);
        self.dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        self.dismissButton.addConstraintForCenterAligningToSuperview(in: .vertical);
        
        self.scrollContainer = UIScrollView();
        self.scrollContainer.backgroundColor = KPColorPalette.KPMainColor.grayColor_level7;
        self.scrollContainer.delegate = self;
        self.view.addSubview(self.scrollContainer);
        self.scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:|[$self]|"]);
        
        self.informationHeaderView = KPInformationHeaderView();
        self.scrollContainer.addSubview(self.informationHeaderView);
        self.informationHeaderView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                    "V:|[$self]"]);
        self.informationHeaderView.addConstraintForHavingSameWidth(with: self.view)
        
        
        let informationView: KPShopInfoView = KPShopInfoView();
        informationView.featureContents = ["食物好吃", "氣氛佳", "看不見桌子"];
        self.shopInformationView = KPInformationSharedInfoView();
        self.shopInformationView.infoView = informationView;
        self.shopInformationView.infoTitleLabel.text = "店家資訊";
        self.scrollContainer.addSubview(self.shopInformationView);
        self.shopInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                  "V:[$view0]-16-[$self(210)]"],
                                                      views: [self.informationHeaderView]);
        
        let shopLocationInfoView = KPShopLocationInfoView();
        shopLocationInfoView.dataModel = informationDataModel;
        self.locationInformationView = KPInformationSharedInfoView();
        self.locationInformationView.infoTitleLabel.text = "位置訊息";
        self.locationInformationView.infoSupplementLabel.text = "距離 600m";
        self.locationInformationView.actions = [Action(title:"開啟導航",
                                                 style:.normal,
                                                 color:KPColorPalette.KPMainColor.buttonColor!,
                                                 icon:(UIImage.init(named: "icon_map")?.withRenderingMode(.alwaysTemplate))!,
                                                 handler:{(infoView) -> () in
                                                    print("Location button 1 Tapped");
        }),
                                                Action(title:"街景模式",
                                                 style:.normal,
                                                 color:KPColorPalette.KPMainColor.buttonColor!,
                                                 icon:(UIImage.init(named: "icon_map")?.withRenderingMode(.alwaysTemplate))!,
                                                 handler:{(infoView) -> () in
                                                    print("Location button 2 Tapped");
                                                })
        ];
        
        self.locationInformationView.infoView = shopLocationInfoView;
        self.scrollContainer.addSubview(self.locationInformationView);
        self.locationInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                  "V:[$view0]-24-[$self(292)]"],
                                                views: [self.shopInformationView]);
        
        let shopRateInfoView = KPShopRateInfoView();
        self.rateInformationView = KPInformationSharedInfoView();
        self.rateInformationView.infoView = shopRateInfoView;
        self.rateInformationView.infoTitleLabel.text = "店家評分";
        self.rateInformationView.infoSupplementLabel.text = "143 人已評分";
        self.rateInformationView.actions = [Action(title:"我要評分",
                                                   style:.normal,
                                                   color:KPColorPalette.KPMainColor.buttonColor!,
                                                   icon:(UIImage.init(named: "icon_map")?.withRenderingMode(.alwaysTemplate))!,
                                                   handler:{(infoView) -> () in
                                                    print("Location button 1 Tapped");
        })];
        self.scrollContainer.addSubview(self.rateInformationView);
        self.rateInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                  "V:[$view0]-24-[$self]"],
                                                views: [self.locationInformationView]);
        
        
        let commentInfoView = KPShopCommentInfoView();
        self.commentInformationView = KPInformationSharedInfoView();
        self.commentInformationView.infoView = commentInfoView;
        self.commentInformationView.infoTitleLabel.text = "留言評價";
        self.commentInformationView.infoSupplementLabel.text = "82 人已留言";
        self.scrollContainer.addSubview(self.commentInformationView);
        self.commentInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                     "V:[$view0]-24-[$self]"],
                                                    views: [self.rateInformationView]);
        self.commentInformationView.actions = [Action(title:"看更多評價(20)",
                                                      style:.normal,
                                                      color:KPColorPalette.KPMainColor.buttonColor!,
                                                      icon:(UIImage.init(named: "icon_map")?.withRenderingMode(.alwaysTemplate))!,
                                                      handler:{(infoView) -> () in
                                                        print("Comment button 1 Tapped");
        }),
                                                Action(title:"我要留言",
                                                       style:.normal,
                                                       color:KPColorPalette.KPMainColor.buttonColor!,
                                                       icon:(UIImage.init(named: "icon_map")?.withRenderingMode(.alwaysTemplate))!,
                                                       handler:{(infoView) -> () in
                                                        print("Comment button 2 Tapped");
                                                })
        ];
        
        
        let photoInfoView = KPShopPhotoInfoView();
        self.photoInformationView = KPInformationSharedInfoView();
        self.photoInformationView.infoView = photoInfoView;
        self.photoInformationView.infoTitleLabel.text = "店家照片";
        self.scrollContainer.addSubview(self.photoInformationView);
        self.photoInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                   "V:[$view0]-24-[$self]"],
                                                    views: [self.commentInformationView]);
        self.photoInformationView.actions = [Action(title:"上傳照片",
                                                   style:.normal,
                                                   color:KPColorPalette.KPMainColor.buttonColor!,
                                                   icon:(UIImage.init(named: "icon_map")?.withRenderingMode(.alwaysTemplate))!,
                                                   handler:{(infoView) -> () in
                                                    print("Photo button 1 Tapped");
        })]
        
        let shopRecommendView = KPShopRecommendView();
        shopRecommendView.displayDataModel = [self.informationDataModel,
                                              self.informationDataModel,
                                              self.informationDataModel];
        self.recommendInformationView = KPInformationSharedInfoView();
        self.recommendInformationView.infoView = shopRecommendView;
        self.recommendInformationView.infoTitleLabel.text = "你可能也會喜歡";
        self.scrollContainer.addSubview(self.recommendInformationView);
        self.recommendInformationView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                       "V:[$view0]-24-[$self]-32-|"],
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
