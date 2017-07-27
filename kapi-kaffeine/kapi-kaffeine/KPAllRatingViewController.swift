//
//  KPAllRatingViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/24.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPAllRatingViewController: KPViewController {

    static let KPAllRatingControllerCellReuseIdentifier = "cell"
    
    var tableView: UITableView!
    var backButton: KPBounceButton!
    var ratings: [KPSimpleRateModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = KPColorPalette.KPTextColor.whiteColor
        navigationItem.title = "所有評分"
        navigationItem.hidesBackButton = true
        
        backButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24),
                                    image: R.image.icon_back()!)
        backButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        backButton.addTarget(self,
                             action: #selector(KPAllCommentController.handleBackButtonOnTapped),
                             for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: backButton)
        
//        editButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24),
//                                    image: R.image.icon_edit()!)
//        editButton.tintColor = KPColorPalette.KPTextColor.whiteColor
//        editButton.addTarget(self,
//                             action: #selector(KPAllCommentController.handleEditButtonOnTapped),
//                             for: .touchUpInside)
//        
//        let rightbarItem = UIBarButtonItem(customView: editButton)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
//        navigationItem.rightBarButtonItems = [negativeSpacer, rightbarItem]
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        view.addSubview(tableView)
        tableView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                   "H:|[$self]|"])
        tableView.register(KPShopRatingCell.self,
                           forCellReuseIdentifier: KPAllRatingViewController.KPAllRatingControllerCellReuseIdentifier)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleBackButtonOnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension KPAllRatingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KPAllRatingViewController.KPAllRatingControllerCellReuseIdentifier,
                                                 for: indexPath) as! KPShopRatingCell
        cell.selectionStyle = .none
        cell.rateData = ratings[indexPath.row]
        cell.userNameLabel.text = ratings[indexPath.row].displayName
        cell.timeHintLabel.text = ratings[indexPath.row].createdModifiedContent
        
        if let photoURL = ratings[indexPath.row].photoURL {
            cell.userPicture.af_setImage(withURL: URL(string: photoURL)!,
                                         placeholderImage: nil,
                                         filter: nil,
                                         progress: nil,
                                         progressQueue: DispatchQueue.global(),
                                         imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                         runImageTransitionIfCached: true,
                                         completion: { response in
                                            if let responseImage = response.result.value {
                                                cell.userPicture.image = responseImage
                                            }
            })
        } else {
            cell.userPicture.image = R.image.demo_profile()
        }
    
        if indexPath.row == ratings.count-1 {
            cell.separator.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratings.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

}
