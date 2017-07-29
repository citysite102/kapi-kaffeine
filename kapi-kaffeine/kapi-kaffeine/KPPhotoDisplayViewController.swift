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
//    let image: UIImage
    let imageURL: URL
    let index: Int
}

class KPPhotoDisplayViewController: KPViewController {
    
    static let KPPhotoDisplayControllerCellReuseIdentifier = "cell";
    
    var statusBarShouldBeHidden = false
    var displayedPhotoInformations: [PhotoInformation] = [PhotoInformation]()
    
    var dismissing: Bool = false
    var startAnchorPoint: CGPoint!
    var centerPoint: CGPoint!
    var lastMovePoint: CGPoint?
    
    var collectionView : UICollectionView!
    var collectionLayout: UICollectionViewFlowLayout!
    var dismissButton: KPBounceButton!
    var selectedIndexPath: IndexPath! {
        didSet {
            countLabel.text = "\(selectedIndexPath.row+1) of \(displayedPhotoInformations.count)"
            photoTitleLabel.text = displayedPhotoInformations[selectedIndexPath.row].title
        }
    }
    var backgroundSnapshot: UIView! {
        didSet {
            self.view.insertSubview(backgroundSnapshot, at: 0)
            backgroundSnapshot.addConstraints(fromStringArray: ["V:|[$self]|",
                                                                "H:|[$self]|"])
        }
    }
    var overlayCover: UIView!
    
    
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
    
    lazy var userPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = KPColorPalette.KPBackgroundColor.mainColor
        imageView.layer.cornerRadius = 24.0
        imageView.layer.masksToBounds = true
        imageView.image = R.image.demo_profile()
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        
        overlayCover = UIView()
        overlayCover.backgroundColor = UIColor.black
        overlayCover.alpha = 1.0
        view.addSubview(overlayCover)
        overlayCover.addConstraints(fromStringArray: ["V:|[$self]|",
                                                      "H:|[$self]|"])
        
        collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width,
                                           height: UIScreen.main.bounds.size.height);
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: collectionLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delaysContentTouches = true
        collectionView.canCancelContentTouches = false
        collectionView.isPagingEnabled = true
        collectionView.isPrefetchingEnabled = true
        collectionView.register(KPPhotoDisplayCell.self,
                                forCellWithReuseIdentifier: KPPhotoDisplayViewController.KPPhotoDisplayControllerCellReuseIdentifier)
        
        view.addSubview(self.collectionView);
        collectionView.addConstraints(fromStringArray: ["H:|[$self]|",
                                                        "V:|[$self]|"]);
        
        dismissButton = KPBounceButton()
        dismissButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6)
        dismissButton.setImage(R.image.icon_close()?.withRenderingMode(.alwaysTemplate),
                               for: .normal)
        dismissButton.tintColor = KPColorPalette.KPTextColor.whiteColor
        dismissButton.addTarget(self,
                                action: #selector(KPPhotoDisplayViewController.handleDismissButtonOnTapped),
                                for: .touchUpInside)
        view.addSubview(self.dismissButton)
        dismissButton.addConstraints(fromStringArray: ["H:|-8-[$self(30)]",
                                                       "V:|-12-[$self(30)]"]);
        
        view.addSubview(photoTitleLabel)
        photoTitleLabel.text = ""
        photoTitleLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        photoTitleLabel.addConstraint(from: "V:|-16-[$self]")
        
        view.addSubview(countLabel)
//        countLabel.text = "\(selectedIndexPath.row+1) of \(displayedPhotoInformations.count)"
        countLabel.addConstraintForCenterAligningToSuperview(in: .horizontal)
        countLabel.addConstraint(from: "V:[$self]-16-|")
