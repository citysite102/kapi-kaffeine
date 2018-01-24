//
//  KPExplorationViewController.swift
//  kapi-kaffeine
//
//  Created by MengHsiu Chang on 21/11/2017.
//  Copyright © 2017 kapi-kaffeine. All rights reserved.
//

import UIKit

class KPExplorationViewController: UIViewController {

    var articleCollectionView: UICollectionView!
    
    let demoImages = [R.image.demo_1(),
                      R.image.demo_2(),
                      R.image.demo_3(),
                      R.image.demo_4(),
                      R.image.demo_5(),
                      R.image.demo_6()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 330))
        
        
        let articleLabel = UILabel()
        articleLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        articleLabel.textColor = KPColorPalette.KPTextColor_v2.mainColor_title
        articleLabel.text = "精選文章"
        
        headerView.addSubview(articleLabel)
        articleLabel.addConstraints(fromStringArray: ["H:|-20-[$self]",
                                                      "V:|[$self(30)]"])
        
        let articleLayout = UICollectionViewFlowLayout()
        articleLayout.scrollDirection = .horizontal
        
        articleCollectionView = UICollectionView(frame: CGRect(x: 0,
                                                               y: 0,
                                                               width: UIScreen.main.bounds.width,
                                                               height: 300),
                                                 collectionViewLayout: articleLayout)
        articleCollectionView.showsHorizontalScrollIndicator = false
        articleCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        articleCollectionView.dataSource = self
        articleCollectionView.delegate = self
        articleCollectionView.register(KPArticleCell.self, forCellWithReuseIdentifier: "ArticleCell")
        articleCollectionView.backgroundColor = UIColor.clear
        headerView.addSubview(articleCollectionView)
        articleCollectionView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0]-[$self]-|"],
                                             views: [articleLabel])
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 30, right: 0)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(KPExplorationSectionView.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                   "V:|[$self]|"])
        tableView.tableHeaderView = headerView
        
        
//        view.backgroundColor = UIColor(hexString: "f8f8f8")
//
//        let scrollView = UIScrollView()
//        view.addSubview(scrollView)
//        scrollView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
//
//        let scrollContainer = UIView()
//        scrollView.addSubview(scrollContainer)
//        scrollContainer.addConstraintForHavingSameWidth(with: scrollView)
//        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
//
//        let articleLayout = UICollectionViewFlowLayout()
//        articleLayout.scrollDirection = .horizontal
//
//        articleCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: articleLayout)
//        articleCollectionView.showsHorizontalScrollIndicator = false
//        articleCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
//        articleCollectionView.dataSource = self
//        articleCollectionView.delegate = self
//        articleCollectionView.register(KPArticleCell.self, forCellWithReuseIdentifier: "ArticleCell")
//        articleCollectionView.backgroundColor = UIColor.clear
//
//        scrollContainer.addSubview(articleCollectionView)
//        articleCollectionView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|-100-[$self(260)]"])
//
//        let sectionView = KPExplorationSectionView()
//        scrollContainer.addSubview(sectionView)
//        sectionView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0]-[$self]-20-|"],
//                                   views: [articleCollectionView])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension KPExplorationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
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
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2 - 20*1.5, height: 260)
    }
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return CGPoint(x: floor(Double(proposedContentOffset.x/(UIScreen.main.bounds.width/2))*Double(UIScreen.main.bounds.width/2)),
                       y: Double(proposedContentOffset.y))
    }
    
}
