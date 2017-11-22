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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexString: "f8f8f8")
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        
        let scrollContainer = UIView()
        scrollView.addSubview(scrollContainer)
        scrollContainer.addConstraintForHavingSameWidth(with: scrollView)
        scrollContainer.addConstraints(fromStringArray: ["H:|[$self]|", "V:|[$self]|"])
        
        let articleLayout = UICollectionViewFlowLayout()
        articleLayout.scrollDirection = .horizontal

        articleCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: articleLayout)
        articleCollectionView.showsHorizontalScrollIndicator = false
        articleCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        articleCollectionView.dataSource = self
        articleCollectionView.delegate = self
        articleCollectionView.register(KPArticleCell.self, forCellWithReuseIdentifier: "ArticleCell")
        articleCollectionView.backgroundColor = UIColor.clear
        
        scrollContainer.addSubview(articleCollectionView)
        articleCollectionView.addConstraints(fromStringArray: ["H:|[$self]|", "V:|-100-[$self(260)]"])
        
        let sectionView = KPExplorationSectionView()
        scrollContainer.addSubview(sectionView)
        sectionView.addConstraints(fromStringArray: ["H:|[$self]|", "V:[$view0]-[$self]-20-|"],
                                   views: [articleCollectionView])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let imageView = UIImageView(image: R.image.demo_6()!)
        imageView.contentMode = .scaleAspectFill
        cell.backgroundView = imageView
        cell.titleLabel.text = "Demo"
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
        return CGSize(width: UIScreen.main.bounds.width/2 - 16*1.5, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return CGPoint(x: floor(Double(proposedContentOffset.x/(UIScreen.main.bounds.width/2))*Double(UIScreen.main.bounds.width/2)),
                       y: Double(proposedContentOffset.y))
    }
    
}
