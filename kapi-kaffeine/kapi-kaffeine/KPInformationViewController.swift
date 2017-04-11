//
//  KPDetailViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/11.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPInformationViewController: UIViewController {

    var scrollContainer:UIScrollView!;
    var shopPhotoContainer:UIView!;
    var shopPhoto:UIImageView!;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        
        self.scrollContainer = UIScrollView();
        self.scrollContainer.delegate = self;
        self.view.addSubview(self.scrollContainer);
        self.scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:|[$self]|"]);
        
        self.shopPhotoContainer = UIView();
        self.scrollContainer.addSubview(self.shopPhotoContainer);
        self.shopPhotoContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                                 "V:|[$self]"]);
        
        self.shopPhoto = UIImageView(image: UIImage(named: "image_shop_demo"));
        self.shopPhoto.contentMode = .scaleAspectFit;
        self.shopPhotoContainer.addSubview(shopPhoto);
        self.shopPhoto.addConstraints(fromStringArray: ["H:|[$self]|",
                                                        "V:|[$self]|"]);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension KPInformationViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollContainer.contentOffset = CGPoint.init(x: 0,
                                                          y: self.scrollContainer.contentOffset.y);
    };
    
}
