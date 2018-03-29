//
//  KPBusinessHoursEditorController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 11/02/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPBusinessHoursEditorController: KPViewController {

    weak var uploadData: KPUploadDataModel?
    
//    var scrollContainer: UIView!
//    var scrollView: UIScrollView!
    var buttonContainer: UIView!
    
    let tableView = UITableView()
    
    let addButton = UIButton()
    
    fileprivate var businessHours: [String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        navigationItem.leftBarButtonItem = nil

//        scrollView = UIScrollView()
//        scrollView.backgroundColor = KPColorPalette.KPMainColor_v2.whiteColor_level1
//        view.addSubview(scrollView)
//
//        scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
//        scrollView.addConstraint(from: "H:|[$self]|")
//
//        scrollContainer = UIView()
//        scrollContainer.backgroundColor = KPColorPalette.KPMainColor_v2.whiteColor_level1
//        scrollView.addSubview(scrollContainer)
//        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
//        scrollContainer.addConstraintForHavingSameWidth(with: view)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.register(KPBusinessHoursEditor.self, forCellReuseIdentifier: "timeEditorCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frameSize.width - 32, height: 60))
        
        footerView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        let constraint = addButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -16)
        constraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            addButton.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 16),
            constraint,
            addButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10),
            addButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -10),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = 3
        addButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.greenColor!), for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.setTitle("新增營業時段", for: .normal)
        addButton.addTarget(self, action: #selector(handleAddButtonOnTap(_:)), for: .touchUpInside)

        tableView.tableFooterView = footerView
        
        buttonContainer = UIView()
        buttonContainer.backgroundColor = KPColorPalette.KPMainColor_v2.whiteColor_level1
        view.addSubview(buttonContainer)
        buttonContainer.layer.borderColor = KPColorPalette.KPBackgroundColor.grayColor_level6?.cgColor
        buttonContainer.layer.borderWidth = 1
        
        buttonContainer.addConstraints(fromStringArray: ["H:|-(-1)-[$self]-(-1)-|", "V:[$self]|"])
        buttonContainer.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        
        let submitButton = UIButton(type: .custom)
        submitButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.greenColor!), for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("完成", for: .normal)
        submitButton.clipsToBounds = true
        submitButton.layer.cornerRadius = 3
        buttonContainer.addSubview(submitButton)
        submitButton.addConstraints(fromStringArray: ["H:[$self]-16-|", "V:|-10-[$self]-10-|"])
        submitButton.addTarget(self, action: #selector(KPNewStoreDetailInfoViewController.handleSubmitButtonOnTap(_:)), for: .touchUpInside)
        
        let backButton = UIButton(type: .custom)
        backButton.setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_description!, for: .normal)
        backButton.setTitle("上一步", for: .normal)
        buttonContainer.addSubview(backButton)
        backButton.addConstraints(fromStringArray: ["H:|-16-[$self]-[$view0]", "V:|-10-[$self]-10-|"],
                                  views: [submitButton])
        backButton.addConstraintForHavingSameWidth(with: submitButton)
        backButton.addTarget(self, action: #selector(KPNewStoreDetailInfoViewController.handleBackButtonOnTap(_:)), for: .touchUpInside)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func handleBackButtonOnTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSubmitButtonOnTap(_ sender: UIButton) {
        
        guard let `uploadData` = uploadData else {
            return
        }
        
        
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAddButtonOnTap(_ sender: UIButton) {
        businessHours.append("")
        tableView.insertRows(at: [IndexPath(row: businessHours.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
    }
    
}

extension KPBusinessHoursEditorController: UITableViewDataSource, UITableViewDelegate, KPBusinessHoursEditorDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businessHours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeEditorCell", for: indexPath) as! KPBusinessHoursEditor
        cell.delegate = self
        return cell
    }
    
    func deleteHoursEditor(_ editor: KPBusinessHoursEditor) {
        if let indexPath = tableView.indexPath(for: editor) {
            businessHours.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
}
