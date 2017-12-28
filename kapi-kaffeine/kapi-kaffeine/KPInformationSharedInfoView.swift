//
//  KPInformationSharedInfoView.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/4/12.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit


enum ActionStyle: Int {
    case normal = 1
}

struct Action {
    let title: String
    let style: ActionStyle
    let color: UIColor
    let icon: UIImage?
    let handler: (_ infoView: KPInformationSharedInfoView) -> ()
}

class KPInformationSharedInfoView: UIView {
    
    var infoTitleLabel: UILabel!
    var infoSupplementLabel: UILabel!
    var infoContainer: UIView!
    var emptyLabel: UILabel!
    
    var buttonContainer: UIView!
    var actionButtons: [UIButton] = [UIButton]()
    
    var isEmpty: Bool! {
        didSet {
            infoView.isHidden = isEmpty
            emptyLabel.isHidden = !isEmpty
        }
    }
    
    var infoView: UIView! {
        didSet {
            if oldValue != nil {
                oldValue.removeFromSuperview()
            }
            self.infoContainer.addSubview(infoView)
            infoView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        }
    }
    
    var actions: [Action]! {
        didSet {
            
            let totalWidth = (Int(UIScreen.main.bounds.size.width)-((actions?.count)!-1)*8 - 16)
            let buttonWidth = Double(totalWidth)/Double((actions?.count)!)
            
            for actionButton in actionButtons {
                actionButton.removeFromSuperview()
            }
            
            actionButtons.removeAll()
            
            let separator = UIView()
            separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
            buttonContainer.addSubview(separator)
            separator.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self(1)]"])
            
            for (index, action) in (actions?.enumerated())! {
                let actionButton = UIButton(type: .custom)
                actionButton.setTitle(action.title, for: .normal)
                actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
                actionButton.setBackgroundImage(UIImage(color: action.color),
                                                for: .normal)
                
                if action.icon != nil {
                    actionButton.setImage(action.icon, for: .normal)
                }
                actionButton.layer.cornerRadius = 2.0
                actionButton.layer.masksToBounds = true
                actionButton.tag = index
                actionButton.tintColor = UIColor.white
                actionButton.addTarget(self, action: #selector(handleButtonOnTapped(button:)), for: .touchUpInside)
                actionButton.imageView?.contentMode = .scaleAspectFit
                actionButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 8)
                actionButtons.append(actionButton)
                buttonContainer.addSubview(actionButton)
                
                if index == 0 {
                    actionButton.addConstraints(fromStringArray: ["V:|-8-[$self(36)]-8-|",
                                                                  "H:|-8-[$self($metric0)]"],
                                                metrics: [buttonWidth])
                } else if index == actions.count-1 {
                    actionButton.addConstraints(fromStringArray: ["V:|-8-[$self(36)]-8-|",
                                                                  "H:[$self($metric0)]-8-|"],
                                                metrics: [buttonWidth])
                } else {
                    actionButton.addConstraints(fromStringArray: ["V:|-8-[$self(36)]-8-|",
                                                                  "H:[$view0]-8-[$self($metric0)]"],
                                                metrics: [buttonWidth],
                                                views: [self.actionButtons[index-1]])
                }

            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 2.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        infoTitleLabel = UILabel()
        infoTitleLabel.font = UIFont.systemFont(ofSize: 13)
        infoTitleLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3
        addSubview(infoTitleLabel)
        infoTitleLabel.addConstraints(fromStringArray: ["V:|-8-[$self]",
                                                        "H:|-8-[$self]"])
        
        infoSupplementLabel = UILabel()
        infoSupplementLabel.font = UIFont.systemFont(ofSize: 13)
        infoSupplementLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3
        addSubview(infoSupplementLabel)
        infoSupplementLabel.addConstraints(fromStringArray: ["V:|-8-[$self]",
                                                             "H:[$self]-8-|"])
        
        infoContainer = UIView()
        infoContainer.backgroundColor = UIColor.white
        addSubview(infoContainer)
        infoContainer.addConstraints(fromStringArray: ["V:[$view0]-8-[$self(>=64)]",
                                                       "H:|[$self]|"],
                                     views: [infoTitleLabel])
        
        emptyLabel = UILabel()
        emptyLabel.font = UIFont.systemFont(ofSize: 14.0)
        emptyLabel.textColor = KPColorPalette.KPTextColor.grayColor_level3
        emptyLabel.text = "目前尚無內容喔！"
        emptyLabel.isHidden = true
        infoContainer.addSubview(emptyLabel)
        emptyLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        emptyLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        buttonContainer = UIView()
        buttonContainer.backgroundColor = UIColor.white
        addSubview(self.buttonContainer)
        buttonContainer.addConstraints(fromStringArray: ["V:[$view0][$self]|",
                                                         "H:|[$self]|"],
                                       views: [infoContainer])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func handleButtonOnTapped(button: UIButton) {
        actions[button.tag].handler(self)
    }

}


