//
//  KPExplorationViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 21/11/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit
import ObjectMapper

class KPExplorationViewController: KPViewController {

    var backgroundView: UIView!
    var sectionBgImageView: UIImageView!
    var locationSelectView: KPLocationSelect!
    var searchContainerShadowView: UIView!
    var searchContainer: UIView!
    var searchIcon: UIImageView!
    var searchLabel: UILabel!
    var shouldShowLightContent: Bool = true
    var currentBgImageIndex = 0
    var targetPosition: CGPoint = CGPoint(x: -1, y: 0)
    
    var filterButton: KPBounceButton!
    var headerView: UIView!
    var footerView: UIView!
    var moreContentLabel: UILabel!
    var moreContentIcon: UIImageView!
    
    var headerContainer: UIView!
    var currentArticleViewController: KPArticleViewController!
    weak var rootTabViewController: KPMainTabController!
    var articleCollectionView: UICollectionView!
    var contentTableView: UITableView!
    
    var testData: [KPExplorationSection] = []
    var articleList: [KPArticleItem] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        hero.isEnabled = true
        layoutWithSecondVersion()
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleLightStatusBar),
                                               name: Notification.Name(KPNotification.statusBar.statusBarShouldLight),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleDefaultStatusBar),
                                               name: Notification.Name(KPNotification.statusBar.statusBarShouldDefault),
                                               object: nil)
        
        
        if articleList.isEmpty {
            refreshData()
        }
    }
    
    @objc func handleLightStatusBar() {
        shouldShowLightContent = true
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    @objc func handleDefaultStatusBar() {
        shouldShowLightContent = false
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func performAnimation(completion: (() -> Swift.Void)? = nil) {
        articleCollectionView.collectionViewLayout.invalidateLayout()
        if !rootTabViewController.exploreAnimationHasPerformed {
            
            footerView.alpha = 0
            headerView.alpha = 0
            sectionBgImageView.alpha = 0.2
            
            for cell in self.articleCollectionView.visibleCells {
                cell.alpha = 0
            }
            
            for cell in self.contentTableView.visibleCells {
                cell.alpha = 0
//                cell.transform = CGAffineTransform(translationX: 0, y: 24)
            }
            
            UIView.animate(withDuration: 0.4,
                           delay: 0.2,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: {
                            self.headerView.alpha = 1.0
                            self.footerView.alpha = 1.0
            }, completion: { (_) in
                
            })
            
            UIView.animate(withDuration: 1.2,
                           delay: 0.8,
                           options: .curveEaseOut,
                           animations: {
                            self.sectionBgImageView.alpha = 0.5
                            self.sectionBgImageView.transform = CGAffineTransform.identity
                            self.rootTabViewController.exploreAnimationHasPerformed = true
            }, completion: { (_) in
                
            })
            
            for (index, cell) in self.articleCollectionView.visibleCells.enumerated() {
//                UIView.animate(withDuration: 0.2,
//                               delay: 0.6+(Double(self.articleCollectionView.visibleCells.count-1)*0.2-Double(index)*0.2),
//                               options: UIViewAnimationOptions.curveEaseOut,
//                               animations: {
//                                cell.alpha = 1.0
//                }, completion: { (_) in
//
//                })
                UIView.animate(withDuration: 0.2,
                               delay: 0.5,
                               options: UIViewAnimationOptions.curveEaseOut,
                               animations: {
                                cell.alpha = 1.0
                }, completion: { (_) in
                    
                })
            }
            
            for (index, cell) in self.contentTableView.visibleCells.enumerated() {
                UIView.animate(withDuration: 0.4,
                               delay: 0.7+(Double(self.contentTableView.visibleCells.count-1)*0.2-Double(index)*0.2),
                               options: UIViewAnimationOptions.curveEaseOut,
                               animations: {
                                cell.alpha = 1.0
                                cell.transform = CGAffineTransform.identity
                }, completion: { (_) in
                })
            }
        }
    }

    func layoutWithSecondVersion() {
        headerView = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: UIScreen.main.bounds.width,
                                          height: 400))
        footerView = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: UIScreen.main.bounds.width,
                                          height: 40))
        let backgroundPath = UIBezierPath()
        backgroundPath.move(to: CGPoint(x: 0, y: 0))
        backgroundPath.addLine(to: CGPoint(x: view.bounds.width+48,
                                           y: 0))
        backgroundPath.addLine(to: CGPoint(x: view.bounds.width+48,
                                           y: 400))
        backgroundPath.addLine(to: CGPoint(x: 0,
                                           y: 480))
        backgroundPath.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = backgroundPath.cgPath
        
        backgroundView = UIView()
        backgroundView.backgroundColor = KPColorPalette.KPMainColor_v2.mainColor_dark
        backgroundView.layer.mask = maskLayer
        headerView.addSubview(backgroundView)
        headerView.clipsToBounds = false
        backgroundView.addConstraints(fromStringArray: ["V:|-(-140)-[$self]|",
                                                        "H:|[$self]|"])
        
        let maskLayer_bg = CAShapeLayer()
        maskLayer_bg.path = backgroundPath.cgPath
        
        sectionBgImageView = UIImageView(image: R.image.demo_black()?.tint(KPColorPalette.KPMainColor_v2.mainColor_dark!, blendMode: .softLight))
        sectionBgImageView.contentMode = .scaleAspectFit
        sectionBgImageView.layer.mask = maskLayer_bg
        sectionBgImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sectionBgImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        headerView.addSubview(sectionBgImageView)
        sectionBgImageView.addConstraints(fromStringArray: ["V:|-(-140)-[$self]|",
                                                            "H:|-(-24)-[$self]-(-24)-|"])
        
