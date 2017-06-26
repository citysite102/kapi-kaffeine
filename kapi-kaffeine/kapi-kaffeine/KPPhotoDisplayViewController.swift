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

class KPPhotoDisplayViewController: KPViewController {

    static let KPPhotoDisplayControllerCellReuseIdentifier = "cell";
    
    var statusBarShouldBeHidden = false
    var diplayedPhotoInformations: [PhotoInformation] = [PhotoInformation]()
    
    var collectionView:UICollectionView!;
    var collectionLayout:UICollectionViewFlowLayout!;
    var dismissButton:KPBounceButton!
    var selectedIndexPath: IndexPath!
    var titleContent: String! {
        willSet {
            let fadeTransition = CATransition()
            fadeTransition.duration = 0.3
            
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.photoTitleLabel.text = self.titleContent
                self.photoTitleLabel.layer.add(fadeTransition, forKey: nil)
            })
            self.photoTitleLabel.text = ""
            self.photoTitleLabel.layer.add(fadeTransition, forKey: nil)
            CATransaction.commit()
        }
    }
    
    
    lazy var photoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        return label
    }()
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = KPColorPalette.KPTextColor.whiteColor
        return label
    }()
    
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
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
        collectionView.isPrefetchingEnabled = true
        collectionView.register(KPPhotoDisplayCell.self,
                                forCellWithReuseIdentifier: KPPhotoDisplayViewController.KPPhotoDisplayControllerCellReuseIdentifier)
        
        view.addSubview(self.collectionView);
        collectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                        "V:|[$self]|"]);
        
        dismissButton = KPBounceButton()
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4)
        dismissButton.setImage(R.image.icon_close()?.withRenderingMode(.alwaysTemplate),
                               for: .normal)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.addTarget(self,
                                action: #selector(KPPhotoDisplayViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        view.addSubview(self.dismissButton)
        dismissButton.addConstraints(fromStringArray: ["H:|-8-[$self(24)]",
                                                       "V:|-16-[$self(24)]"]);
        
        view.addSubview(photoTitleLabel)
        photoTitleLabel.text = "覺旅咖啡 Journey Cafe"
        photoTitleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        photoTitleLabel.addConstraint(from: "V:|-16-[$self]")
        
        view.addSubview(countLabel)
        countLabel.text = "6 of 104"
        countLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        countLabel.addConstraint(from: "V:[$self]-24-|")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarShouldBeHidden = true
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleDismissButtonOnTapped() {
            self.dismiss(animated: true) {
            }
    }
    
}

extension KPPhotoDisplayViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        selectedIndexPath = IndexPath.init(row: (Int)(collectionView.contentOffset.x/collectionView.frameSize.width),
                                           section: 0)
    }
}

extension KPPhotoDisplayViewController:
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        self.dismiss(animated: true, completion: {
        })
    }
    
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

extension KPPhotoDisplayViewController: ImageTransitionProtocol {
    
    // 1: hide scroll view containing images
    func tranisitionSetup() {
        collectionView.isHidden = true
    }
    
    // 2; unhide images and set correct image to be showing
    func tranisitionCleanup() {
        collectionView.isHidden = false
        collectionView.scrollToItem(at: selectedIndexPath,
                                    at: .left,
                                    animated: false)
        collectionView.layoutIfNeeded()
    }
    
    // 3: return the imageView window frame
    func imageWindowFrame() -> CGRect {
        
        let cell = collectionView.cellForItem(at: selectedIndexPath)
        var displayedCell: KPPhotoDisplayCell!
        if cell == nil {
            collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: false)
            collectionView.layoutIfNeeded()
            displayedCell = collectionView.cellForItem(at: selectedIndexPath) as! KPPhotoDisplayCell
        } else {
            displayedCell = cell as! KPPhotoDisplayCell
        }
        
        let photo = displayedCell.shopPhoto.image
        let imageRatio = (photo?.size.width)! / (photo?.size.height)!
        
        let height = collectionView.frameSize.width / imageRatio
        let yPoint = collectionView.frameOrigin.y + (collectionView.frameSize.height-height)/2
        return CGRect.init(x: collectionView.frameOrigin.x,
                           y: yPoint,
                           width: collectionView.frameSize.width,
                           height: height)
    }
}

