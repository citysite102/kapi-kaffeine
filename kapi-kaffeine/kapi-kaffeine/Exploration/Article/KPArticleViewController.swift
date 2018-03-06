//
//  KPArticleViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2018/1/25.
//  Copyright © 2018年 kapi-kaffeine. All rights reserved.
//

import UIKit
import Hero

class KPArticleViewController: KPViewController {

    static let scrollAnimationStartOffset: CGFloat = 0
    static let scrollAnimationEnlargeOffset: CGFloat = 0
    static let scrollAnimationThreshold: CGFloat = 200
    static let scrollCollapseOffset: CGFloat = 100
    static let hoverMinimumHeight: CGFloat = 200
    
    var dismissButton: KPBounceButton!
    var scrollContainer: UIScrollView!
    var imageSource: UIImage?
    var heroCoverImageView: UIImageView!
    var gradientView: UIView!
    var imageMaskLayer: CAGradientLayer!
    weak var explorationViewController: KPExplorationViewController?
    
    var animationHasPerformed: Bool = false
    var viewIsDimissing: Bool = false
    var articleTitleLabel: UILabel!
    var articleSubTitleLabel: UILabel!
    var articleFirstParagraphTextView: UITextView!
    var selectedIndex: NSIndexPath!
    
    var articleContainer: UIView!
    var articleYConstaint: NSLayoutConstraint!
    
    var scrollDownButton: UIButton!
    var lastOffset: CGFloat!
    
    var topBarContainer: UIView!
    var toolBarContainer: UIView!
    var separator_top: UIView!
    var separator: UIView!
    var collectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.layoutIfNeeded()
        hero.isEnabled = true
        
        scrollContainer = UIScrollView()
        scrollContainer.delegate = self
        scrollContainer.decelerationRate = UIScrollViewDecelerationRateFast
        view.addSubview(scrollContainer)
        scrollContainer.addConstraints(fromStringArray: ["V:|[$self]|",
                                                         "H:|[$self]|"])
        
        heroCoverImageView = UIImageView(image: imageSource ?? R.image.demo_6())
        heroCoverImageView.contentMode = .scaleAspectFill
        heroCoverImageView.clipsToBounds = true
        heroCoverImageView.frame = CGRect(x: 0,
                                          y: 0,
                                          width: view.bounds.width,
                                          height: view.bounds.height)
        heroCoverImageView.hero.id = "article-\(selectedIndex.row)"
        scrollContainer.addSubview(heroCoverImageView)
        
