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
    let handler: (_ infoView: KPInformationSharedInfoView) -> ()
}

class KPInformationSharedInfoView: UIView {
    
    var actions: [Action]? {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