//        sectionBgImageView.addConstraints(fromStringArray: ["V:|-(-140)-[$self]|"])
//        sectionBgImageView.addConstraintForCenterAligningToSuperview(in: .horizontal)
        let longPressGesture_location = UILongPressGestureRecognizer(target: self,
                                                                     action: #selector(handleLocationContainerLongPressed(_:)))
        longPressGesture_location.minimumPressDuration = 0
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(handleSearchContainerLongPressed(_:)))
        longPressGesture.minimumPressDuration = 0
        
        headerContainer = UIView()
        headerContainer.backgroundColor = UIColor.clear
        headerView.addSubview(headerContainer)
        headerContainer.addConstraintForHavingSameWidth(with: view)
        headerContainer.addConstraints(fromStringArray: ["V:|[$self(104)]",
                                                         "H:|[$self]|"])
        
        locationSelectView = KPLocationSelect()
        locationSelectView.locationLabel.textColor = KPColorPalette.KPBackgroundColor.white_level1
        locationSelectView.dropDownIcon.tintColor = KPColorPalette.KPBackgroundColor.white_level1
        headerContainer.addSubview(locationSelectView)
        locationSelectView.addGestureRecognizer(longPressGesture_location)
        locationSelectView.addConstraints(fromStringArray: ["H:|-20-[$self]",
                                                            "V:|-40-[$self(36)]"])
        
        
        searchContainerShadowView = UIView()
        headerContainer.addSubview(searchContainerShadowView)
        searchContainerShadowView.addConstraints(fromStringArray: ["H:[$view0]-16-[$self]-16-|",
                                                                   "V:|-40-[$self(36)]"], views: [locationSelectView])

        searchContainer = UIView()
        searchContainer.backgroundColor = KPColorPalette.KPBackgroundColor.white_level3
        searchContainer.layer.cornerRadius = 4.0
        searchContainer.layer.masksToBounds = true
        searchContainerShadowView.addSubview(searchContainer)
        searchContainer.addGestureRecognizer(longPressGesture)
        searchContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self]|"])
        
        searchIcon = UIImageView(image: R.image.icon_search())
        searchIcon.tintColor = KPColorPalette.KPBackgroundColor.white_level1
        searchContainer.addSubview(searchIcon)
        searchIcon.addConstraints(fromStringArray: ["V:[$self(18)]",
                                                    "H:|-10-[$self(18)]"])
        searchIcon.addConstraintForCenterAligning(to: searchContainer,
                                                  in: .vertical,
                                                  constant: 0)
        
        searchLabel = UILabel()
        searchLabel.font = UIFont.systemFont(ofSize: KPFontSize.subContent)
        searchLabel.text = "搜尋店家名稱、標籤..."
        searchLabel.textColor = KPColorPalette.KPBackgroundColor.white_level1
        searchContainer.addSubview(searchLabel)
        searchLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]"],
                                   views:[searchIcon])
        searchLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        let articleLabel = UILabel()
        articleLabel.font = UIFont.systemFont(ofSize: KPFontSize.header,
                                              weight: UIFont.Weight.medium)
        articleLabel.textColor = KPColorPalette.KPTextColor_v2.whiteColor
        articleLabel.text = "編輯精選"
        headerView.addSubview(articleLabel)
        articleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]",
                                                      "V:[$view0][$self(28)]"],
                                    views:[headerContainer])
        
        let articleLayout = GlidingLayout()
        articleLayout.scrollDirection = .horizontal
        
        articleCollectionView = UICollectionView(frame: CGRect.zero,
                                                 collectionViewLayout: articleLayout)
        articleCollectionView.showsHorizontalScrollIndicator = false
        articleCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        articleCollectionView.dataSource = self
        articleCollectionView.delegate = self
        articleCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        articleCollectionView.register(KPArticleCell.self,
                                       forCellWithReuseIdentifier: "ArticleCell")
        articleCollectionView.backgroundColor = UIColor.clear
        headerView.addSubview(articleCollectionView)
        articleCollectionView.delaysContentTouches = true
        articleCollectionView.clipsToBounds = false
        articleCollectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                               "V:[$view0][$self]|"],
                                             views: [articleLabel])
        
        contentTableView = UITableView(frame: CGRect.zero, style: .plain)
        contentTableView.contentInset = UIEdgeInsets(top: 0,
                                              left: 0,
                                              bottom: 30,
                                              right: 0)
        contentTableView.dataSource = self
        contentTableView.delegate = self
        contentTableView.separatorStyle = .none
        contentTableView.allowsSelection = false
        contentTableView.showsVerticalScrollIndicator = false
        contentTableView.register(KPExplorationSectionView.self,
                                  forCellReuseIdentifier: "cell")
        view.addSubview(contentTableView)
        contentTableView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                          "V:|-(-20)-[$self]|"])
        
        
        moreContentIcon = UIImageView(image: R.image.icon_facebook())
        moreContentIcon.tintColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        footerView.addSubview(moreContentIcon)
        moreContentIcon.addConstraints(fromStringArray: ["H:|-($metric0)-[$self(20)]",
                                                         "V:[$self(20)]"],
                                       metrics:[KPLayoutConstant.information_horizontal_offset])
        moreContentIcon.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        moreContentLabel = UILabel()
        moreContentLabel.font = UIFont.systemFont(ofSize: KPFontSize.mainContent,
                                                  weight: UIFont.Weight.light)
        
        moreContentLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_subtitle
        moreContentLabel.text = "想看更多內容嗎？"
        footerView.addSubview(moreContentLabel)
        moreContentLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]"],
                                        metrics:[KPLayoutConstant.information_horizontal_offset], views:[moreContentIcon])
        moreContentLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
        
        
        contentTableView.tableHeaderView = headerView
        contentTableView.tableFooterView = footerView
        
        footerView.alpha = 0
        headerView.alpha = 0
        sectionBgImageView.alpha = 0.2
        
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return shouldShowLightContent ? .lightContent : .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func refreshData() {
        KPServiceHandler.sharedHandler.fetchExplorationList { [weak self] (explorationList, error) in
            
            guard let this = self else {
                return
            }

            guard explorationList != nil else {
                return
            }
            
            this.testData = explorationList!
            DispatchQueue.main.async {
                this.contentTableView.reloadData()
                self?.performAnimation(completion: {
                    
                })
            }
        }
        
        KPServiceHandler.sharedHandler.fetchArticleList { [weak self] (articleList, error) in
            guard let this = self else {
                return
            }
            
            guard articleList != nil else {
                return
            }
            
            this.articleList = articleList!
            DispatchQueue.main.async {
                this.articleCollectionView.collectionViewLayout.invalidateLayout()
                this.articleCollectionView.reloadData()
            }
        }
    }
    
    
    // MARK: - Events
    
    @objc func handleLocationContainerLongPressed(_ gesture: UILongPressGestureRecognizer) {
        if (gesture.state == .began) {
            UIView.animate(withDuration: 0.1,
                           animations: {
                            self.locationSelectView.transform = CGAffineTransform(scaleX: 0.98,
                                                                               y: 0.98)
            }) { (_) in
            }
        } else if (gesture.state == .ended) {
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
            let locationController = KPLocationSelectViewController()
            let navigationController = UINavigationController(rootViewController: locationController)
//            navigationController.modalPresentationStyle = .fullScreen
//            navigationController.modalPresentationCapturesStatusBarAppearance = true
//            controller.contentController = navigationController
//            controller.presentModalView()
            present(navigationController, animated: true, completion: nil)
            self.locationSelectView.transform = CGAffineTransform.identity
        }
    }
    
    @objc func handleSearchContainerLongPressed(_ gesture: UILongPressGestureRecognizer) {
        
        if (gesture.state == .began) {
            UIView.animate(withDuration: 0.1,
                           animations: {
                            self.searchContainer.transform = CGAffineTransform(scaleX: 0.98,
                                                                               y: 0.98)
            }) { (_) in
            }
        } else if (gesture.state == .ended) {
            
            self.shouldShowLightContent = false
            UIView.animate(withDuration: 0.5,
                           animations: {
                            self.setNeedsStatusBarAppearanceUpdate()
            })
            
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
            let searchController = KPSearchViewController()
            searchController.explorationController = self
            let navigationController = UINavigationController(rootViewController: searchController)
            controller.contentController = navigationController
            controller.presentModalView()
            self.searchContainer.transform = CGAffineTransform.identity
        }
    }
}