        gradientView = UIView()
        heroCoverImageView.addSubview(gradientView)
        gradientView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                      "H:|[$self]|"])
        
        imageMaskLayer = CAGradientLayer()
        imageMaskLayer.opacity = 0.7
        imageMaskLayer.frame = view.bounds
        imageMaskLayer.colors = [UIColor.init(r: 0, g: 0, b: 0, a: 0.7).cgColor,
                                 UIColor.init(r: 0, g: 0, b: 0, a: 0.0).cgColor]
        imageMaskLayer.startPoint = CGPoint(x: 0.5, y: 0.6)
        imageMaskLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientView.layer.addSublayer(imageMaskLayer)

        scrollDownButton = UIButton(type: .roundedRect)
        scrollDownButton.setImage(R.image.icon_scrolldown()!,
                               for: .normal)
        scrollDownButton.alpha = 0.0
        scrollDownButton.transform = CGAffineTransform(translationX: 0,
                                                       y: 60)
        scrollDownButton.tintColor = UIColor.white
        heroCoverImageView.addSubview(scrollDownButton)
        scrollDownButton.addConstraints(fromStringArray: ["V:[$self]-16-|"])
        scrollDownButton.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
        articleFirstParagraphTextView = UITextView()
        articleFirstParagraphTextView.alpha = 0
        articleFirstParagraphTextView.transform = CGAffineTransform(translationX: 0,
                                                           y: 48)
        articleFirstParagraphTextView.font = UIFont.systemFont(ofSize: 16)
        articleFirstParagraphTextView.textColor = UIColor.white
        articleFirstParagraphTextView.backgroundColor = UIColor.clear
        articleFirstParagraphTextView.isScrollEnabled = false
        articleFirstParagraphTextView.setText(text: "歐洲的咖啡店風格總是強烈的讓人移不開目光，即使身處在倫敦這樣的忙碌城市裡，竄入鼻腔內的咖啡香，不經意地就能停住路人的快速步伐。",
                                              lineSpacing: 3.0)
        heroCoverImageView.addSubview(articleFirstParagraphTextView)
        articleFirstParagraphTextView.addConstraints(fromStringArray: ["V:[$self]-64-|",
                                                                       "H:[$self($metric0)]"],
                                                     metrics: [view.bounds.width - 32])
        articleFirstParagraphTextView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        articleSubTitleLabel = UILabel()
        articleSubTitleLabel.alpha = 0
        articleSubTitleLabel.transform = CGAffineTransform(translationX: 0,
                                                           y: 36)
        articleSubTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        articleSubTitleLabel.textColor = KPColorPalette.KPTextColor_v2.yellow_color
        articleSubTitleLabel.setText(text: "這絕對是今年喝過最好喝的咖啡！",
                                     lineSpacing: 3.0)
        articleSubTitleLabel.numberOfLines = 0
        heroCoverImageView.addSubview(articleSubTitleLabel)
        articleSubTitleLabel.addConstraints(fromStringArray: ["V:[$self]-8-[$view0]",
                                                              "H:[$self($metric0)]"],
                                            metrics: [view.bounds.width - 32],
                                            views: [articleFirstParagraphTextView])
        articleSubTitleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        
        articleTitleLabel = UILabel()
        articleTitleLabel.alpha = 0
        articleTitleLabel.transform = CGAffineTransform(translationX: 0,
                                                                    y: 24)
        articleTitleLabel.font = UIFont.boldSystemFont(ofSize: 40)
        articleTitleLabel.textColor = UIColor.white
        articleTitleLabel.numberOfLines = 0
        articleTitleLabel.setText(text: "一窺東倫敦新興咖啡社群 - Hello Hackney",
                                  lineSpacing: 3.0)
        heroCoverImageView.addSubview(articleTitleLabel)
        
        articleTitleLabel.addConstraints(fromStringArray: ["V:[$self]-16-[$view0]",
                                                           "H:[$self($metric0)]"],
                                         metrics: [view.bounds.width - 32],
                                         views: [articleSubTitleLabel])
        articleTitleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        
        articleContainer = UIView()
        articleContainer.alpha = 0
        articleContainer.backgroundColor = UIColor.white
        scrollContainer.addSubview(articleContainer)
        articleContainer.addConstraintForHavingSameWidth(with: view)
        articleContainer.addConstraints(fromStringArray: ["V:[$self(1200)]|",
                                                          "H:|[$self]|"])
        articleYConstaint = articleContainer.addConstraint(from: "V:|-667-[$self]").first as! NSLayoutConstraint
        lastOffset = KPArticleViewController.scrollAnimationStartOffset
        
        topBarContainer = UIView()
        topBarContainer.backgroundColor = UIColor.white
        topBarContainer.alpha = 0
        view.addSubview(topBarContainer)
        topBarContainer.addConstraints(fromStringArray: ["V:|[$self($metric0)]",
                                                          "H:|[$self]|"],
                                       metrics:[KPLayoutConstant.topBar_height])
        separator_top = UIView()
        separator_top.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        topBarContainer.addSubview(separator_top)
        separator_top.addConstraints(fromStringArray: ["H:|[$self]|",
                                                       "V:[$self($metric0)]|"],
                                     metrics:[KPLayoutConstant.separator_height])
        
        dismissButton = KPBounceButton(frame: CGRect.zero,
                                       image: R.image.icon_close()!)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.alpha = 0.0
        view.addSubview(dismissButton)
        dismissButton.addConstraints(fromStringArray: ["V:[$self($metric0)]",
                                                       "H:|-16-[$self($metric0)]"], metrics:[KPLayoutConstant.dismissButton_size])
        dismissButton.addConstraintForCenterAligning(to: topBarContainer,
                                                     in: .vertical,
                                                     constant: 6)
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        dismissButton.addTarget(self,
                                action: #selector(handleDismissButtonOnTapped), for: .touchUpInside)
        
        
        separator = UIView()
        separator.backgroundColor = KPColorPalette.KPBackgroundColor.grayColor_level6
        
        toolBarContainer = UIView()
        toolBarContainer.backgroundColor = UIColor.white
        view.addSubview(toolBarContainer)
        toolBarContainer.addConstraints(fromStringArray: ["V:[$self($metric0)]|",
                                                          "H:|[$self]|"], metrics:[KPLayoutConstant.bottomBar_height])
        toolBarContainer.transform = CGAffineTransform(translationX: 0, y: 64)
        toolBarContainer.addSubview(separator)
        separator.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:|[$self($metric0)]"], metrics:[KPLayoutConstant.separator_height])
        
        collectButton = UIButton(type: .roundedRect)
        collectButton.setTitle("收藏文章", for: .normal)
        collectButton.setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_subtitle, for: .normal)
        collectButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        collectButton.imageEdgeInsets = UIEdgeInsetsMake(2, -2, 2, 2)
        collectButton.setImage(R.image.icon_collect_border()!,
                               for: .normal)
        collectButton.tintColor = KPColorPalette.KPMainColor_v2.redColor
        toolBarContainer.addSubview(collectButton)
        collectButton.addConstraintForCenterAligningToSuperview(in: .vertical)
        collectButton.addConstraint(from: "H:|-16-[$self]")
        
        addSampleContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if explorationViewController != nil {
            explorationViewController?.shouldShowLightContent = true
            setNeedsStatusBarAppearanceUpdate()
        }
        
        if !animationHasPerformed {
            UIView.animate(withDuration: 0.5,
                           delay: 0.2,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: {
                            self.view.backgroundColor = UIColor.white
                            self.articleTitleLabel.alpha = 1.0
                            self.dismissButton.alpha = 1.0
                            self.articleSubTitleLabel.alpha = 1.0
                            self.articleFirstParagraphTextView.alpha = 1.0
                            self.scrollDownButton.alpha = 0.8
                            self.articleTitleLabel.transform = CGAffineTransform.identity
                            self.articleSubTitleLabel.transform = CGAffineTransform.identity
                            self.articleFirstParagraphTextView.transform = CGAffineTransform.identity
                            self.scrollDownButton.transform = CGAffineTransform.identity
                            
            }, completion: { (_) in
                self.animationHasPerformed = true
            })
        }
    }
    
    @objc func handleDismissButtonOnTapped() {
        if explorationViewController != nil {
            explorationViewController?.shouldShowLightContent = true
            setNeedsStatusBarAppearanceUpdate()
        }
        dismiss(animated: true, completion: nil)
//        appModalController()?.dismissControllerWithDefaultDuration()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var sampleArticleTitleLabel: UILabel!
    var sampleArticleSubTitleLabel: UILabel!
    var sampleFirstParagraphTextView: UITextView!
    var sampleQuoteView: KPArticleQuoteView!
    var sampleSecondParagraphTextView: UITextView!
    var sampleImageView: UIImageView!
    var sampleThirdParagraphTextView: UITextView!
    
    func addSampleContent() {
        
        sampleArticleTitleLabel = UILabel()
        sampleArticleTitleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        sampleArticleTitleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_title
        sampleArticleTitleLabel.numberOfLines = 0
        sampleArticleTitleLabel.setText(text: "一窺東倫敦新興咖啡社群 - Hello Hackney",
                                        lineSpacing: 3.6)
        articleContainer.addSubview(sampleArticleTitleLabel)
        sampleArticleTitleLabel.addConstraints(fromStringArray: ["V:|-24-[$self]",
                                                                 "H:|-16-[$self]-16-|"])
        
        sampleArticleSubTitleLabel = UILabel()
        sampleArticleSubTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        sampleArticleSubTitleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_title
        sampleArticleSubTitleLabel.setText(text: "這絕對是今年喝過最好喝的咖啡！",
                                     lineSpacing: 3.6)
        sampleArticleSubTitleLabel.numberOfLines = 0
        articleContainer.addSubview(sampleArticleSubTitleLabel)
        sampleArticleSubTitleLabel.addConstraints(fromStringArray: ["V:[$view0]-24-[$self]",
                                                              "H:|-16-[$self]-16-|"],
                                            views: [sampleArticleTitleLabel])
        
        sampleFirstParagraphTextView = UITextView()
        sampleFirstParagraphTextView.font = UIFont.systemFont(ofSize: 16)
        sampleFirstParagraphTextView.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        sampleFirstParagraphTextView.backgroundColor = UIColor.clear
        sampleFirstParagraphTextView.isScrollEnabled = false
        sampleFirstParagraphTextView.setText(text: "歐洲的咖啡店風格總是強烈的讓人移不開目光，即使身處在倫敦這樣的忙碌城市裡，竄入鼻腔內的咖啡香，不經意地就能停住路人的快速步伐。",
                                              lineSpacing: 4.0)
        articleContainer.addSubview(sampleFirstParagraphTextView)
        sampleFirstParagraphTextView.addConstraints(fromStringArray: ["V:[$view0]-16-[$self]",
                                                                      "H:|-16-[$self]-16-|"],
                                                    views: [sampleArticleSubTitleLabel])
        
        sampleQuoteView = KPArticleQuoteView()
        sampleQuoteView.quoteContent = "倫敦處處是咖啡廳，這句話真是一點都不過份。"
        articleContainer.addSubview(sampleQuoteView)
        sampleQuoteView.addConstraints(fromStringArray: ["V:[$view0]-16-[$self]",
                                                          "H:|-20-[$self]-20-|"],
                                        views: [sampleFirstParagraphTextView])
        
        sampleSecondParagraphTextView = UITextView()
        sampleSecondParagraphTextView.font = UIFont.systemFont(ofSize: 16)
        sampleSecondParagraphTextView.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        sampleSecondParagraphTextView.backgroundColor = UIColor.clear
        sampleSecondParagraphTextView.isScrollEnabled = false
        sampleSecondParagraphTextView.setText(text: "Kapi想介紹你一個沒有攝政街喧鬧、沒有牛津街擁擠的咖啡社群。讓你隨著找尋好咖啡的路途，愜意探索倫敦當地社區。",
                                             lineSpacing: 4.0)
        articleContainer.addSubview(sampleSecondParagraphTextView)
        sampleSecondParagraphTextView.addConstraints(fromStringArray: ["V:[$view0]-16-[$self]",
                                                                      "H:|-16-[$self]-16-|"],
                                                    views: [sampleQuoteView])
        
        sampleImageView = UIImageView(image: R.image.demo_3())
        sampleImageView.contentMode = .scaleAspectFill
        sampleImageView.clipsToBounds = true
        articleContainer.addSubview(sampleImageView)
        sampleImageView.addConstraints(fromStringArray: ["V:[$view0]-16-[$self(<=300)]",
                                                                       "H:|-16-[$self]-16-|"],
                                                     views: [sampleSecondParagraphTextView])
        
        sampleThirdParagraphTextView = UITextView()
        sampleThirdParagraphTextView.font = UIFont.systemFont(ofSize: 16)
        sampleThirdParagraphTextView.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        sampleThirdParagraphTextView.backgroundColor = UIColor.clear
        sampleThirdParagraphTextView.isScrollEnabled = false
        sampleThirdParagraphTextView.setText(text: "Hackney是倫敦近期發展重點行政區之一，它有著倫敦東區的藝術氣息，聚集了想要翻舊創新的年輕人，在這老老的社區裡，用他們對生活的美學，創造大大的新改變。",
                                              lineSpacing: 4.0)
        articleContainer.addSubview(sampleThirdParagraphTextView)
        sampleThirdParagraphTextView.addConstraints(fromStringArray: ["V:[$view0]-16-[$self]",
                                                                       "H:|-16-[$self]-16-|"],
                                                     views: [sampleImageView])
        
    }
}

