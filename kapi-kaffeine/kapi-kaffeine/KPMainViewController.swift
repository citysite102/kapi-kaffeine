//
//  KPMainViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/10.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit


protocol KPMainViewControllerDelegate {
    var selectedDataModel: KPDataModel { get }
}

class KPMainViewController: UIViewController {

    var searchHeaderView: KPSearchHeaderView!
    var searchFooterView: KPSearchFooterView!
    
    var currentController: UIViewController! {
        didSet {
            
            if oldValue != nil {
                oldValue?.willMove(toParentViewController: nil);
                oldValue?.view.removeFromSuperview();
                oldValue?.removeFromParentViewController();
            }
            
            self.addChildViewController(currentController!);
            self.view.addSubview((self.currentController?.view)!);
            currentController.didMove(toParentViewController: self);
            currentController.view.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"]);
            
            if (self.searchFooterView != nil && self.searchHeaderView != nil) {
                self.view.bringSubview(toFront: self.searchHeaderView)
                self.view.bringSubview(toFront: self.searchFooterView)
            }
        }
    }
    
    var mainListViewController:KPMainListViewController!
    var mainMapViewController:KPMainMapViewController!
        
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.mainListViewController = KPMainListViewController();
        self.mainMapViewController = KPMainMapViewController();
        self.mainListViewController.mainController = self;
        self.mainMapViewController.mainController = self;
        
        self.currentController = self.mainListViewController;
        
        self.searchHeaderView = KPSearchHeaderView();
        self.view.addSubview(searchHeaderView);
        self.searchHeaderView.addConstraints(fromStringArray: ["V:|[$self(100)]",
                                                               "H:|[$self]|"])
        
        self.searchHeaderView.styleButton.addTarget(self,
                                                    action: #selector(changeStyle),
                                                    for: .touchUpInside)
        
        self.searchFooterView = KPSearchFooterView();
        self.searchFooterView.layer.shadowColor = UIColor.black.cgColor;
        self.searchFooterView.layer.shadowOpacity = 0.15;
        self.searchFooterView.layer.shadowOffset = CGSize.init(width: 0.0, height: -1.0);
        self.view.addSubview(searchFooterView);
        self.searchFooterView.addConstraints(fromStringArray: ["V:[$self(40)]|", "H:|[$self]|"])
        
    }
    
    func changeStyle() {
        if (self.currentController == self.mainListViewController) {
            self.currentController = self.mainMapViewController
            self.searchHeaderView.styleButton.setImage(UIImage.init(named: "icon_list")?.withRenderingMode(.alwaysTemplate),
                                                                        for: .normal);
        } else {
            self.currentController = self.mainListViewController
            self.searchHeaderView.styleButton.setImage(UIImage.init(named: "icon_map")?.withRenderingMode(.alwaysTemplate),
                                                       for: .normal);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "datailedInformationSegue" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let targetController = destinationNavigationController.topViewController as! KPInformationViewController
            targetController.informationDataModel = (sender as! KPMainViewControllerDelegate).selectedDataModel
        }
    }

}
