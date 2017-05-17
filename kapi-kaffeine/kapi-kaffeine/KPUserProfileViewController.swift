//
//  KPUserProfileViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPUserProfileViewController: KPViewController {

    var dismissButton:UIButton!
    
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
