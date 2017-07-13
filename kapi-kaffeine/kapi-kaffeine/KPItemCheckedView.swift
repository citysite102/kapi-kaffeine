//
//  KPItemCheckedView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/18.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPItemCheckedView: UIView {

    enum BorderType {
        case Top
        case Bottom
        case Both
        case None
    }
    
    private var bType: BorderType!
    var uncheckContent: String!
    var checkContent: String!
    var checkedIconView: KPCheckBox!
    var checked: Bool = false {
        didSet {
            stateLabel.text = checked ? checkContent : uncheckContent
            stateLabel.textColor = checked ?
                KPColorPalette.KPTextColor.grayColor_level2 :
                KPColorPalette.KPTextColor.grayColor_level4
        }
    }
    
    var customInputAction: (() -> Void)?
    var tapGesture: UITapGestureRecognizer!
    
    lazy var itemLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = KPColorPalette.KPTextColor.mainColor
        return label
    }()
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = KPColorPalette.KPTextColor.grayColor_level4
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ title: String,
                     _ uncheckTitle: String,
                     _ checkTitle: String,
                     _ borderType: BorderType) {
        
        self.init(frame: .zero)
        
        uncheckContent = uncheckTitle
        checkContent = checkTitle
        
        itemLabel.text = title
        stateLabel.text = uncheckTitle
        bType = borderType
        
        addSubview(itemLabel)
        addSubview(stateLabel)
        
        itemLabel.addConstraints(fromStringArray: ["H:|-16-[$self]"])
        itemLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        stateLabel.addConstraints(fromStringArray: ["H:[$self]-16-|"])
        stateLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        makeBorder()
        
        tapGesture = UITapGestureRecognizer(target: self,
                                            action: #selector(handleTapGesture(tapGesture:)))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    func makeBorder() {
        let topBorderView = UIView()
        let bottomBorderView = UIView()
        
        topBorderView.backgroundColor = KPColorPalette.KPMainColor.grayColor_level6
        bottomBorderView.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        
        switch bType! {
        case .Bottom:
            addSubview(bottomBorderView)
            bottomBorderView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:[$self(1)]|"])
        case .Top:
            addSubview(topBorderView)
            topBorderView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                           "V:|[$self(1)]"])
        case .Both:
            addSubview(topBorderView)
            topBorderView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                           "V:|[$self(1)]"])
            addSubview(bottomBorderView)
            bottomBorderView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                              "V:[$self(1)]|"])
        default:
            print("No border")
        }
    }
    
    func handleTapGesture(tapGesture: UITapGestureRecognizer) {
        customInputAction?()
    }
}
