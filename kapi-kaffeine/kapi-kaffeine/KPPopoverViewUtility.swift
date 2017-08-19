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
        content.descriptionLabel.text = "哈囉！加入找咖啡的行列來享受更進階的功能吧!"
        content.confirmButton.setTitle("登入",
                                       for: .normal)
        KPPopoverView.sharedPopoverView.contentView = content
        KPPopoverView.sharedPopoverView.popoverContent()
    }
    
    class func popoverUnsupportedView() {
        let content = KPNotificationPopoverContent()
        content.titleLabel.text = "尚未開放"
        content.descriptionLabel.setText(text: "啊啊啊啊啊，竟然被你發現我們還在趕工的功能了(´・ω・`)，請再給我們一點時間吧！",
                                         lineSpacing: 3.6)
        content.confirmButton.setTitle("沒問題的啦", for: .normal)
        KPPopoverView.sharedPopoverView.contentView = content
        KPPopoverView.sharedPopoverView.popoverContent()
    }

    class func popoverClosedView() {
        let content = KPNotificationPopoverContent()
        content.titleLabel.text = "店家已歇業"
        content.descriptionLabel.setText(text: "感謝您的支持，但是由於該店家已停止營業，因此我們將停止支援收藏評論等進階功能 இдஇ",
                                         lineSpacing: 3.6)
        content.confirmButton.setTitle("我難過", for: .normal)
        KPPopoverView.sharedPopoverView.contentView = content
        KPPopoverView.sharedPopoverView.popoverContent()
    }
    
    class func popoverPhotoInReviewNotification() {
        let content = KPNotificationPopoverContent()
        content.titleLabel.text = "審核中"
        content.descriptionLabel.setText(text: "感謝你偉大的貢獻，你的照片正經過我們仔細的審核中(⊙‿⊙)！（約3-4天）",
                                         lineSpacing: 3.6)
        content.confirmButton.setTitle("感謝你們", for: .normal)
        KPPopoverView.sharedPopoverView.contentView = content
        KPPopoverView.sharedPopoverView.popoverContent()
    }
    
    class func popoverStoreInReviewNotification() {
        
        
//        KPPopoverView.popoverNotification("新增成功",
//                                          "感謝您提交資訊，我們將儘速進行審查:D 這將會需要1-3天的審核時間確認店家的資訊是否無誤，給我好好的等。",
//                                          nil,
//                                          nil)
        let content = KPNotificationPopoverContent()
        content.titleLabel.text = "審核中"
        content.descriptionLabel.setText(text: "感謝你偉大的貢獻，你的照片正經過我們仔細的審核中(⊙‿⊙)！（約3-4天）",
                                         lineSpacing: 3.6)
        content.confirmButton.setTitle("感謝你們", for: .normal)
        KPPopoverView.sharedPopoverView.contentView = content
        KPPopoverView.sharedPopoverView.popoverContent()
    }
    
    class func popoverVisitedView(_ photos: [String]!,
                                  _ confirmAction: ((_ content: KPVisitedPopoverContent) -> Swift.Void)?) {
        
        let content = KPVisitedPopoverContent()
        content.confirmAction = confirmAction
        content.photos = photos!
        KPPopoverView.sharedPopoverView.contentView = content
        KPPopoverView.sharedPopoverView.popoverContent()
    }
    
    class func popoverNotification(_ title: String,
                                   _ description: String,
                                   _ customHeight: CGFloat?,
                                   _ confirmAction: ((_ content: KPNotificationPopoverContent) -> Swift.Void)?) {
        
        let content = KPNotificationPopoverContent()
        content.customHeight = customHeight ?? 200
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
