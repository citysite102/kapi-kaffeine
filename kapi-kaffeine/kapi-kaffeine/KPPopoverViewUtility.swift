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
    
    class func popoverLoginView() {
        
        let content = KPDefaultPopoverContent()
        content.confirmAction = { content in
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: 0,
                                                right: 0);
            let loginController = KPLoginViewController()
            UIApplication.shared.KPTopViewController().present(loginController,
                                                               animated: true,
                                                               completion: nil)
        }
        content.titleLabel.text = "進階功能"
        content.descriptionLabel.text = "哈囉!登入一個帳號來享受更進階的功能吧!"
        content.confirmButton.setTitle("登入",
                                       for: .normal)
        KPPopoverView.sharedPopoverView.contentView = content
        KPPopoverView.sharedPopoverView.popoverContent()
    }
    
    class func popoverVisitedView(_ photos: [String]?,
                                  _ confirmAction: ((_ content: KPVisitedPopoverContent) -> Swift.Void)?) {
        
        let content = KPVisitedPopoverContent()
        content.confirmAction = confirmAction
        KPPopoverView.sharedPopoverView.contentView = content
        KPPopoverView.sharedPopoverView.popoverContent()
    }
    
    class func popoverNotification(_ title: String,
                                   _ description: String,
                                   _ confirmAction: ((_ content: KPNotificationPopoverContent) -> Swift.Void)?) {
        
        let content = KPNotificationPopoverContent()
        content.confirmAction = confirmAction
        content.titleLabel.text = title
        content.descriptionLabel.setText(text: description, lineSpacing: 3.6)
        KPPopoverView.sharedPopoverView.contentView = content
        KPPopoverView.sharedPopoverView.popoverContent()
    }
    
    class func popoverDefaultStyleContent(_ title: String,
                                          _ description: String,
                                          _ buttonTitle: String,
                                          _ confirmAction: ((_ content: KPDefaultPopoverContent) -> Swift.Void)?) {
        
            let content = KPDefaultPopoverContent()
            content.confirmAction = confirmAction
            content.titleLabel.text = title
            content.descriptionLabel.setText(text: description, lineSpacing: 3.6)
            content.confirmButton.setTitle(buttonTitle,
                                           for: .normal)
            KPPopoverView.sharedPopoverView.contentView = content
            KPPopoverView.sharedPopoverView.popoverContent()
    }
}
