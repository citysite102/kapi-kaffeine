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
            KPUserManager.sharedManager.logIn(UIApplication.shared.topViewController)
            content.popoverView.dismiss()
        }
        content.titleLabel.text = "進階功能"
        content.descriptionLabel.text = "哈囉！加入找咖啡來享受更進階的功能吧!"
        content.confirmButton.setTitle("登入",
                                       for: .normal)
        KPPopoverView.sharedPopoverView.contentView = content
        KPPopoverView.sharedPopoverView.popoverContent()
    }
    
    class func popoverArticleEndView() {
        let content = KPDefaultPopoverContent()
        content.titleLabel.text = "沒有文章囉！"
        content.descriptionLabel.setText(text: "啊啊啊啊啊，還想要閱讀更多優質的文章嗎？到我們的Facebook粉絲團看看吧！",
                                         lineSpacing: 3.6)
        content.confirmButton.setTitle("前往粉絲團", for: .normal)
        content.confirmAction = { content in
            
            guard let url = URL(string: "https://www.facebook.com/KAPI.tw/?ref=br_rs") else {
                return
            }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }

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
        content.descriptionLabel.setText(text: "感謝您的貢獻，為了確保資料的正確性，請靜待管理團隊的照片審核(⊙‿⊙)！（約3-4天）",
                                         lineSpacing: 3.6)
        content.confirmButton.setTitle("沒有問題", for: .normal)
        KPPopoverView.sharedPopoverView.contentView = content
        KPPopoverView.sharedPopoverView.popoverContent()
    }
    
    class func popoverStoreInReviewNotification() {
        let content = KPNotificationPopoverContent()
        content.titleLabel.text = "審核中"
        content.descriptionLabel.setText(text: "感謝您的貢獻，為了確保資料的正確性，請靜待管理團隊的店家審核(⊙‿⊙)！（約3-4天）",
                                         lineSpacing: 3.6)
        content.confirmButton.setTitle("沒有問題", for: .normal)
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
