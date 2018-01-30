//
//  KPTabView.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 14/06/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

protocol KPTabViewDelegate {
    func tabView(_: KPTabView, didSelectIndex index: Int)
}

class KPTabView: UIView {
    
    var delegate: KPTabViewDelegate?
    
    lazy var hintView: UIView = {
        let view = UIView()
        view.backgroundColor = KPColorPalette.KPMainColor_v2.textColor_level2
        return view
    }()
    
    var currentIndex: Int = 0 {
        didSet {
            if oldValue != currentIndex {
                for subview in self.subviews {
                    if let button = subview as? UIButton {
                        button.isSelected = false
                    }
                }
                
                if hintView.superview != nil {
                    hintView.removeFromSuperview()
                }
                
                self.addSubview(hintView)
                hintView.addConstraintForHavingSameWidth(with: tabs[currentIndex])
                self.addConstraint(NSLayoutConstraint(item: tabs[currentIndex], attribute: .leading, relatedBy: .equal, toItem: hintView, attribute: .leading, multiplier: 1, constant: 0))
                hintView.addConstraint(from: "V:[$self(2)]|")
                
                UIView.animate(withDuration: 0.25) {
                    self.layoutIfNeeded()
                    self.tabs[self.currentIndex].isSelected = true
                }
            }
        }
    }
    
    var font: UIFont = UIFont.boldSystemFont(ofSize: 13) {
        didSet {
            for button in tabs {
                button.titleLabel?.font = font
            }
        }
    }
    
    var tabs: [UIButton] = []
    
    convenience init(titles: [String]) {
        self.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.white
        
        var preButton: UIButton? = nil
        for title in titles {
            let button = UIButton(type: .custom)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_description,
                                 for: .normal)
            button.setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_title, for: .selected)
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(handleButtonOnTap(sender:)), for: .touchUpInside)
            tabs.append(button)
            self.addSubview(button)
            if preButton == nil {
                button.addConstraints(fromStringArray: ["H:|[$self]",
                                                        "V:|[$self]|"])
                button.isSelected = true
                self.addSubview(hintView)
                hintView.addConstraintForHavingSameWidth(with: button)
                self.addConstraint(NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: hintView, attribute: .leading, multiplier: 1, constant: 0))
                hintView.addConstraint(from: "V:[$self(2)]|")
            } else {
                button.addConstraints(fromStringArray: ["H:[$view0][$self]",
                                                        "V:|[$self]|"], views: [preButton!])
                button.addConstraintForHavingSameWidth(with: preButton)
            }
            preButton = button
        }
        preButton!.addConstraint(from: "H:[$self]|")
        
        
        self.layer.masksToBounds = false;
        self.layer.shadowOffset = CGSize(width: 1, height: 1);
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 0.2;
        
    }
    
    @objc func handleButtonOnTap(sender: UIButton) {
        
        if sender.isSelected {
            return
        }
                
        if let selectedIndex = tabs.index(of: sender) {
            currentIndex = selectedIndex
            delegate?.tabView(self, didSelectIndex: currentIndex)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
