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
    
    var tableView: UITableView!
    var tableViewHeightConstraint: NSLayoutConstraint!
    var comments: [KPCommentModel] = [KPCommentModel]() {
        didSet {
            self.tableView.invalidateIntrinsicContentSize()
            self.tableView.reloadData()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isUserInteractionEnabled = false
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 1))
        tableView.rowHeight = UITableViewAutomaticDimension
        addSubview(tableView)
        tableView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                   "H:|[$self]|"])
        tableViewHeightConstraint = tableView.addConstraint(forHeight: 340)
        tableView.register(KPShopCommentCell.self,
                           forCellReuseIdentifier: KPShopCommentInfoView.KPShopCommentInfoCellReuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KPShopCommentInfoView: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:KPShopCommentInfoView.KPShopCommentInfoCellReuseIdentifier,
                                                 for: indexPath) as! KPShopCommentCell
        
        let comment = comments[indexPath.row] 
        cell.userNameLabel.text = comment.displayName
        cell.timeHintLabel.text = comment.createdModifiedContent
        cell.userCommentLabel.setText(text: comment.content,
                                      lineSpacing: 2.4)
        cell.voteUpCount = comment.likeCount ?? 0
        cell.voteDownCount = comment.dislikeCount ?? 0
        
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
}
