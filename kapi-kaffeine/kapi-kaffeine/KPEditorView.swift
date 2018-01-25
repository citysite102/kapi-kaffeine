//
//  KPEditorView.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 18/12/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPEditorView: UIView {
    
    fileprivate var editorType: EditorType
    
    enum EditorType {
        case Text
        case Search
        case Custom
    }
    
    init(type: EditorType,
         title: String,
         placeHolder: String) {
        editorType = type
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.text = title
        titleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["H:|[$self]",
                                                    "V:|[$self]"])
        
        
        let textField = UITextField()
        textField.placeholder = placeHolder
        textField.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        textField.layer.cornerRadius = 5
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.delegate = self
        addSubview(textField)
        textField.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:[$view0(24)]-8-[$self(32)]|"],
                                 views:[titleLabel])
        
        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension KPEditorView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if editorType == .Text {
            return true
        } else if editorType == .Search {
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
            controller.contentController = KPSubtitleInputController()
            controller.presentModalView()
            return false
        } else {
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
            
            let subTitleInputViewController = KPSubtitleInputController()
//            controller.contentController = subTitleInputViewController
            let navigationController = UINavigationController(rootViewController: subTitleInputViewController)
            controller.contentController = navigationController
            controller.presentModalView()
            return false
        }
    }
}
