//
//  KPMainViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPMainViewController: UIViewController {

    var searchHeaderView:KPSearchHeaderView!
    var searchFooterView:KPSearchFooterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        UIApplication.shared.statusBarStyle = .lightContent;
        
        self.searchHeaderView = KPSearchHeaderView();
        self.view.addSubview(searchHeaderView);
        self.searchHeaderView.addConstraints(fromStringArray: ["V:|[$self(100)]", "H:|[$self]|"])
        
        self.searchFooterView = KPSearchFooterView();
        self.view.addSubview(searchFooterView);
        self.searchFooterView.addConstraints(fromStringArray: ["V:[$self(40)]|", "H:|[$self]|"])
        
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
