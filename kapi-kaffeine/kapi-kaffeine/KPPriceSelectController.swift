//
//  KPPriceSelectController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPPriceSelectController: KPSharedSettingViewController {
    
    static var priceRanges = ["NT$1-100元 / 人",
                              "NT$101-200元 / 人",
                              "NT$201-300元 / 人",
                              "NT$301-400元 / 人",
                              "大於NT$400元 / 人"]
    var tableView: UITableView!
    var tag: Int?
    
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
        
        seperator_two.isHidden = true
        sendButton.setTitle("確認送出", for: .normal)
        sendButton.isHidden = true
        sendButton.addTarget(self,
                             action: #selector(handleSendButtonOnTapped),
                             for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleSendButtonOnTapped() {
        delegate?.returnValueSet(self)
        appModalController()?.dismissControllerWithDefaultDuration()
    }
}


extension KPPriceSelectController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell",
                                                 for: indexPath) as! KPSelectCell;
        cell.contentLabel.text = KPPriceSelectController.priceRanges[indexPath.row]
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        returnValue = KPPriceSelectController.priceRanges[indexPath.row]
        delegate?.returnValueSet(self)
        dismiss(animated: true, completion: nil)
//        appModalController()?.dismissControllerWithDefaultDuration()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KPPriceSelectController.priceRanges.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

