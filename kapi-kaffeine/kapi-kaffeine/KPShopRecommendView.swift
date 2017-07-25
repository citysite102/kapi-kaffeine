//
//  KPShopRecommendView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/18.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopRecommendView: UIView {

    static let KPShopRecommendViewCellReuseIdentifier = "cell"
    weak open var informationController: KPInformationViewController?
    
    var tableView: UITableView!
    var displayDataModels: [KPDataModel]! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = false
        tableView.separatorColor = UIColor.clear
        self.addSubview(self.tableView)
        self.tableView.addConstraints(fromStringArray: ["V:|[$self(420)]|",
                                                        "H:|[$self]|"])
        self.tableView.register(KPMainListTableViewCell.self,
                                forCellReuseIdentifier: KPShopRecommendView.KPShopRecommendViewCellReuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KPShopRecommendView: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:KPShopRecommendView.KPShopRecommendViewCellReuseIdentifier,
                                                 for: indexPath) as! KPMainListTableViewCell
        
        cell.selectionStyle = .none
        cell.dataModel = self.displayDataModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayDataModels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = KPInformationViewController()
        controller.informationDataModel = self.displayDataModels[indexPath.row]
        informationController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
