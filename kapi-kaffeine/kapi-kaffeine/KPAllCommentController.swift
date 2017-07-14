//
//  KPAllCommentController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/16.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPAllCommentController: KPViewController {

    static let KPAllCommentControllerCellReuseIdentifier = "cell"
    
    
    var shownCellIndex: [Int] = [Int]()
    var animated: Bool = true
    var tableView: UITableView!
    var backButton: KPBounceButton!
    var editButton: KPBounceButton!
    var comments: [KPCommentModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = KPColorPalette.KPTextColor.whiteColor
        navigationItem.title = "所有評價"
        navigationItem.hidesBackButton = true
        
        backButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24),
                                    image: R.image.icon_back()!)
        backButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        backButton.addTarget(self,
                             action: #selector(KPAllCommentController.handleBackButtonOnTapped),
                             for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: backButton)
        
        editButton = KPBounceButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24),
                                    image: R.image.icon_edit()!)
        editButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        editButton.addTarget(self,
                             action: #selector(KPAllCommentController.handleEditButtonOnTapped),
                             for: .touchUpInside)
        
        let rightbarItem = UIBarButtonItem(customView: editButton)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                             target: nil,
                                             action: nil)
        negativeSpacer.width = -8
        
        navigationItem.leftBarButtonItems = [negativeSpacer, barItem]
        navigationItem.rightBarButtonItems = [negativeSpacer, rightbarItem]
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)
        tableView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                   "H:|[$self]|"])
        tableView.register(KPShopCommentCell.self,
                           forCellReuseIdentifier: KPAllCommentController.KPAllCommentControllerCellReuseIdentifier)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func handleBackButtonOnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleEditButtonOnTapped() {
        let newCommentViewController = KPNewCommentController()
        navigationController?.pushViewController(viewController: newCommentViewController,
                                                      animated: true,
                                                      completion: {})
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
        let cell = tableView.dequeueReusableCell(withIdentifier: KPAllCommentController.KPAllCommentControllerCellReuseIdentifier,
                                                 for: indexPath) as! KPShopCommentCell
        cell.selectionStyle = .none
        
        let comment = comments[indexPath.row]
        cell.userNameLabel.text = comment.displayName
        cell.timeHintLabel.text = comment.createdModifiedContent
        cell.userCommentLabel.setText(text: comment.content, lineSpacing: 2.4)
        cell.voteUpCount = comment.likeCount ?? 0
        cell.voteDownCount = comment.dislikeCount ?? 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let displayCell = cell as! KPShopCommentCell
        
        if !shownCellIndex.contains(indexPath.row) && animated {
            displayCell.userPicture.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).rotated(by: -CGFloat.pi/2)
            UIView.animate(withDuration: 0.7,
                           delay: 0.2+Double(indexPath.row)*0.05,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0.8,
                           options: .curveEaseOut,
                           animations: { 
                            displayCell.userPicture.transform = CGAffineTransform.identity
            }) { (_) in
                self.shownCellIndex.append(indexPath.row)
            }
        }
    }
}
