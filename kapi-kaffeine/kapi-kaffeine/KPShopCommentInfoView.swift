//
//  KPShopCommentInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopCommentInfoView: UIView {

    static let KPShopCommentInfoCellReuseIdentifier = "cell";
    
    weak var mainController:KPMainViewController!
    var tableView: UITableView!
    var selectedDataModel:KPDataModel!
    
    var displayDataModel: [KPDataModel]! {
        didSet {
            self.tableView.reloadData();
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
        
        self.tableView = UITableView();
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.addSubview(self.tableView);
        self.tableView.addConstraints(fromStringArray: ["V:|[$self(340)]|",
                                                        "H:|[$self]|"]);
        self.tableView.register(KPShopCommentCell.self,
                                forCellReuseIdentifier: KPShopCommentInfoView.KPShopCommentInfoCellReuseIdentifier);
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KPShopCommentInfoView: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:KPShopCommentInfoView.KPShopCommentInfoCellReuseIdentifier,
                                                 for: indexPath) as! KPShopCommentCell;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
}
