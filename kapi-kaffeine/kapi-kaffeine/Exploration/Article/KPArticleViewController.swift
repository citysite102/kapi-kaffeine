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
    var collectButton: KPBounceButton!
    
    var currentArticleItem: KPArticleItem!
    fileprivate var articleID: String!
    
    init(_ articleID: String) {
        super.init(nibName: nil, bundle: nil)
        self.articleID = articleID
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.articleID = ""
    }
    
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
        scrollContainer.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
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
                                              lineSpacing: 4.0)
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
                                     lineSpacing: 4.0)
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
                                  lineSpacing: 4.0)
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
        articleContainer.addConstraints(fromStringArray: ["V:[$self]|",
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
                                action: #selector(handleDismissButtonOnTapped),
                                for: .touchUpInside)
        
        
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
        
        collectButton = KPBounceButton(type: .custom)
        collectButton.setTitle("收藏文章", for: .normal)
        collectButton.setTitleColor(KPColorPalette.KPTextColor_v2.mainColor_subtitle,
                                    for: .normal)
        collectButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        collectButton.imageEdgeInsets = UIEdgeInsetsMake(2, -2, 2, 2)
        collectButton.setImage(R.image.icon_collect_border()!,
                               for: .normal)
        collectButton.setImage(R.image.icon_collect()!,
                               for: .selected)
        collectButton.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        collectButton.selectedTintColor = KPColorPalette.KPMainColor_v2.redColor
        collectButton.addTarget(self,
                                action: #selector(handleCollectButtonOnTapped(_:)),
                                for: .touchUpInside)
        collectButton.isSelected = (KPUserManager.sharedManager.currentUser?.hasCollected(currentArticleItem.articleID))!
        toolBarContainer.addSubview(collectButton)
        collectButton.addConstraintForCenterAligningToSuperview(in: .vertical)
        collectButton.addConstraint(from: "H:|-16-[$self]")
        
        loadArticleDataWithID(articleID)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if explorationViewController != nil {
            explorationViewController?.shouldShowLightContent = true
            setNeedsStatusBarAppearanceUpdate()
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
    
    @objc func handleCollectButtonOnTapped(_ sender: UIButton) {
        if sender.isSelected {
            KPServiceHandler.sharedHandler.removeCollectedArticle(currentArticleItem)
        } else {
            KPServiceHandler.sharedHandler.addCollectedArticle(currentArticleItem)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadArticleDataWithID(_ articleID: String) {
        KPServiceHandler.sharedHandler.fetchArticleCotent(articleID) { [weak self] (article, error) in
            
            guard let `self` = self else { return }
            
            guard let article = article else {
                if !self.animationHasPerformed {
                    UIView.animate(withDuration: 0.5,
                                   delay: 0.2,
                                   options: UIViewAnimationOptions.curveEaseOut,
                                   animations: {
                                    self.dismissButton.alpha = 1.0
                    }, completion: { (_) in
                        self.animationHasPerformed = true
                    })
                }
                return
            }
            
            self.articleTitleLabel.text = article.title.value
            if article.contents.count > 0 {
                self.articleSubTitleLabel.text = article.contents[0].value
            }
            if article.contents.count > 1 {
                self.articleFirstParagraphTextView.text = article.contents[1].value
            }
            
            if !self.animationHasPerformed {
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
            
            let titleLabel = self.articleLabel(withElement: article.title)

            self.articleContainer.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.leftAnchor.constraint(equalTo: self.articleContainer.leftAnchor, constant: 16),
                titleLabel.rightAnchor.constraint(equalTo: self.articleContainer.rightAnchor, constant: -16),
                titleLabel.topAnchor.constraint(equalTo: self.articleContainer.topAnchor, constant: 24)
            ])
            
            
            var previousView: UIView = titleLabel
            var spacing: CGFloat = 8
            for element in article.contents {
                
                if element.type == .Br {
                    spacing = 32
                    continue
                }
                
                var currentView: UIView?
                
                if element.type == .Image {
                    
                    let imageView = UIImageView()
                    imageView.contentMode = .center
                    if let url = URL(string: element.value) {
                        imageView.af_setImage(withURL: url)
                    }
                    
                    currentView = imageView
                    
                } else if element.type == .Quote {
                    
                    let quoteView = KPArticleQuoteView()
                    quoteView.quoteContent = element.values[0].value
                    
                    if element.bold {
                        quoteView.font = UIFont.boldSystemFont(ofSize: element.fontSize)
                    } else {
                        quoteView.font = UIFont.systemFont(ofSize: element.fontSize)
                    }
                    
                    currentView = quoteView
                    
                } else if element.type == .Cafe {
                    for subContent in element.content {
                        
                        if subContent.type == .Br {
                            spacing = 32
                            continue
                        }
                        
                        var currentSubView: UIView!
                        
                        if subContent.type == .Image {
                            
                            let imageView = UIImageView()
                            imageView.contentMode = .center
                            if let url = URL(string: subContent.value) {
                                imageView.af_setImage(withURL: url)
                            }
                            
                            currentSubView = imageView
                            
                        } else if subContent.type == .Quote {
                            
                            let quoteView = KPArticleQuoteView()
                            quoteView.quoteContent = subContent.values[0].value
                            
                            currentSubView = quoteView
                            
                        } else {
                        
                            let contentLabel = self.articleLabel(withElement: subContent)
                            currentSubView = contentLabel
                        }
                        
                        self.articleContainer.addSubview(currentSubView)
                        currentSubView.translatesAutoresizingMaskIntoConstraints = false
                        NSLayoutConstraint.activate([
                            currentSubView.leftAnchor.constraint(equalTo: self.articleContainer.leftAnchor, constant: 16),
                            currentSubView.rightAnchor.constraint(equalTo: self.articleContainer.rightAnchor, constant: -16),
                            currentSubView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: spacing)
                        ])
                        
                        previousView = currentSubView
                        spacing = 8
                        
                    }
                    
                    if let buttonElement = element.button {
                        
                        let button = UIButton()

                        if element.bold {
                            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonElement.fontSize)
                        } else {
                            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonElement.fontSize)
                        }
                        
                        button.setTitle(buttonElement.value, for: .normal)
                        button.setTitleColor(buttonElement.color, for: .normal)
                        
                        button.layer.borderColor = buttonElement.color.cgColor
                        button.layer.borderWidth = 1
                        
                        currentView = button
                    }
                    
                } else {
                    let contentLabel = self.articleLabel(withElement: element)
                    currentView = contentLabel
                }
                
                
                
                if let currentView = currentView {
                
                    self.articleContainer.addSubview(currentView)
                    currentView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        currentView.leftAnchor.constraint(equalTo: self.articleContainer.leftAnchor, constant: 16),
                        currentView.rightAnchor.constraint(equalTo: self.articleContainer.rightAnchor, constant: -16),
                        currentView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: spacing)
                    ])
                    
                    previousView = currentView
                    spacing = 8
                }
                
            }

            NSLayoutConstraint.activate([
                previousView.bottomAnchor.constraint(equalTo: self.articleContainer.bottomAnchor, constant: -24)
            ])
            
        }
    }
    
    
    func articleLabel(withElement element: KPArticleElement) -> UILabel {
        
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        if element.bold {
            contentLabel.font = UIFont.boldSystemFont(ofSize: element.fontSize)
        } else {
            contentLabel.font = UIFont.systemFont(ofSize: element.fontSize)
        }
        
        if element.type == .MultipleStyleText {
            var string = ""
            for subElement in element.values {
                string = "\(string)\(subElement.value)"
            }
            let attributedString = NSMutableAttributedString(string: string)
            
            var index = 0
            for subElement in element.values {
                let length = subElement.value.count
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                              value: subElement.color ,
                                              range: NSRange.init(location: index, length: length))
                index = index + length
            }
            
            let descriptionStyle = NSMutableParagraphStyle()
            
            descriptionStyle.lineBreakMode = contentLabel.lineBreakMode
            descriptionStyle.alignment = contentLabel.textAlignment
            descriptionStyle.lineSpacing = 8.0
            
            attributedString.addAttributes([NSAttributedStringKey.paragraphStyle: descriptionStyle],
                                           range: NSRange(location: 0, length: attributedString.length))
            
            contentLabel.attributedText = attributedString
        } else {
            contentLabel.setText(text: element.value, lineSpacing: 8.0)
        }
        
        return contentLabel
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
        if (targetContentOffset.pointee.y <= KPArticleViewController.scrollAnimationThreshold) {
            checkDismissBehavior(scrollView.contentOffset.y)
            autoScaleHeroImage(offsetY: targetContentOffset.pointee.y)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
                
                topBarContainer.alpha = 0
                dismissButton.tintColor = UIColor.white
                
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
                    topBarContainer.alpha = 0
                    dismissButton.tintColor = UIColor.white
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
