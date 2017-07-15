//
//  KPPriceSelectController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPPriceSelectController: KPSharedSettingViewController {

    var priceRanges = ["1 - 100元 / 人", "101 - 200元 / 人", "201 - 300元 / 人", "301 - 400元 / 人", ">400元 / 人"]
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "價格區間"
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        containerView.addSubview(self.tableView)
        tableView.addConstraints(fromStringArray: ["V:|[$self(360)]|",
                                                   "H:|[$self]|"])
        tableView.register(KPSelectCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        
        sendButton.setTitle("確認送出", for: .normal)
        sendButton.addTarget(self,
                             action: #selector(KPCountrySelectController.handleSendButtonOnTapped),
                             for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSendButtonOnTapped() {
        delegate?.sendButtonTapped(self)
        appModalController()?.dismissControllerWithDefaultDuration()
    }
}


extension KPPriceSelectController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell",
                                                 for: indexPath) as! KPSelectCell;
        cell.contentLabel.text = self.priceRanges[indexPath.row]
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setValue = priceRanges[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceRanges.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

