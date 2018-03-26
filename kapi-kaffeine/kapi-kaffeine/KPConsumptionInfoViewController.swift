//
//  KPConsumptionInfoViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 30/01/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPConsumptionInfoViewController: KPNewStoreBasicController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = nil
        
        
        let submitButton = UIButton(type: .custom)
        submitButton.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor_v2.greenColor!), for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitle("確認新增", for: .normal)
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

        
        let ratingTitleEditor = KPTitleEditorView<KPRatingView>("整體消費體驗")
        scrollContainer.addSubview(ratingTitleEditor)
        ratingTitleEditor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingTitleEditor.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            ratingTitleEditor.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            ratingTitleEditor.topAnchor.constraint(equalTo: scrollContainer.topAnchor, constant: 20)
        ])
        
        
        let commentTitleEditor = KPTitleEditorView<UITextView>("留下評論")
        scrollContainer.addSubview(commentTitleEditor)
        commentTitleEditor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentTitleEditor.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20),
            commentTitleEditor.rightAnchor.constraint(equalTo: scrollContainer.rightAnchor, constant: -20),
            commentTitleEditor.topAnchor.constraint(equalTo: ratingTitleEditor.bottomAnchor, constant: 20),
            commentTitleEditor.contentView.heightAnchor.constraint(equalToConstant: 140)
        ])
        
        
//        let commentTitleLabel = UILabel()
//        commentTitleLabel.text = "留下評論"
//        commentTitleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
//        commentTitleLabel.font = UIFont.systemFont(ofSize: 20,
//                                                   weight: UIFont.Weight.light)
//        scrollContainer.addSubview(commentTitleLabel)
//        commentTitleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:[$view0]-20-[$self]"],
//                                         views: [ratingTitleEditor])
//
//
//        let commentTextView = UITextView()
//        commentTextView.font = UIFont.systemFont(ofSize: 16)
//        scrollContainer.addSubview(commentTextView)
//        commentTextView.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:[$view0]-4-[$self(140)]"],
//                                       views: [commentTitleLabel])
//        commentTextView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
//        commentTextView.layer.cornerRadius = 5
        
        
        let drinkPriceEditor = KPTitleEditorView<UITextField>("飲品價位")
        scrollContainer.addSubview(drinkPriceEditor)
        drinkPriceEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:[$view0]-20-[$self]"],
                                        views: [commentTitleEditor])
        
        let foodPriceEditor = KPTitleEditorView<UITextField>("餐點價位")
        scrollContainer.addSubview(foodPriceEditor)
        foodPriceEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:[$view0]-20-[$self]-20-|"],
                                       views: [drinkPriceEditor])
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleBackButtonOnTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSubmitButtonOnTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}
