//
//  KPSettingViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/24.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSettingViewController: UIViewController {

    var dismissButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white;
        self.navigationController?.navigationBar.topItem?.title = "設定";
        
        self.dismissButton = UIButton.init();
        self.dismissButton.setImage(UIImage.init(named: "icon_close")?.withRenderingMode(.alwaysTemplate),
                                    for: .normal);
        self.dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        self.dismissButton.addTarget(self,
                                     action: #selector(KPInformationViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside);
        
//        self.navigationController?.navigationBar.addSubview(self.dismissButton);
//        self.dismissButton.addConstraints(fromStringArray: ["H:|-8-[$self(24)]",
//                                                            "V:[$self(24)]"]);
//        self.dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
//        self.dismissButton.addConstraintForCenterAligningToSuperview(in: .vertical);
        
        let barItem = UIBarButtonItem.init(customView: self.dismissButton);
        self.navigationItem.leftBarButtonItem = barItem;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
