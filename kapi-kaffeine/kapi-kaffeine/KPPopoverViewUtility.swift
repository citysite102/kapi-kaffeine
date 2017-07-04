//
//  KPPopoverViewUtility.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/7/4.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import UIKit


extension KPPopoverView {
    
    class func popoverDefaultStyleContent(_ title: String,
                                          _ description: String,
                                          _ buttonTitle: String,
                                          _ confirmAction: ((_ content: KPDefaultPopoverContent) -> Swift.Void)?) {
        
            let content = KPDefaultPopoverContent()
            content.confirmAction = confirmAction
            content.titleLabel.text = title
            content.descriptionLabel.text = description
            content.confirmButton.setTitle(buttonTitle,
                                           for: .normal)
            KPPopoverView.sharedPopoverView.contentView = content
            KPPopoverView.sharedPopoverView.popoverContent()
    }
}
