//
//  KPCountrySelectController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/21.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPCountrySelectController: KPSharedSettingViewController {

    var countries = ["台北 Taipei", "基隆 Keelung", "台中 Taichung", "火星 Mars"]
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "店家所在城市"
        
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        containerView.addSubview(self.tableView)
        tableView.addConstraints(fromStringArray: ["V:|[$self(360)]|",
                                                   "H:|[$self]|"])
        tableView.register(KPCountrySelectCell.self,
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

extension KPCountrySelectController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell",
                                                 for: indexPath) as! KPCountrySelectCell;
        cell.countryLabel.text = self.countries[indexPath.row]
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setValue = countries[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}


