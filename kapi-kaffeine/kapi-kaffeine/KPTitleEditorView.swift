//
//  KPTitleEditorView.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 24/03/2018.
//  Copyright © 2018 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPTitleEditorView<T: UIView>: UIView, UITextFieldDelegate {
    
    var title: String = ""
    
    var contentView: T!
    
    var isTextFieldEditable: Bool = true
    var textFieldTapAction: (() -> Void)?
    
    var accessoryView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            
            guard let newView = accessoryView else {
                return
            }
            
            addSubview(newView)
            newView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                newView.rightAnchor.constraint(equalTo: rightAnchor),
                newView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor)
            ])
        }
    }
    
    fileprivate let titleLabel: UILabel = UILabel()
    
    init(_ title: String, contentViewSetupFunction setup: (() -> T)?) {
        super.init(frame: CGRect.zero)
        
        self.title = title
        
        if let setupFunc = setup {
            contentView = setupFunc()
        } else {
            contentView = T()
        }
        
        setupUI()
    }
    
    convenience init(_ title: String) {
        self.init(title, contentViewSetupFunction: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    
    func setupUI() {
        
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 20,
                                            weight: UIFont.Weight.regular)
        titleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor)
        ])
        
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        setupForTextField()
        
    }

    func setupForTextField() {
        
        guard let textField = contentView as? UITextField else {
            return
        }
        
        textField.returnKeyType = .done
        textField.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        textField.layer.cornerRadius = 5
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.delegate = self
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        let paddingView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if isTextFieldEditable {
            return true
        } else {
            textFieldTapAction?()
            return false
        }
    }
    
}
