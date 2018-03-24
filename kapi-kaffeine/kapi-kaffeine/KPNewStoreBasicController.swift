//
//  KPNewStoreBasicController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 24/03/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPNewStoreBasicController: KPViewController {

    var scrollContainer: UIView!
    var scrollView: UIScrollView!
    var buttonContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
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
        
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(KPNewStoreController.keyboardShow(_:)),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(KPNewStoreController.keyboardHide(_:)),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardShow(_ notification: Notification) {
        if let keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.size.height, right: 0)
        }
    }
    
    @objc func keyboardHide(_ notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

}
