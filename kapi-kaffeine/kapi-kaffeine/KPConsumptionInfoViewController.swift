//
//  KPConsumptionInfoViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 30/01/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPConsumptionInfoViewController: KPNewStoreBasicController {

    weak var uploadData: KPUploadDataModel?
    
    let ratingTitleEditor = KPTitleEditorView<KPRatingView>("整體消費體驗")
    let commentTitleEditor = KPTitleEditorView<UITextView>("留下評論")
    let drinkPriceEditor = KPTitleEditorView<UITextField>("飲品價位")
    let foodPriceEditor = KPTitleEditorView<UITextField>("餐點價位")
    
    
    init(_ data: KPUploadDataModel) {
        uploadData = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = nil
        navigationItem.title = "消費體驗資訊"
        
        let submitButton = UIButton(type: .custom)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("設定完成", for: .normal)
        submitButton.clipsToBounds = true
        submitButton.setTitleColor(KPColorPalette.KPMainColor_v2.grayColor_level4,
                                   for: .disabled)
        submitButton.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor,
                                   for: .normal)
        submitButton.layer.cornerRadius = 4.0
        submitButton.layer.cornerRadius = 4.0
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.borderColor = KPColorPalette.KPMainColor_v2.grayColor_level3?.cgColor
        buttonContainer.addSubview(submitButton)
        submitButton.addConstraints(fromStringArray: ["H:|-16-[$self]-16-|",
                                                      "V:|-12-[$self(40)]-12-|"])
        submitButton.addTarget(self, action: #selector(KPNewStoreDetailInfoViewController.handleSubmitButtonOnTap(_:)), for: .touchUpInside)
        
        scrollContainer.addSubview(ratingTitleEditor)
        ratingTitleEditor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingTitleEditor.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            ratingTitleEditor.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            ratingTitleEditor.topAnchor.constraint(equalTo: scrollContainer.topAnchor, constant: 20)
        ])
        
        
        scrollContainer.addSubview(commentTitleEditor)
        commentTitleEditor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentTitleEditor.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            commentTitleEditor.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            commentTitleEditor.topAnchor.constraint(equalTo: ratingTitleEditor.bottomAnchor, constant: 20),
            commentTitleEditor.contentView.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        scrollContainer.addSubview(drinkPriceEditor)
        drinkPriceEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:[$view0]-20-[$self]"],
                                        views: [commentTitleEditor])
        
        scrollContainer.addSubview(foodPriceEditor)
        foodPriceEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:[$view0]-20-[$self]-20-|"],
                                       views: [drinkPriceEditor])
        
        
        ratingTitleEditor.contentView.currentRate = uploadData?.rating ?? 0
        commentTitleEditor.contentView.text = uploadData?.comment ?? ""
        drinkPriceEditor.contentView.text = uploadData?.drinkPrice != nil ? "\((uploadData?.drinkPrice)!)" : ""
        foodPriceEditor.contentView.text = uploadData?.foodPrice != nil ? "\((uploadData?.foodPrice)!)" : ""
        
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
        
        // TODO: Check Data
        uploadData.rating = ratingTitleEditor.contentView.currentRate
        uploadData.comment = commentTitleEditor.contentView.text
        uploadData.drinkPrice = Int(drinkPriceEditor.contentView.text!)
        uploadData.foodPrice = Int(foodPriceEditor.contentView.text!)
        
        
        navigationController?.popViewController(animated: true)
    }
    
}