//        countLabel.addConstraint(from: "H:[$self]-16-|")
        
        view.addSubview(userPhoto)
        userPhoto.isHidden = true
        userPhoto.addConstraints(fromStringArray: ["V:[$self(48)]-16-|",
                                                   "H:|-16-[$self(48)]"])
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
//        showUserPhoto()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showUserPhoto() {
        userPhoto.transform = CGAffineTransform(translationX: 0, y: 80)
        userPhoto.isHidden = false
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseInOut,
                       animations: { 
                        self.userPhoto.transform = .identity
        }) { (_) in
            
        }
    }
    
    func handleDismissButtonOnTapped() {
        self.dismissing = true
        self.dismiss(animated: true) {
        }
    }
   
    
    func handlePhotoLongPressed(_ sender: UILongPressGestureRecognizer) {
        let cell = collectionView.cellForItem(at: selectedIndexPath) as! KPPhotoDisplayCell
        switch sender.state {
        case .began:
            startAnchorPoint = sender.location(in: cell)
            centerPoint = view.layer.position
        case .changed:
            let touchPoint = sender.location(in: cell)
            let distance = (pow(centerPoint.x-touchPoint.x , 2) + pow(centerPoint.y-touchPoint.y, 2)).squareRoot()
            
            print("Frame: \(cell.shopPhoto.frame)")
            if lastMovePoint != nil {
                cell.shopPhoto.transform = CGAffineTransform(translationX:touchPoint.x - startAnchorPoint.x,
                                                        y: touchPoint.y - startAnchorPoint.y)
                lastMovePoint = touchPoint
            } else {
                cell.shopPhoto.transform = CGAffineTransform(translationX: touchPoint.x - startAnchorPoint.x,
                                                        y: touchPoint.y - startAnchorPoint.y)
                lastMovePoint = touchPoint
            }
            
            overlayCover.alpha = ((1000 - distance < 0) ? 1 : 1000-distance) / 1000
            dismissButton.alpha = ((700 - distance < 0) ? 1 : 700-distance) / 700
            photoTitleLabel.alpha = ((700 - distance < 0) ? 1 : 700-distance) / 700
            userPhoto.alpha = ((700 - distance < 0) ? 1 : 700-distance) / 700
//            userPhoto.transform = CGAffineTransform(translationX: 0,
//                                                    y: (1-dismissButton.alpha)*(-100))
        case .ended:
            
            let distance = (pow(centerPoint.x-(lastMovePoint?.x ?? 0) , 2) +
                pow(centerPoint.y-(lastMovePoint?.y ?? 0), 2)).squareRoot()
            if distance > 150 {
                self.dismissing = true
                self.dismiss(animated: true) {
                }
            } else {
                lastMovePoint = nil
                UIView.animate(withDuration: 0.7,
                               delay: 0,
                               usingSpringWithDamping: 0.7,
                               initialSpringVelocity: 0.8,
                               options: UIViewAnimationOptions.curveEaseIn,
                               animations: {
                                cell.shopPhoto.transform = .identity
                                self.overlayCover.alpha = 1.0
                                self.dismissButton.alpha = 1.0
                                self.photoTitleLabel.alpha = 1.0
                                self.userPhoto.transform = .identity
                }) { (_) in
                    
                }
            }
            
        case .cancelled:
            print("Cancelled")
        default:
            print("Default")
        }
    }
    
}

extension KPPhotoDisplayViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        selectedIndexPath = IndexPath(row: (Int)(collectionView.contentOffset.x/collectionView.frameSize.width),
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
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedPhotoInformations.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KPPhotoDisplayViewController.KPPhotoDisplayControllerCellReuseIdentifier,
                                                      for: indexPath) as! KPPhotoDisplayCell
        
        if cell.longPressGesture == nil {
            let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                                action: #selector(handlePhotoLongPressed(_:)))
            longPressGesture.minimumPressDuration = 0.1
            cell.longPressGesture = longPressGesture
            cell.shopPhoto.addGestureRecognizer(longPressGesture)
        }
        
        cell.shopPhoto.af_setImage(withURL: self.displayedPhotoInformations[indexPath.row].imageURL,
                                   placeholderImage: R.image.image_loading(),
                                   filter: nil,
                                   progress: nil,
                                   progressQueue: DispatchQueue.global(),
                                   imageTransition: UIImageView.ImageTransition.crossDissolve(0.2),
                                   runImageTransitionIfCached: false,
                                   completion:{ (response) in
                                    if response.error != nil {
                                        cell.shopPhoto.image = R.image.image_failed()
                                    }
                                    if let responseImage = response.result.value {
                                        cell.shopPhoto.image = responseImage
                                    }
        })
        
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
        
        if dismissing {
            let xPoint = displayedCell.shopPhoto.frameOrigin.x
            let yPoint = displayedCell.shopPhoto.frameOrigin.y + (collectionView.frameSize.height-height)/2
            
            print("frame: \(displayedCell.shopPhoto.frame)")
            return CGRect.init(x: xPoint,
                               y: yPoint,
                               width: collectionView.frameSize.width,
                               height: height)
        } else {
            let yPoint = collectionView.frameOrigin.y + (collectionView.frameSize.height-height)/2
            return CGRect.init(x: collectionView.frameOrigin.x,
                               y: yPoint,
                               width: collectionView.frameSize.width,
                               height: height)
        }
    }
}

