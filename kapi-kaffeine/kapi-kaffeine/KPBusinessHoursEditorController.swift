//
//  KPBusinessHoursEditorController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 11/02/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPBusinessHoursEditorController: KPNewStoreBasicController {

    weak var uploadData: KPUploadDataModel?
    
    let addButton = UIButton()
    
    fileprivate var businessHours: [String] = [""]
    
    fileprivate var editors: [KPBusinessHoursEditor] = []
    fileprivate var containerHeightConstraint: NSLayoutConstraint!
    
    init(_ data: KPUploadDataModel) {
        uploadData = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        let barLeftItem = UIBarButtonItem(title: "上一步",
                                          style: .plain,
                                          target: self,
                                          action: #selector(handleBackButtonOnTap(_:)))
        barLeftItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: KPFontSize.mainContent), NSAttributedStringKey.foregroundColor: UIColor.gray],
                                           for: .normal)
        
        navigationItem.leftBarButtonItem = barLeftItem
        
        navigationItem.title = "店家營業時間"
        
        scrollView.contentInset.bottom = 60
        
        scrollView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            addButton.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            addButton.topAnchor.constraint(equalTo: scrollContainer.bottomAnchor, constant: 10),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = 3
        addButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.greenColor!), for: .normal)
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton.setTitle("新增營業時段", for: .normal)
        addButton.addTarget(self, action: #selector(handleAddButtonOnTap(_:)), for: .touchUpInside)
        
        
        let submitButton = UIButton(type: .custom)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("設定完成", for: .normal)
        submitButton.clipsToBounds = true
        submitButton.setTitleColor(KPColorPalette.KPMainColor_v2.grayColor_level4,
                                   for: .disabled)
        submitButton.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor,
                                   for: .normal)
        submitButton.layer.cornerRadius = KPLayoutConstant.corner_radius
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.borderColor = KPColorPalette.KPMainColor_v2.grayColor_level3?.cgColor
        
        buttonContainer.addSubview(submitButton)
        submitButton.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                      "V:|-12-[$self(40)]-12-|"])
        submitButton.addTarget(self, action: #selector(KPNewStoreDetailInfoViewController.handleSubmitButtonOnTap(_:)), for: .touchUpInside)
        
        let editor = KPBusinessHoursEditor()
        editor.delegate = self
        editor.deleteButton.isEnabled = false
        scrollContainer.addSubview(editor)
        editor.translatesAutoresizingMaskIntoConstraints = false
        containerHeightConstraint = scrollContainer.heightAnchor.constraint(equalTo: editor.heightAnchor, multiplier: 1)
        NSLayoutConstraint.activate([
            editor.topAnchor.constraint(equalTo: scrollContainer.topAnchor),
            editor.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor),
            editor.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor),
            containerHeightConstraint
        ])

        editors.append(editor)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleSubmitButtonOnTap(_ sender: UIButton) {
        
        guard let `uploadData` = uploadData else {
            return
        }
        
        delegate?.infoViewControllerDidSubmit(self)
        
        var businessHour: [String:String] = [:]
        for (index, editor) in editors.enumerated() {
            let output = editor.outputValue(with: index + 1)
            for (key, value) in output {
                businessHour[key] = value
            }
        }        
        uploadData.businessHour = businessHour
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleAddButtonOnTap(_ sender: UIButton) {
        
        scrollView.isUserInteractionEnabled = false
        
        let editor = KPBusinessHoursEditor()
        editor.delegate = self
        scrollContainer.addSubview(editor)
        scrollContainer.sendSubview(toBack: editor)
        editor.translatesAutoresizingMaskIntoConstraints = false
        var constraint = editor.topAnchor.constraint(equalTo: editors[editors.count-1].topAnchor)
        NSLayoutConstraint.activate([
            editor.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor),
            editor.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor),
            constraint
        ])
        scrollContainer.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.25, animations: {
            NSLayoutConstraint.deactivate([
                self.containerHeightConstraint,
                constraint
            ])
            self.containerHeightConstraint = self.scrollContainer.heightAnchor.constraint(equalTo: editor.heightAnchor, multiplier: CGFloat(self.editors.count + 1))
            constraint = editor.topAnchor.constraint(equalTo: self.editors[self.editors.count-1].bottomAnchor)
            NSLayoutConstraint.activate([
                self.containerHeightConstraint,
                constraint
            ])
            self.scrollView.layoutIfNeeded()
        }) { (finished) in
            self.editors.append(editor)
            if self.editors.count == 2 {
                self.editors.first?.deleteButton.isEnabled = true
            }
            self.scrollView.isUserInteractionEnabled = true
        }
        
    }
    
}

extension KPBusinessHoursEditorController: KPBusinessHoursEditorDelegate {
    
    func deleteHoursEditor(_ editor: KPBusinessHoursEditor) {
        
        guard let deleteIndex = editors.index(of: editor) else {
            return
        }
        
        scrollView.isUserInteractionEnabled = false
        
        NSLayoutConstraint.deactivate([
            containerHeightConstraint
        ])
        editor.removeFromSuperview()
        
        containerHeightConstraint = scrollContainer.heightAnchor.constraint(equalTo: editors[deleteIndex == 0 ? 1 : 0].heightAnchor, multiplier: CGFloat(editors.count - 1))
        var constraints: [NSLayoutConstraint] = [containerHeightConstraint]
        if deleteIndex == 0 {
            constraints.append(editors[1].topAnchor.constraint(equalTo: scrollContainer.topAnchor))
        } else if deleteIndex == editors.count - 1 {
            
        } else {
            constraints.append(editors[deleteIndex+1].topAnchor.constraint(equalTo: editors[deleteIndex-1].bottomAnchor))
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            NSLayoutConstraint.activate(constraints)
            self.scrollView.layoutIfNeeded()
        }) { (finished) in
            self.editors.remove(at: deleteIndex)
            if self.editors.count == 1 {
                self.editors.first?.deleteButton.isEnabled = false
            }
            self.scrollView.isUserInteractionEnabled = true
        }
        
    }
    
}
