//
//  KPPhotoDisplayViewController.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/9.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit

struct PhotoInformation {
    let title: String
    let image: UIImage
    let index: Int
}

class KPPhotoDisplayViewController: UIViewController {

    static let KPPhotoDisplayControllerCellReuseIdentifier = "cell";
    
    var diplayedPhotoInformations: [PhotoInformation] = [PhotoInformation]()
//    {
//        didSet {
//            collectionView.reloadData()
//        }
//    }
    
    var currentIndexPath: IndexPath? {
        didSet {
            collectionView.setToIndexPath(currentIndexPath!)
            collectionView.scrollToItem(at: currentIndexPath!,
                                        at: .centeredHorizontally,
                                        animated: false)
        }
    }
    
    var collectionView:UICollectionView!;
    var collectionLayout:UICollectionViewFlowLayout!;
    var dismissButton:KPBounceButton!
    var titleLabel:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black
        //Collection view
        collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.itemSize = CGSize.init(width: UIScreen.main.bounds.size.width,
                                                     height: UIScreen.main.bounds.size.height);
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = UIColor.black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delaysContentTouches = true
        collectionView.isPagingEnabled = true
        collectionView.register(KPPhotoDisplayCell.self,
                                forCellWithReuseIdentifier: KPPhotoDisplayViewController.KPPhotoDisplayControllerCellReuseIdentifier)
        
        self.view.addSubview(self.collectionView);
        self.collectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                             "V:|[$self]|"]);
        
        self.dismissButton = KPBounceButton()
        self.dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        self.dismissButton.setImage(UIImage.init(named: "icon_close")?.withRenderingMode(.alwaysTemplate),
                                    for: .normal)
        self.dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        self.dismissButton.addTarget(self,
                                     action: #selector(KPPhotoDisplayViewController.handleDismissButtonOnTapped),
                                     for: .touchUpInside)
        self.view.addSubview(self.dismissButton)
        self.dismissButton.addConstraints(fromStringArray: ["H:|-8-[$self(24)]",
                                                            "V:|-16-[$self(24)]"]);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleDismissButtonOnTapped() {
        self.dismiss(animated: true) { 
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension KPPhotoDisplayViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diplayedPhotoInformations.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPPhotoDisplayViewController.KPPhotoDisplayControllerCellReuseIdentifier,
                                                      for: indexPath) as! KPPhotoDisplayCell
        cell.shopPhoto.image = self.diplayedPhotoInformations[indexPath.row].image
        return cell;
    }
}

var kIndexPathPointer = "kIndexPathPointer"

extension UICollectionView{
    
    func setToIndexPath (_ indexPath : IndexPath){
        objc_setAssociatedObject(self, &kIndexPathPointer, indexPath, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func toIndexPath () -> IndexPath {
        let index = self.contentOffset.x/self.frame.size.width
        if index > 0{
            return IndexPath(row: Int(index), section: 0)
        } else if let indexPath = objc_getAssociatedObject(self,&kIndexPathPointer) as? IndexPath {
            return indexPath
        } else {
            return IndexPath(row: 0, section: 0)
        }
    }
    
    func fromPageIndexPath () -> IndexPath{
        let index : Int = Int(self.contentOffset.x/self.frame.size.width)
        return IndexPath(row: index, section: 0)
    }
}



