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
    var separator: UIView!
    var showEmptyContent: Bool = true {
        didSet {
            DispatchQueue.main.async {
                if !self.showEmptyContent {
                    self.infoTitleLabel.removeAllRelatedConstraintsInSuperView()
                    self.infoSupplementLabel.removeAllRelatedConstraintsInSuperView()
                    self.infoContainer.removeAllRelatedConstraintsInSuperView()
                    self.infoContainer.addConstraints(fromStringArray: ["V:|[$self(0)]|",
                                                                        "H:|[$self]|"])
                    self.emptyLabel.isHidden = true
                } else {
                    self.infoTitleLabel.removeAllRelatedConstraintsInSuperView()
                    self.infoSupplementLabel.removeAllRelatedConstraintsInSuperView()
                    self.infoContainer.removeAllRelatedConstraintsInSuperView()
                    
                    self.infoTitleLabel.addConstraints(fromStringArray: ["V:|-($metric0)-[$self]",
                                                                         "H:|-($metric0)-[$self]"],
                                                  metrics:[KPLayoutConstant.information_horizontal_offset])
                    self.infoSupplementLabel.addConstraints(fromStringArray: ["H:[$self]-($metric0)-|"],
                                                            metrics:[KPLayoutConstant.information_horizontal_offset])
                    self.infoSupplementLabel.addConstraintForCenterAligning(to: self.infoTitleLabel,
                                                                            in: .vertical)
                    self.infoContainer.addConstraints(fromStringArray: ["V:[$view0]-24-[$self(>=64)]|",
                                                                        "H:|[$self]|"],
                                                      views: [self.infoTitleLabel])
                    
                }
            }
        }
    }
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
            infoView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                      "V:|[$self]|"])
        }
    }
    
    var actions: [Action]! {
        didSet {
            
            let totalWidth = (Int(UIScreen.main.bounds.size.width)-((actions?.count)!-1)*12 - 2*KPLayoutConstant.information_horizontal_offset)
            let buttonWidth = Double(totalWidth)/Double((actions?.count)!)
            
            for actionButton in actionButtons {
                actionButton.removeFromSuperview()
            }
            
            actionButtons.removeAll()
            
//            let separator = UIView()
//            separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
//            buttonContainer.addSubview(separator)
//            separator.addConstraints(fromStringArray: ["H:|[$self]|",
//                                                       "V:|[$self(1)]"])
            
            for (index, action) in (actions?.enumerated())! {
                let actionButton = UIButton(type: .custom)
                actionButton.setTitle(action.title, for: .normal)
                actionButton.titleLabel?.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
//                actionButton.setBackgroundImage(UIImage(color: action.color),
//                                                for: .normal)
//                if action.icon != nil {
//                    actionButton.setImage(action.icon, for: .normal)
//                }
                
                actionButton.layer.borderColor = KPColorPalette.KPMainColor_v2.grayColor_level3?.cgColor
                actionButton.layer.borderWidth = 1.0
                actionButton.layer.cornerRadius = 4.0
                actionButton.layer.masksToBounds = true
                actionButton.tag = index
                actionButton.addTarget(self, action: #selector(handleButtonOnTapped(button:)), for: .touchUpInside)
                actionButton.setTitleColor(KPColorPalette.KPMainColor_v2.grayColor_level3,
                                           for: .normal)
//                actionButton.imageView?.contentMode = .scaleAspectFit
//                actionButton.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 8)
                actionButtons.append(actionButton)
                buttonContainer.addSubview(actionButton)
                
                if index == 0 {
                    actionButton.addConstraints(fromStringArray: ["V:|-8-[$self(40)]-8-|",
                                                                  "H:|-($metric1)-[$self($metric0)]"],
                                                metrics: [buttonWidth,
                                                          KPLayoutConstant.information_horizontal_offset])
                } else if index == actions.count-1 {
                    actionButton.addConstraints(fromStringArray: ["V:|-8-[$self(40)]-8-|",
                                                                  "H:[$self($metric0)]-($metric1)-|"],
                                                metrics: [buttonWidth,
                                                          KPLayoutConstant.information_horizontal_offset])
                } else {
                    actionButton.addConstraints(fromStringArray: ["V:|-8-[$self(40)]-8-|",
                                                                  "H:[$view0]-12-[$self($metric0)]"],
                                                metrics: [buttonWidth],
                                                views: [self.actionButtons[index-1]])
                }

            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        
        infoTitleLabel = UILabel()
        infoTitleLabel.font = UIFont.systemFont(ofSize: KPFontSize.sub_header,
                                                weight: UIFont.Weight.medium)
        infoTitleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_title
        addSubview(infoTitleLabel)
        infoTitleLabel.addConstraints(fromStringArray: ["V:|-($metric0)-[$self]",
                                                        "H:|-($metric0)-[$self]"],
                                      metrics:[KPLayoutConstant.information_horizontal_offset])

        infoSupplementLabel = UILabel()
        infoSupplementLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        infoSupplementLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor_light
        infoSupplementLabel.alpha = 0
        addSubview(infoSupplementLabel)
        infoSupplementLabel.addConstraints(fromStringArray: ["H:[$self]-($metric0)-|"],
                                           metrics:[KPLayoutConstant.information_horizontal_offset])
        infoSupplementLabel.addConstraintForCenterAligning(to: infoTitleLabel,
                                                           in: .vertical)
        
        infoContainer = UIView()
        infoContainer.backgroundColor = UIColor.white
        addSubview(infoContainer)
        infoContainer.addConstraints(fromStringArray: ["V:[$view0]-30-[$self(>=64)]",
                                                       "H:|[$self]|"],
                                     views: [infoTitleLabel])
    
        emptyLabel = UILabel()
        emptyLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent)
        emptyLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_hint
        emptyLabel.text = "目前尚無內容喔！"
        emptyLabel.isHidden = true
        infoContainer.addSubview(emptyLabel)
        emptyLabel.addConstraintForCenterAligningToSuperview(in: .vertical,
                                                             constant: -12)
        emptyLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        buttonContainer = UIView()
        buttonContainer.backgroundColor = UIColor.white
        addSubview(self.buttonContainer)
        buttonContainer.addConstraints(fromStringArray: ["V:[$view0][$self]-24-|",
                                                         "H:|[$self]|"],
                                       views: [infoContainer])
        
        separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level7
        addSubview(separator)
        separator.addConstraints(fromStringArray: ["H:|-($metric0)-[$self]-($metric0)-|",
                                                   "V:[$self(1)]|"],
                                 metrics:[KPLayoutConstant.information_horizontal_offset])
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func handleButtonOnTapped(button: UIButton) {
        actions[button.tag].handler(self)
    }

}


