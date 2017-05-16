//
//  KPAllCommentController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/16.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPAllCommentController: UIViewController {

    static let KPAllCommentControllerCellReuseIdentifier = "cell";
    
    var tableView: UITableView!
    var dismissButton:KPBounceButton!
    var editButton:KPBounceButton!
    var comments: [KPCommentModel]! {
        didSet {
            self.tableView.reloadData();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = KPColorPalette.KPTextColor.whiteColor
        self.navigationItem.title = "所有評價"
        self.navigationItem.hidesBackButton = true
        
        
        dismissButton = KPBounceButton.init(frame: CGRect.init(x: 0, y: 0, width: 24, height: 24));
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        dismissButton.setImage(R.image.icon_back()?.withRenderingMode(.alwaysTemplate),
                               for: .normal);
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor;
        dismissButton.addTarget(self,
                                action: #selector(KPSearchViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        let barItem = UIBarButtonItem.init(customView: self.dismissButton);
        
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        
        self.navigationItem.leftBarButtonItems = [negativeSpacer, UIBarButtonItem.init(image: R.image.icon_back(),
                                                                                       style: .plain,
                                                                                       target: self,
                                                                                       action: #selector(KPPhotoGalleryViewController.handleBackButtonOnTapped))]
        //
//        //        let barItem = UIBarButtonItem.init(customView: self.dismissButton);
//        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
//                                             target: nil,
//                                             action: nil)
//        negativeSpacer.width = -8
//        //        navigationItem.rightBarButtonItems = [negativeSpacer, barItem]

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = false
        view.addSubview(self.tableView)
        tableView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                   "H:|[$self]|"])
        tableView.register(KPShopCommentCell.self,
                           forCellReuseIdentifier: KPAllCommentController.KPAllCommentControllerCellReuseIdentifier)
        
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

extension KPAllCommentController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:KPShopCommentInfoView.KPShopCommentInfoCellReuseIdentifier,
                                                 for: indexPath) as! KPShopCommentCell;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}
