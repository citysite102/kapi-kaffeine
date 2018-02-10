//
//  KPConsumptionInfoViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 30/01/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPConsumptionInfoViewController: KPViewController {

    
    var scrollContainer: UIView!
    var scrollView: UIScrollView!
    var buttonContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = nil
        
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = KPColorPalette.KPMainColor_v2.whiteColor_level1
        view.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        scrollView.addConstraint(from: "H:|[$self]|")
        
        scrollContainer = UIView()
        scrollContainer.backgroundColor = KPColorPalette.KPMainColor_v2.whiteColor_level1
        scrollView.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        scrollContainer.addConstraintForHavingSameWidth(with: view)
        
        buttonContainer = UIView()
        buttonContainer.backgroundColor = KPColorPalette.KPMainColor_v2.whiteColor_level1
        view.addSubview(buttonContainer)
        buttonContainer.layer.borderColor = KPColorPalette.KPBackgroundColor.grayColor_level6?.cgColor
        buttonContainer.layer.borderWidth = 1
        
        buttonContainer.addConstraints(fromStringArray: ["H:|-(-1)-[$self]-(-1)-|", "V:[$view0][$self(60)]"],
                                       views: [scrollView])
        buttonContainer.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        
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
        
        
        let ratingTitleLabel = UILabel()
        ratingTitleLabel.text = "整體消費體驗"
        ratingTitleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        ratingTitleLabel.font = UIFont.systemFont(ofSize: 20,
                                                  weight: UIFont.Weight.light)
        scrollContainer.addSubview(ratingTitleLabel)
        ratingTitleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:|-20-[$self]"])

        
        let ratingView = KPRatingView()
        scrollContainer.addSubview(ratingView)
        ratingView.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:[$view0]-10-[$self]"],
                                  views: [ratingTitleLabel])
        
        let commentTitleLabel = UILabel()
        commentTitleLabel.text = "留下評論"
        commentTitleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        commentTitleLabel.font = UIFont.systemFont(ofSize: 20,
                                                   weight: UIFont.Weight.light)
        scrollContainer.addSubview(commentTitleLabel)
        commentTitleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]", "V:[$view0]-20-[$self]"],
                                         views: [ratingView])
        
        
        let commentTextView = UITextView()
        commentTextView.font = UIFont.systemFont(ofSize: 16)
        scrollContainer.addSubview(commentTextView)
        commentTextView.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:[$view0]-4-[$self(140)]"],
                                       views: [commentTitleLabel])
        commentTextView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        commentTextView.layer.cornerRadius = 5
        
        let drinkPriceEditor = KPEditorView(type: .Text,
                                            title: "飲品價位",
                                            placeHolder: "請選擇")
        scrollContainer.addSubview(drinkPriceEditor)
        drinkPriceEditor.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:[$view0]-20-[$self]"],
                                        views: [commentTextView])
        
        let foodPriceEditor = KPEditorView(type: .Text,
                                           title: "餐點價位",
                                           placeHolder: "請選擇")
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
