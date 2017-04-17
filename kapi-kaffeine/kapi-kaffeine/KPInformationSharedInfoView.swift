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
    let icon: UIImage
    let handler: (_ infoView: KPInformationSharedInfoView) -> ()
}

class KPInformationSharedInfoView: UIView {
    
    var infoTitleLabel: UILabel!
    var infoContainer: UIView!;
    var buttonContainer: UIView!;
    var actionButtons: [UIButton] = [UIButton]();
    
    var infoView: UIView! {
        didSet {
            if oldValue != nil {
                oldValue.removeFromSuperview();
            }
            self.infoContainer.addSubview(infoView);
            infoView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"]);
        }
    }
    
    var actions: [Action]! {
        didSet {
            
            let totalWidth = (Int(UIScreen.main.bounds.size.width)-((actions?.count)!-1)*8 - 16);
            let buttonWidth = Double(totalWidth)/Double((actions?.count)!);
            
            self.actionButtons.removeAll();
            
            for (index, action) in (actions?.enumerated())! {
                let actionButton = UIButton.init(type: .custom);
                actionButton.setTitle(action.title, for: .normal);
                actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0);
                actionButton.setBackgroundImage(UIImage.init(color: action.color),
                                                for: .normal);
                actionButton.setImage(action.icon, for: .normal);
                actionButton.layer.cornerRadius = 2.0;
                actionButton.layer.masksToBounds = true;
                actionButton.tag = index;
                actionButton.tintColor = UIColor.white;
                self.actionButtons.append(actionButton);
                self.buttonContainer.addSubview(actionButton);
                
                if index == 0 {
                    actionButton.addConstraints(fromStringArray: ["V:|-8-[$self(36)]-8-|",
                                                                  "H:|-8-[$self($metric0)]"],
                                                metrics: [buttonWidth]);
                } else if index == actions.count-1 {
                    actionButton.addConstraints(fromStringArray: ["V:|-8-[$self(36)]-8-|",
                                                                  "H:[$self($metric0)]-8-|"],
                                                metrics: [buttonWidth]);
                } else {
                    actionButton.addConstraints(fromStringArray: ["V:|-8-[$self(36)]-8-|",
                                                                  "H:[$view0]-8-[$self($metric0)]"],
                                                metrics: [buttonWidth],
                                                views: [self.actionButtons[index-1]]);
                }

            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.layer.shadowColor = UIColor.black.cgColor;
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowRadius = 2.0;
        self.layer.shadowOffset = CGSize.init(width: 0.0, height: 2.0);
        
        self.infoTitleLabel = UILabel.init();
        self.infoTitleLabel.font = UIFont.systemFont(ofSize: 13);
        self.infoTitleLabel.textColor = KPColorPalette.KPTextColor.mainColor;
        self.infoTitleLabel.text = "店家資訊";
        self.addSubview(self.infoTitleLabel);
        self.infoTitleLabel.addConstraints(fromStringArray: ["V:|-8-[$self]",
                                                             "H:|-8-[$self]"]);
        
        self.infoContainer = UIView.init();
        self.infoContainer.backgroundColor = UIColor.white;
        self.addSubview(self.infoContainer);
        self.infoContainer.addConstraints(fromStringArray: ["V:[$view0]-8-[$self]",
                                                            "H:|[$self]|"],
                                          views: [self.infoTitleLabel]);
        
        self.buttonContainer = UIView.init();
        self.buttonContainer.backgroundColor = UIColor.white;
        self.addSubview(self.buttonContainer);
        self.buttonContainer.addConstraints(fromStringArray: ["V:[$view0][$self]|",
                                                              "H:|[$self]|"],
                                            views: [self.infoContainer]);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


