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
    
    
    let demoImages = [R.image.demo_1(),
                      R.image.demo_2(),
                      R.image.demo_3(),
                      R.image.demo_4(),
                      R.image.demo_5(),
                      R.image.demo_6()]

    let testJSONString = """
        [
          {
            "priority": 1,
            "title": "工業風咖啡廳",
            "description": "由知名部落客們聯手推薦的知名店家。",
            "tag": "熱門",
            "shops": [
              {
                "cafe_id": "00014645-38c8-4eb4-ad9b-faa871d7e511",
                "address": "台北市中正區大安森林公園",
                "latitude": 23.4838654,
                "longitude": 120.4535834,
                "name": "老木咖啡",
                "place": "台北 大安區",
                "rate_average": 4.7,
                "covers": {
                  "google_s": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
                  "google_l": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
                  "kapi_l": "https://api.kapi.tw/photos/acc73e436cd63f921fde961bac0c89f4fd056457.JPEG",
                  "kapi_s": "https://farm4.staticflickr.com/3928/15425389946_e53b2dd92b_z.jpg"
                }
              },
                {
                    "cafe_id": "00014645-38c8-4eb4-ad9b-faa871d7e511",
                    "address": "台北市中正區大安森林公園",
                    "latitude": 23.4838654,
                    "longitude": 120.4535834,
                    "name": "Fika Fika Cafe",
                    "place": "台北 大安區",
                    "rate_average": 4.7,
                    "covers": {
                      "google_s": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
                      "google_l": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
                      "kapi_l": "https://api.kapi.tw/photos/acc73e436cd63f921fde961bac0c89f4fd056457.JPEG",
                      "kapi_s": "https://pic.pimg.tw/cindylo326/1483925400-2421597698_n.jpg"
                    }
                },
                {
                    "cafe_id": "00014645-38c8-4eb4-ad9b-faa871d7e511",
                    "address": "台北市中正區大安森林公園",
                    "latitude": 23.4838654,
                    "longitude": 120.4535834,
                    "name": "極簡咖啡",
                    "place": "台北 大安區",
                    "rate_average": 4.7,
                    "covers": {
                      "google_s": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
                      "google_l": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
                      "kapi_l": "https://api.kapi.tw/photos/acc73e436cd63f921fde961bac0c89f4fd056457.JPEG",
                      "kapi_s": "https://pgw.udn.com.tw/gw/photo.php?u=https://uc.udn.com.tw/photo/2017/07/28/1/3808271.jpg&x=0&y=0&sw=0&sh=0&sl=W&fw=1050&exp=3600"
                    }
                },
                {
                    "cafe_id": "00014645-38c8-4eb4-ad9b-faa871d7e511",
                    "address": "台北市中正區大安森林公園",
                    "latitude": 23.4838654,
                    "longitude": 120.4535834,
                    "name": "樹樂集咖啡",
                    "place": "台北 大安區",
                    "rate_average": 4.7,
                    "covers": {
                      "google_s": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
                      "google_l": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
                      "kapi_l": "https://api.kapi.tw/photos/acc73e436cd63f921fde961bac0c89f4fd056457.JPEG",
                      "kapi_s": "https://img.hiromishi.com/2014-04-24-041347-36.jpg"
                    }
                }
            ]
          },
          {
            "priority": 2,
            "title": "熱門 Facebook 店家",
            "description": "知名 Facebook 部落客們聯手推薦！",
            "tag": "推薦",
            "shops": [
              {
                "cafe_id": "00014645-38c8-4eb4-ad9b-faa871d7e511",
                    "address": "台北市中正區大安森林公園",
                    "latitude": 23.4838654,
                    "longitude": 120.4535834,
                    "name": "Fika Fika Cafe",
                    "place": "台北 大安區",
                    "rate_average": 4.7,
                    "covers": {
                      "google_s": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
                      "google_l": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
                      "kapi_l": "https://api.kapi.tw/photos/acc73e436cd63f921fde961bac0c89f4fd056457.JPEG",
                      "kapi_s": "https://pic.pimg.tw/cindylo326/1483925400-2421597698_n.jpg"
                    }
              }
            ]
          },
          {
            "priority": 3,
            "title": "東京文青十大咖啡廳",
            "description": "東京設計美學推薦十大必訪咖啡廳。",
            "tag": "推薦",
            "shops": [
              {
                    "cafe_id": "00014645-38c8-4eb4-ad9b-faa871d7e511",
                    "address": "台北市中正區大安森林公園",
                    "latitude": 23.4838654,
                    "longitude": 120.4535834,
                    "name": "Fika Fika Cafe",
                    "place": "台北 大安區",
                    "rate_average": 4.7,
                    "covers": {
                      "google_s": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
                      "google_l": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
                      "kapi_l": "https://api.kapi.tw/photos/acc73e436cd63f921fde961bac0c89f4fd056457.JPEG",
                      "kapi_s": "https://pic.pimg.tw/cindylo326/1483925400-2421597698_n.jpg"
                    }
                },
                {
                    "cafe_id": "00014645-38c8-4eb4-ad9b-faa871d7e511",
                    "address": "台北市中正區大安森林公園",
                    "latitude": 23.4838654,
                    "longitude": 120.4535834,
                    "name": "極簡咖啡",
                    "place": "台北 大安區",
                    "rate_average": 4.7,
                    "covers": {
                      "google_s": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
                      "google_l": "https://maps.googleapis.com/maps/api/place/photo?xxxx",
                      "kapi_l": "https://api.kapi.tw/photos/acc73e436cd63f921fde961bac0c89f4fd056457.JPEG",
                      "kapi_s": "https://pgw.udn.com.tw/gw/photo.php?u=https://uc.udn.com.tw/photo/2017/07/28/1/3808271.jpg&x=0&y=0&sw=0&sh=0&sl=W&fw=1050&exp=3600"
                    }
                }
            ]
          }
        ]
        """
    
    var testData: [KPExplorationSection]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testData = Mapper<KPExplorationSection>().mapArray(JSONString: testJSONString) ?? []
        view.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        hero.isEnabled = true
        layoutWithSecondVersion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        articleCollectionView.collectionViewLayout.invalidateLayout()
        if !rootTabViewController.exploreAnimationHasPerformed {
            
            headerView.alpha = 0
            articleCollectionView.alpha = 0
            sectionBgImageView.alpha = 0.2
            
            for cell in self.contentTableView.visibleCells {
                cell.alpha = 0
            }
            
            if !rootTabViewController.exploreAnimationHasPerformed {
                UIView.animate(withDuration: 0.6,
                               delay: 0.2,
                               options: UIViewAnimationOptions.curveEaseOut,
                               animations: {
                                self.headerView.alpha = 1.0
                }, completion: { (_) in
                    
                })
                
                UIView.animate(withDuration: 1.5,
                               delay: 0.4,
                               options: .curveEaseOut,
                               animations: {
                                self.sectionBgImageView.alpha = 0.5
                                self.sectionBgImageView.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    
                })
                
                UIView.animate(withDuration: 0.6,
                               delay: 0.4,
                               options: UIViewAnimationOptions.curveEaseOut,
                               animations: {
                                self.articleCollectionView.alpha = 1.0
                }, completion: { (_) in
                    
                })
                
                for cell in self.contentTableView.visibleCells {
                    UIView.animate(withDuration: 0.6,
                                   delay: 0.6,
                                   options: UIViewAnimationOptions.curveEaseOut,
                                   animations: {
                                    cell.alpha = 1.0
                    }, completion: { (_) in
                        self.rootTabViewController.exploreAnimationHasPerformed = true
                    })
                }
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
        backgroundPath.addLine(to: CGPoint(x: view.bounds.width,
                                           y: 0))
        backgroundPath.addLine(to: CGPoint(x: view.bounds.width,
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
        sectionBgImageView.contentMode = .scaleAspectFill
        sectionBgImageView.layer.mask = maskLayer_bg
        sectionBgImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        headerView.addSubview(sectionBgImageView)
        sectionBgImageView.addConstraints(fromStringArray: ["V:|-(-140)-[$self]|",
                                                            "H:|[$self]|"])
        
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
        searchContainer.layer.cornerRadius = 2.0
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
        articleCollectionView.register(KPArticleCell.self,
                                       forCellWithReuseIdentifier: "ArticleCell")
        articleCollectionView.backgroundColor = UIColor.clear
        headerView.addSubview(articleCollectionView)
        articleCollectionView.delaysContentTouches = true
        articleCollectionView.clipsToBounds = false
        articleCollectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                               "V:[$view0][$self]-24-|"],
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
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return shouldShowLightContent ? .lightContent : .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
            controller.contentController = navigationController
            controller.presentModalView()
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
            let controller = KPModalViewController()
            controller.edgeInset = UIEdgeInsets(top: 0,
                                                left: 0,
                                                bottom: 0,
                                                right: 0)
            let searchController = KPSearchViewController()
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
            }
        }
    }
    
}

extension KPExplorationViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! KPArticleCell
        cell.articleHeroImageView.image = demoImages[indexPath.row]
        cell.hero.id = "article-\(indexPath.row)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! KPArticleCell
        currentArticleViewController = KPArticleViewController()
        currentArticleViewController.explorationViewController = self
        currentArticleViewController.imageSource = cell.articleHeroImageView.image
        currentArticleViewController.selectedIndex = indexPath as NSIndexPath
        
        present(currentArticleViewController,
                animated: true,
                completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
        
        return CGSize(width: 140,
                      height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return CGPoint(x: floor(Double(proposedContentOffset.x/(UIScreen.main.bounds.width/2))*Double(UIScreen.main.bounds.width/2)),
                       y: Double(proposedContentOffset.y))
    }
    
}
