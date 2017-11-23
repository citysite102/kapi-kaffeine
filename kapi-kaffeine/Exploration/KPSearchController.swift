//
//  KPSearchController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 29/11/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSearchController: UIViewController, UITextFieldDelegate {
    
    var searchBar: UIView!
    var searchIconView: UIImageView!
    var searchTextField: UITextField!
    var cancelButton: UIButton!
    
    var containerView: UIView!
    
    
    var searchBarTopConstraint: NSLayoutConstraint!
    
    
    var isShowSearchView: Bool = false {
        didSet {
            if oldValue == isShowSearchView {
                return
            }
            
            if isShowSearchView {
                cancelButton.isHidden = false
//                searchBar.removeAllRelatedConstraintsInSuperView()
//                searchBar.addConstraints(fromStringArray: ["H:|[$self]|", "V:|-20-[$self(50)]"])
                searchBarTopConstraint.constant = 20
                
//                containerView.removeAllRelatedConstraintsInSuperView()
//                containerView.addConstraints(fromStringArray: ["H:|[$self]|"])
//                containerView.addConstraintForHavingSameHeight(with: view)
//                view.addConstraint(NSLayoutConstraint(item: containerView,
//                                                      attribute: NSLayoutAttribute.top,
//                                                      relatedBy: NSLayoutRelation.equal,
//                                                      toItem: view,
//                                                      attribute: NSLayoutAttribute.bottom,
//                                                      multiplier: 1.0,
//                                                      constant: 0.0))
                
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            } else {
                cancelButton.isHidden = true
//                searchBar.removeAllRelatedConstraintsInSuperView()
//                searchBar.addConstraints(fromStringArray: ["H:|-20-[$self]-20-|", "V:|-40-[$self(50)]"])
                searchBarTopConstraint.constant = 40
                
//                containerView.removeAllRelatedConstraintsInSuperView()
//                containerView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
                
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
            
        }
    }
    
//    var containerViewTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Setup search bar
        
        searchBar = UIView()
        searchBar.layer.zPosition = .greatestFiniteMagnitude
        searchBar.backgroundColor = UIColor.white
        view.addSubview(searchBar)
        
        searchBar.layer.shadowColor = UIColor.lightGray.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 1, height: 3)
        searchBar.layer.shadowOpacity = 0.5
        searchBar.layer.shadowRadius = 3
        
        searchBarTopConstraint = searchBar.addConstraint(from: "V:|-40-[$self(50)]").first as! NSLayoutConstraint
        searchBar.addConstraint(from: "H:|-20-[$self]-20-|")
        
        searchIconView = UIImageView(image: R.image.icon_search())
        searchIconView.contentMode = .scaleAspectFit
        searchIconView.tintColor = UIColor.lightGray
        searchBar.addSubview(searchIconView)
        searchIconView.addConstraints(fromStringArray: ["H:|-[$self]", "V:|-[$self]-|"])
        
        cancelButton = UIButton(type: .custom)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        cancelButton.setTitle("cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.red, for: .normal)
        searchBar.addSubview(cancelButton)
        cancelButton.addConstraints(fromStringArray: ["H:[$self]-|", "V:|[$self]|"])
        cancelButton.addTarget(self, action: #selector(handleCancelButtonOnTap(sender:)), for: .touchUpInside)
        cancelButton.isHidden = true
        
        searchTextField = UITextField()
        searchTextField.delegate = self
        searchBar.addSubview(searchTextField)
        searchTextField.addConstraints(fromStringArray: ["H:[$view0]-[$self]-[$view1]", "V:|-[$self]-|"],
                                       views: [searchIconView, cancelButton])
        
        containerView = UIView()
        containerView.backgroundColor = UIColor.clear
        view.addSubview(containerView)
        
        searchIconView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        cancelButton.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        
        containerView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSearchBarOnTap(sender:)))
        searchBar.addGestureRecognizer(tapGesture)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubview(toFront: searchBar)
    }
    
    @objc func handleSearchBarOnTap(sender: UIGestureRecognizer) {
        isShowSearchView = true
    }
    
    @objc func handleCancelButtonOnTap(sender: UIButton) {
        searchTextField.endEditing(true)
//        isShowSearchView = false
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        isShowSearchView = true
//        return true
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.layoutIfNeeded()
        isShowSearchView = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.layoutIfNeeded()
        isShowSearchView = false
    }
    
}