extension KPArticleViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y <= KPArticleViewController.scrollAnimationThreshold) {
            autoScaleHeroImage(offsetY: scrollView.contentOffset.y)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        if (scrollView.contentOffset.y <= KPArticleViewController.scrollAnimationThreshold) {
            autoScaleHeroImage(offsetY: scrollView.contentOffset.y)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("Will End Offset:\(scrollView.contentOffset.y)")
        if (targetContentOffset.pointee.y <= KPArticleViewController.scrollAnimationThreshold) {
            checkDismissBehavior(scrollView.contentOffset.y)
            autoScaleHeroImage(offsetY: targetContentOffset.pointee.y)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("Scroll Offset:\(scrollView.contentOffset.y)")
        
        // 處理 Tool Bar
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.toolBarContainer.transform = scrollView.contentOffset.y > 100 ? CGAffineTransform.identity : CGAffineTransform(translationX: 0, y: 64)
                        self.scrollDownButton.alpha = (scrollView.contentOffset.y < 10) ? 0.8 : 0
        }, completion: { (_) in
            
        })
        
        // 處理上半部分 Hero Image 的狀態
        if (scrollView.contentOffset.y <= KPArticleViewController.scrollAnimationThreshold &&
            scrollView.contentOffset.y >= KPArticleViewController.scrollAnimationEnlargeOffset) {
            
            if explorationViewController != nil {
                explorationViewController?.shouldShowLightContent = true
                UIView.animate(withDuration: 0.5,
                               animations: {
                                self.setNeedsStatusBarAppearanceUpdate()
                })
            }
            
            
            let moveOffsetY = scrollView.contentOffset.y >= 0 ?
                -scrollView.contentOffset.y * 0.6 : 0
            let moveOffsetY_2 = scrollView.contentOffset.y >= 0 ?
                -scrollView.contentOffset.y * 0.5 : 0
            let moveOffsetY_3 = scrollView.contentOffset.y >= 0 ?
                -scrollView.contentOffset.y * 0.4 : 0
            let opacity = scrollView.contentOffset.y >= 0 ?
                (1-scrollView.contentOffset.y/KPArticleViewController.scrollAnimationThreshold)-0.2 :
            1
        
            let height = easeIn(cTime: scrollView.contentOffset.y-KPArticleViewController.scrollAnimationStartOffset,
                                startValue: view.bounds.height,
                                changeValue: -KPArticleViewController.hoverMinimumHeight,
                                totalTime: KPArticleViewController.scrollAnimationThreshold-KPArticleViewController.scrollAnimationStartOffset)
            
            self.heroCoverImageView.frame = CGRect(x: 0,
                                                   y: 0,
                                                   width: view.bounds.width,
                                                   height: height)
            self.articleYConstaint.constant = height
            
            self.articleTitleLabel.transform = CGAffineTransform(translationX: 0,
                                                            y: moveOffsetY)
            self.articleTitleLabel.alpha = opacity
            self.articleSubTitleLabel.transform = CGAffineTransform(translationX: 0,
                                                               y: moveOffsetY_2)
            self.articleSubTitleLabel.alpha = opacity
            self.articleFirstParagraphTextView.transform = CGAffineTransform(translationX: 0,
                                                                        y: moveOffsetY_3)
            self.articleFirstParagraphTextView.alpha = opacity
            self.articleContainer.layoutIfNeeded()
            self.gradientView.alpha = opacity
            self.articleContainer.alpha = opacity < 0.3 ? 1 - opacity/0.3 : 0
            lastOffset = scrollView.contentOffset.y
        } else {
            
            if self.scrollContainer.contentOffset.y < KPArticleViewController.scrollAnimationEnlargeOffset {
                if !viewIsDimissing {
                    scrollView.setContentOffset(CGPoint(x: 0, y: 0),
                                                animated: false)
                    hero.dismissViewController()
//                    self.dismiss(animated: true, completion: nil)
                    viewIsDimissing = true
//                    self.appModalController()?.view.backgroundColor = UIColor.clear
//                    view.backgroundColor = UIColor.clear
//                    scrollContainer.backgroundColor = UIColor.clear
//                    viewIsDimissing = true
//                    UIView.animate(withDuration: 0.3,
//                                   delay: 0,
//                                   options: .curveEaseIn,
//                                   animations: {
//                                    self.view.transform = CGAffineTransform(translationX: 0,
//                                                                            y: self.view.bounds.height)
//                    }, completion: { (_) in
//                        self.dismiss(animated: true, completion: nil)
////                        self.appModalController()?.dismissController(duration: 0)
//                    })
                } else {
                    if (self.scrollContainer.contentOffset.y > -150) {
                        Hero.shared.update((self.scrollContainer.contentOffset.y +
                            KPArticleViewController.scrollAnimationEnlargeOffset)/(-150))
                    } else {
                        Hero.shared.finish()
                    }
                }
                
            } else {
                
                if (viewIsDimissing) {
                    return
                }
                
                if explorationViewController != nil {
                    explorationViewController?.shouldShowLightContent = true
                }
                
                if self.scrollContainer.contentOffset.y >= 380 {
                    topBarContainer.alpha = (self.scrollContainer.contentOffset.y - 380) / 40
                    dismissButton.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
                    if explorationViewController != nil {
                        explorationViewController?.shouldShowLightContent = false
                    }
                    
                } else if self.scrollContainer.contentOffset.y <= 0 {
//                    && self.scrollContainer.contentOffset.y > -50 {
                
//                    let updatedFrame = CGRect(x: self.scrollContainer.contentOffset.y,
//                                              y: self.scrollContainer.contentOffset.y,
//                                              width: view.bounds.width - 2*(self.scrollContainer.contentOffset.y),
//                                              height: view.bounds.height - self.scrollContainer.contentOffset.y)
//                    heroCoverImageView.frame = updatedFrame
//                    imageMaskLayer.frame = CGRect(x: 0, y: 0,
//                                                  width: updatedFrame.width*2,
//                                                  height: updatedFrame.height)
                } else {
                    topBarContainer.alpha = 0
                    dismissButton.tintColor = UIColor.white
                }
                
                UIView.animate(withDuration: 0.5,
                               animations: {
                                self.setNeedsStatusBarAppearanceUpdate()
                })
            }
        }
    }
    
    func checkDismissBehavior(_ offSetY: CGFloat) {
        if viewIsDimissing {
            if offSetY >= -85 &&
                offSetY < KPArticleViewController.scrollAnimationStartOffset {
                    Hero.shared.cancel()
                    viewIsDimissing = false
            } else {
                Hero.shared.finish()
            }
        }
    }
    
    func autoScaleHeroImage(offsetY: CGFloat) {
        let shouldCollapse = (offsetY >= 60)
        let moveOffsetY: CGFloat = shouldCollapse ?
            -KPArticleViewController.scrollAnimationThreshold * 0.6 :
        0
        let moveOffsetY_2: CGFloat = shouldCollapse ? -KPArticleViewController.scrollAnimationThreshold * 0.5 :
        0
        let moveOffsetY_3: CGFloat = shouldCollapse ?
            -KPArticleViewController.scrollAnimationThreshold * 0.4 :
        0
        
        let opacity: CGFloat = shouldCollapse ? 0.0 : 1.0
        let height = self.view.bounds.size.height - (shouldCollapse ? KPArticleViewController.hoverMinimumHeight : 0)
        let movingDistance = fabs(self.articleYConstaint.constant - height)
        self.articleYConstaint.constant = height
        
        UIView.animate(withDuration: movingDistance > 100 ? 0.35 : 0.2,
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
                        self.scrollContainer.setContentOffset(CGPoint(x: 0, y: shouldCollapse ?
                            KPArticleViewController.scrollAnimationThreshold :
                            KPArticleViewController.scrollAnimationStartOffset),
                                                    animated: false)
                        self.lastOffset = shouldCollapse ?
                            KPArticleViewController.scrollAnimationThreshold :
                            KPArticleViewController.scrollAnimationStartOffset
                        self.articleTitleLabel.transform = CGAffineTransform(translationX: 0,
                                                                             y: moveOffsetY)
                        self.articleTitleLabel.alpha = opacity
                        self.articleSubTitleLabel.transform = CGAffineTransform(translationX: 0,
                                                                                y: moveOffsetY_2)
                        self.articleSubTitleLabel.alpha = opacity
                        self.articleFirstParagraphTextView.transform = CGAffineTransform(translationX: 0,
                                                                                         y: moveOffsetY_3)
                        self.articleFirstParagraphTextView.alpha = opacity
                        self.gradientView.alpha = opacity
                        self.articleContainer.alpha = opacity < 0.3 ? 1 - opacity/0.3 : 0
                        self.heroCoverImageView.frame = CGRect(x: 0,
                                                               y: KPArticleViewController.scrollAnimationStartOffset,
                                                               width: self.view.bounds.size.width,
                                                               height: height)
                        
                        self.scrollContainer.layoutIfNeeded()
        }, completion: { (_) in
            
        })
    }
    
    func easeIn(cTime: CGFloat,
                startValue: CGFloat,
                changeValue: CGFloat,
                totalTime: CGFloat) -> CGFloat {
        let factor = cTime / totalTime
        return changeValue * factor * factor + startValue
    }
    
}
