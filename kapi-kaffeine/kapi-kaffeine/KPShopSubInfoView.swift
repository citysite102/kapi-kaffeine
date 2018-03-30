//
//  KPShopSubInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2018/2/9.
//  Copyright © 2018年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPShopSubInfoView: UIView {

    
    var titleLabel: UILabel!
    var contentLabel: UILabel!
    var actionButton: UIButton!
    var separator: UIView!
    var emptyContent: Bool!
    var showSeparator: Bool = true {
        didSet {
            separator.isHidden = !showSeparator
        }
    }
    var handler: ((_ subInfoView: KPShopSubInfoView) -> ())?
    
    convenience init(_ title: String,
                     _ content: String,
                     _ buttonTitle: String?,
                     _ emptyContent: Bool,
                     _ handler: ((KPShopSubInfoView) -> Void)?) {
        self.init(frame: .zero)
        self.emptyContent = emptyContent
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        titleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_description
        titleLabel.setText(text: title, lineSpacing: 4)
        addSubview(titleLabel)
        titleLabel.addConstraints(fromStringArray: ["H:|[$self]"])
        titleLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        contentLabel.textColor = emptyContent ?
        KPColorPalette.KPTextColor_v2.mainColor_description:
        KPColorPalette.KPTextColor_v2.mainColor_title
        contentLabel.setText(text: content, lineSpacing: 4)
        contentLabel.textAlignment = .right
        contentLabel.numberOfLines = 0
        addSubview(contentLabel)
        contentLabel.addConstraints(fromStringArray: ["V:|-20-[$self]-20-|",
                                                      "H:[$self(<=240)]|"])
        
        separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        addSubview(separator)
        separator.addConstraints(fromStringArray: ["V:[$self(1)]|",
                                                   "H:|[$self]|"],
                                 metrics:[KPLayoutConstant.information_horizontal_offset])
        
        if let actionHandler = handler, !emptyContent {
            self.handler = actionHandler
            self.contentLabel.textColor = tintColor
            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(handleSelfOnTapped(_:)))
            self.addGestureRecognizer(tapGesture)
        }
        
//        if let buttonContent = buttonTitle {
//
//            contentLabel.addConstraints(fromStringArray: ["V:|[$self]",
//                                                          "H:|[$self]|"],
//                                        views:[titleLabel])
//
//            actionButton = UIButton()
//            actionButton.setTitle(buttonContent,
//                                  for: .normal)
//            actionButton.setTitleColor(KPColorPalette.KPMainColor_v2.mainColor_light,
//                                       for: .normal)
//            actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//            actionButton.layer.cornerRadius = 20
//            actionButton.layer.borderColor = KPColorPalette.KPMainColor_v2.mainColor_light?.cgColor
//            actionButton.layer.borderWidth = 1.0
//            addSubview(actionButton)
//            actionButton.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(40)]",
//                                                          "H:|[$self]|"],
//                                        views: [contentLabel])
//        } else {
//            contentLabel.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]|",
//                                                          "H:|[$self]|"],
//                                        views:[titleLabel])
//        }
        
    }
    
    @objc func handleSelfOnTapped(_ sender: UITapGestureRecognizer) {
        if let actionHandler = handler {
            actionHandler(self)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
