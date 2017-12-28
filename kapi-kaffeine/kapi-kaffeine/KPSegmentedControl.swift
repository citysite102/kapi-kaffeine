//
//  KPSegmentedControl.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 25/07/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPSegmentedControl: UIControl {

    
    var titles: [String]!
    var selectionBackgroundColors: [UIColor] = []
    var selectionTitleColors: [UIColor] = []
    
    private var segments: [UIButton] = []
    
    var selectedSegmentIndex: Int! {
        didSet {
            handleSegmentOnTap(segments[selectedSegmentIndex])
        }
        
    }
    
    convenience init(_ titles: [String]) {
        self.init(titles, nil, nil)
    }
    
    init(_ titles: [String], _ selectionBackgroundColors: [UIColor]?,_ selectionTitleColors: [UIColor]?) {
        super.init(frame: .zero)
        self.titles = titles
        
        if selectionBackgroundColors != nil {
            self.selectionBackgroundColors = selectionBackgroundColors!
        }
        
        if selectionTitleColors != nil {
            self.selectionTitleColors = selectionTitleColors!
        }
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        
        backgroundColor = UIColor.clear
        layer.cornerRadius = 3.0
        layer.borderColor = KPColorPalette.KPMainColor.mainColor?.cgColor
        layer.borderWidth = 2
        layer.masksToBounds = true
        
        for (index, title) in self.titles.enumerated() {
            
            let segment = UIButton(type: .custom)
            segment.setTitleColor(KPColorPalette.KPMainColor.mainColor, for: .normal)
            segment.setTitle(title, for: .normal)
            
            segment.addTarget(self, action: #selector(handleSegmentOnTap(_:)), for: .touchUpInside)
            
            if selectionTitleColors.count > index {
                segment.setTitleColor(selectionTitleColors[index], for: .selected)
            } else {
                segment.setTitleColor(KPColorPalette.KPTextColor.whiteColor!, for: .selected)
            }
            
            if selectionBackgroundColors.count > index {
                segment.setBackgroundImage(UIImage(color: selectionBackgroundColors[index]), for: .selected)
            } else {
                segment.setBackgroundImage(UIImage(color: KPColorPalette.KPMainColor.mainColor!), for: .selected)
            }
            
            segment.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            addSubview(segment)
            
            
            if index == 0 {
                segment.addConstraints(fromStringArray: ["H:|[$self]","V:|[$self]|"])
            } else {
                let seporator = UIView()
                addSubview(seporator)
                seporator.backgroundColor = KPColorPalette.KPMainColor.mainColor
                seporator.addConstraints(fromStringArray: ["H:[$view0][$self(2)][$view1]", "V:|[$self]|", "V:|[$view1]|"],
                                         views: [segments.last!, segment])
                segment.addConstraintForHavingSameWidth(with: segments.last!)
            }
            
            segments.append(segment)
            
        }
        
        if segments.count > 0 {
            segments.last!.addConstraint(from: "H:[$self]|")
            selectedSegmentIndex = 0
        }
        
    }
    
    
    
    // MARK: UI Event
    @objc func handleSegmentOnTap(_ sender: UIButton) {
        if sender.isSelected == true {
            return
        }
        
        for segment in segments {
            segment.isSelected = false
        }
        sender.isSelected = true
        selectedSegmentIndex = segments.index(of: sender)
        self.sendActions(for: .valueChanged)
    }

}
