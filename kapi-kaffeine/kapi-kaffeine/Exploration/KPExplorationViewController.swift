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

    var headerContainer: UIView!
    var locationSelectView: KPLocationSelect!
    var searchContainerShadowView: UIView!
    var searchContainer: UIView!
    var searchIcon: UIImageView!
    var searchLabel: UILabel!
    
    var filterButton: KPBounceButton!
    
    var articleCollectionView: UICollectionView!
    
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
            "title": "熱門 Facebook 打卡店家",
            "description": "由知名 Facebook 部落客們聯手推薦的知名店家。",
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
            "description": "帶著行李出發吧！讓我們一起去看看東京設計美學推薦的十大必訪咖啡廳。",
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
        
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: 260))
        
        
        let articleLabel = UILabel()
        articleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        articleLabel.textColor = KPColorPalette.KPMainColor_v2.mainColor
        articleLabel.text = "編輯精選"
        headerView.addSubview(articleLabel)
        articleLabel.addConstraints(fromStringArray: ["H:|-24-[$self]",
                                                      "V:|[$self(30)]"])
        
        let articleLayout = UICollectionViewFlowLayout()
        articleLayout.scrollDirection = .horizontal
        
        articleCollectionView = UICollectionView(frame: CGRect.zero,
                                                 collectionViewLayout: articleLayout)
        articleCollectionView.showsHorizontalScrollIndicator = false
        articleCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        articleCollectionView.dataSource = self
        articleCollectionView.delegate = self
        articleCollectionView.register(KPArticleCell.self, forCellWithReuseIdentifier: "ArticleCell")
        articleCollectionView.backgroundColor = UIColor.clear
        headerView.addSubview(articleCollectionView)
        articleCollectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                               "V:[$view0]-[$self]-24-|"],
                                             views: [articleLabel])
//        articleCollectionView.addConstraints(fromStringArray: ["H:|[$self]|",
//                                                               "V:|-20-[$self]-|"])
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.contentInset = UIEdgeInsets(top: 110,
                                              left: 0,
                                              bottom: 30,
                                              right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(KPExplorationSectionView.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:|[$self]|"])
        tableView.tableHeaderView = headerView

        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(handleSearchContainerLongPressed(_:)))
        longPressGesture.minimumPressDuration = 0
        
        headerContainer = UIView()
        headerContainer.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        view.addSubview(headerContainer)
        headerContainer.addConstraints(fromStringArray: ["V:|[$self(112)]",
                                                         "H:|[$self]|"])
        
        locationSelectView = KPLocationSelect()
        headerContainer.addSubview(locationSelectView)
        locationSelectView.addConstraints(fromStringArray: ["H:|-24-[$self]",
                                                            "V:|-52-[$self(44)]"])
        
        searchContainerShadowView = UIView()
        headerContainer.addSubview(searchContainerShadowView)
        searchContainerShadowView.addConstraints(fromStringArray: ["H:[$view0]-16-[$self]-16-|",
                                                                   "V:|-52-[$self(44)]"], views: [locationSelectView])
        
        searchContainer = UIView()
        searchContainer.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
        searchContainer.layer.cornerRadius = 4.0
        searchContainer.layer.masksToBounds = true
        searchContainer.layer.borderWidth = 1.0
        searchContainer.layer.borderColor = KPColorPalette.KPMainColor_v2.grayColor_level5?.cgColor
        
        searchContainerShadowView.addSubview(searchContainer)
        searchContainer.addConstraints(fromStringArray: ["H:|[$self]|",
                                                         "V:|[$self]|"])
        searchContainer.addGestureRecognizer(longPressGesture)
        searchIcon = UIImageView(image: R.image.icon_search())
        searchIcon.tintColor = KPColorPalette.KPTextColor_v2.mainColor_hint
        searchContainer.addSubview(searchIcon)
        searchIcon.addConstraints(fromStringArray: ["V:[$self(18)]",
                                                    "H:|-12-[$self(18)]"])
        searchIcon.addConstraintForCenterAligning(to: searchContainer,
                                                  in: .vertical,
                                                  constant: 0)
        
        searchLabel = UILabel()
        searchLabel.font = UIFont.systemFont(ofSize: 14.0)
        searchLabel.text = "搜尋店家名稱、標籤、地點"
        searchLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_hint
        searchContainer.addSubview(searchLabel)
        searchLabel.addConstraints(fromStringArray: ["H:[$view0]-8-[$self]"],
                                   views:[searchIcon])
        searchLabel.addConstraintForCenterAligningToSuperview(in: .vertical)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                                             lineSpacing: 3.0)
        cell.shops = testData[indexPath.row].shops
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UITableView.self) {
            if scrollView.contentOffset.y > -82 {
                headerContainer.backgroundColor = KPColorPalette.KPBackgroundColor.whiteColor
                headerContainer.layer.shadowColor = KPColorPalette.KPMainColor_v2.shadow_mainColor?.cgColor
                headerContainer.layer.shadowOpacity = 0.2
                headerContainer.layer.shadowOffset = CGSize(width: 0,
                                                                      height: 4)
                headerContainer.layer.shadowRadius = 4.0
            } else {
                headerContainer.layer.shadowOpacity = 0.0
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
        let imageView = UIImageView(image: demoImages[Int(arc4random())%6])
        imageView.contentMode = .scaleAspectFill
        cell.backgroundView = imageView
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = KPModalViewController()
        controller.edgeInset = UIEdgeInsets(top: 0,
                                            left: 0,
                                            bottom: 0,
                                            right: 0)
        let articleController = KPArticleViewController()
        controller.contentController = articleController
        controller.presentModalView()
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
                            left: 24,
                            bottom: 20,
                            right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: UIScreen.main.bounds.width/2 - 20*1.5,
//                      height: 260)
        return CGSize(width: 140,
                      height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return CGPoint(x: floor(Double(proposedContentOffset.x/(UIScreen.main.bounds.width/2))*Double(UIScreen.main.bounds.width/2)),
                       y: Double(proposedContentOffset.y))
    }
    
}
