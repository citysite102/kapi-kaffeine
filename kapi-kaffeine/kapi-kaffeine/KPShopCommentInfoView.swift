//
//  KPShopCommentInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopCommentInfoView: UIView {

    static let KPShopCommentInfoCellReuseIdentifier = "cell"
    weak open var informationController: KPInformationViewController?
    
    var tableView: UITableView!
    var tableViewHeightConstraint: NSLayoutConstraint!
    var comments: [KPCommentModel?] = [KPCommentModel?]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0,
                                                         width: UIScreen.main.bounds.size.width,
                                                         height: 1))
        tableView.rowHeight = UITableViewAutomaticDimension
        addSubview(tableView)
        tableView.addConstraints(fromStringArray: ["V:|-(-16)-[$self]|",
                                                   "H:|[$self]|"])
        tableViewHeightConstraint = tableView.addConstraint(forHeight: 0)
        tableView.register(KPShopCommentCell.self,
                           forCellReuseIdentifier: KPShopCommentInfoView.KPShopCommentInfoCellReuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KPShopCommentInfoView: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:KPShopCommentInfoView.KPShopCommentInfoCellReuseIdentifier,
                                                 for: indexPath) as! KPShopCommentCell
        
        if let comment = comments[indexPath.row] {
            cell.userNameLabel.text = comment.displayName
            cell.timeHintLabel.text = comment.createdModifiedContent
            cell.userCommentLabel.setText(text: comment.content,
                                          lineSpacing: 2.4)
            cell.commentID = comment.commentID
            cell.selectionStyle = .none

            if let photoURL = comment.photoURL,
                let url = URL(string: photoURL) {
                cell.userPicture.af_setImage(withURL: url,
                                             placeholderImage: UIImage(color: KPColorPalette.KPBackgroundColor.mainColor_light_10!),
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
            }
            
//            if let likeUser = comment.likes?.first(where: { $0.memberID == KPUserManager.sharedManager.currentUser?.identifier}) {
//                if likeUser.isLike == 0 {
//                    cell.voteDownButton.buttonSelected = true
//                } else {
//                    cell.voteUpButton.buttonSelected = true
//                }
//            }

//            cell.voteUpCount = comment.likeCount ?? 0
//            cell.voteDownCount = comment.dislikeCount ?? 0
            
            if indexPath.row == comments.count-1 || indexPath.row == 2 {
                cell.separator.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count > 3 ? 3 : comments.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let comment = comments[indexPath.row] {
            if comment.memberID == KPUserManager.sharedManager.currentUser?.identifier {
                let editCommentViewController = KPEditCommentController()
                editCommentViewController.defaultCommentModel = comment
                informationController?.navigationController?.pushViewController(viewController: editCommentViewController,
                                                                                animated: true,
                                                                                completion: {})
                if let indexPath = tableView.indexPathForSelectedRow {
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }
        }
        
        
//        let commentDatailedViewController = KPCommentDetailedController()
//        informationController?.navigationController?.pushViewController(viewController: commentDatailedViewController,
//                                                                       animated: true,
//                                                                       completion: {})
//        
//        if let indexPath = tableView.indexPathForSelectedRow {
//            tableView.deselectRow(at: indexPath, animated: false)
//        }
        
    }
}