extension KPExplorationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection
        section: Int) -> Int {
        return testData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! KPExplorationSectionView
        cell.sectionTitleLabel.text = testData[indexPath.row].title
        cell.sectionDescriptionLabel.setText(text: testData[indexPath.row].explorationDescription,
                                             lineSpacing: 4.0)
        cell.shops = testData[indexPath.row].shops
//        cell.shouldShowSeparatar = !(indexPath.row == testData.count-1)
        
        return cell
    }
    
//    func scrollviewdidends
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if targetPosition.x != -1 {
            scrollView.setContentOffset(targetPosition,
                                        animated: true)
            targetPosition.x = -1
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        

        if (targetContentOffset.pointee.x < CGFloat((articleList.count-2)*255) + 100) {
            let currentOffset = targetContentOffset.pointee.x
            var index = floor(currentOffset/255)
            if currentOffset - 180 > 255*index || currentOffset + 75 > 255 * (index+1) {
                index = index+1
            }

            if velocity.x == 0 {
                targetContentOffset.pointee.x = index*255
            } else {
                if (velocity.x > 0 && index*255 > scrollView.contentOffset.x) ||
                    (velocity.x < 0 && index*255 < scrollView.contentOffset.x) {
                        targetContentOffset.pointee.x = index*255
                } else {
                    targetPosition = CGPoint(x: index*255, y: 0)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UITableView.self) && rootTabViewController.exploreAnimationHasPerformed
        {
            if scrollView.contentOffset.y < -20 {
                let scaleRatio = 1 + ((-20)-scrollView.contentOffset.y)/600
                sectionBgImageView.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
                backgroundView.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
            } else {
                sectionBgImageView.transform = CGAffineTransform.identity
                backgroundView.transform = CGAffineTransform.identity
                
                if scrollView.contentOffset.y > 200 {
                    self.shouldShowLightContent = false
                } else {
                    self.shouldShowLightContent = true
                }
                UIView.animate(withDuration: 0.5,
                               animations: {
                                self.setNeedsStatusBarAppearanceUpdate()
                })
            }
        } else if (scrollView == self.articleCollectionView) {
            if scrollView.contentOffset.x < 250 &&
                currentBgImageIndex != 0 {
                
                currentBgImageIndex = 0
                
                UIView.animate(withDuration: 0.4,
                               animations: {
                                self.sectionBgImageView.alpha = 0
                                self.sectionBgImageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }) { (_) in
                    UIView.animate(withDuration: 0.4,
                                   animations: {
                                    self.sectionBgImageView.alpha = 1.0
                                    self.sectionBgImageView.transform = CGAffineTransform.identity
                                    self.sectionBgImageView.image = R.image.demo_black()?.tint(KPColorPalette.KPMainColor_v2.mainColor_dark!, blendMode: .softLight)
                    })
                }
                
                
            } else if scrollView.contentOffset.x < 500 &&
                scrollView.contentOffset.x >= 250 &&
                currentBgImageIndex != 1 {
                
                currentBgImageIndex = 1
                
                UIView.animate(withDuration: 0.4,
                               animations: {
                                self.sectionBgImageView.alpha = 0
                                self.sectionBgImageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }) { (_) in
                    UIView.animate(withDuration: 0.4,
                                   animations: {
                                    self.sectionBgImageView.alpha = 1.0
                                    self.sectionBgImageView.transform = CGAffineTransform.identity
                                    self.sectionBgImageView.image = R.image.demo_1()?.tint(KPColorPalette.KPMainColor_v2.mainColor_dark!, blendMode: .softLight)
                    })
                }
                
            } else if scrollView.contentOffset.x < 750 &&
                scrollView.contentOffset.x >= 500 &&
                currentBgImageIndex != 2 {
                
                currentBgImageIndex = 2
                
                UIView.animate(withDuration: 0.4,
                               animations: {
                                self.sectionBgImageView.alpha = 0
                                self.sectionBgImageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }) { (_) in
                    UIView.animate(withDuration: 0.4,
                                   animations: {
                                    self.sectionBgImageView.alpha = 1.0
                                    self.sectionBgImageView.transform = CGAffineTransform.identity
                                    self.sectionBgImageView.image = R.image.demo_2()?.tint(KPColorPalette.KPMainColor_v2.mainColor_dark!, blendMode: .softLight)
                    })
                }
            }
        }
    }
    
}

extension KPExplorationViewController: UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! KPArticleCell
        
        if let url = articleList[indexPath.row].imageURL_s ?? articleList[indexPath.row].imageURL_l  {
            cell.articleHeroImageView.af_setImage(withURL: url,
                                                  placeholderImage: nil,
                                                  filter: nil,
                                                  progress: nil,
                                                  progressQueue: DispatchQueue.global(),
                                                  imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                                  runImageTransitionIfCached: true,
                                                  completion: nil)
        } else {
            cell.articleHeroImageView.image = #imageLiteral(resourceName: "demo_7")
        }
        
        cell.articleHeroImageView.hero.id = "article-\(indexPath.row)"
        cell.titleLabel.setText(text: articleList[indexPath.row].title!,
                                lineSpacing: 4.0)
        cell.subLabel.text = "\(articleList[indexPath.row].peopleRead) 人已閱讀"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! KPArticleCell
        currentArticleViewController = KPArticleViewController(articleList[indexPath.row].articleID)
        currentArticleViewController.explorationViewController = self
        currentArticleViewController.imageSource = cell.articleHeroImageView.image
        currentArticleViewController.selectedIndex = indexPath as NSIndexPath
        currentArticleViewController.currentArticleItem = articleList[indexPath.row]
        
        present(currentArticleViewController,
                animated: true,
                completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20,
                            left: 20,
                            bottom: 20,
                            right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        
        return CGSize(width: 240,
                      height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return CGPoint(x: floor(Double(proposedContentOffset.x/(UIScreen.main.bounds.width/2))*Double(UIScreen.main.bounds.width/2)),
                       y: Double(proposedContentOffset.y))
    }
    
}
