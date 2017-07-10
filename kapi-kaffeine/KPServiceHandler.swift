//
//  KPServiceHandler.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/26.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import Foundation
import ObjectMapper

class KPServiceHandler {

    
    static let sharedHandler = KPServiceHandler()
    
    private var kapiDataRequest: KPCafeRequest!
    private var kapiDetailedInfoRequest: KPCafeDetailedInfoRequest!
    private var loadingView: KPLoadingView!
    
    // 目前儲存所有的咖啡店
    var currentCafeDatas: [KPDataModel]!
    
    // MARK: Initialization
    
    private init() {
        kapiDataRequest = KPCafeRequest()
        kapiDetailedInfoRequest = KPCafeDetailedInfoRequest()
        loadingView = KPLoadingView()
    }
    
    
    // MARK: Global API
    
    func fetchRemoteData(_ limitedTime: NSNumber? = nil,
                         _ socket: NSNumber? = nil,
                         _ standingDesk: NSNumber? = nil,
                         _ mrt: String? = nil,
                         _ city: String? = nil,
                         _ completion:((_ result: [KPDataModel]?) -> Void)!) {
        kapiDataRequest.perform(limitedTime,
                                socket,
                                standingDesk,
                                mrt,
                                city).then { result -> Void in
                                    var cafeDatas = [KPDataModel]()
                                    if result["data"].arrayObject != nil {
                                        for data in (result["data"].arrayObject)! {
                                            if let cafeData = KPDataModel(JSON: (data as! [String: Any])) {
                                                cafeDatas.append(cafeData)
                                            }
                                        }
                                        self.currentCafeDatas = cafeDatas
                                        completion?(cafeDatas)
                                    } else {
                                        completion?(nil)
                                    }
        }.catch { error in
                completion?(nil)
        }
    }
    
    
    func fetchStoreInformation(_ cafeID: String!,
                               _ completion:((_ result: KPDataModel?) -> Void)!) {
        kapiDetailedInfoRequest.perform(cafeID).then {result -> Void in
            if let data = result["data"].dictionaryObject {
                if let cafeData = KPDataModel(JSON: data) {
                    completion(cafeData)
                }
            }
        }.catch { error in
            completion(nil)
        }
    }
    
    
    // Comment API
    
    var currentDisplayModel: KPDataModel?
    
    func addComment(_ comment: String? = "",
                    _ completion: ((_ successed: Bool) -> Swift.Void)?) {
        
        let commentRequest = KPNewCommentRequest()
        
        loadingView.loadingContents = ("新增中...", "新增成功", "新增失敗")
        UIApplication.shared.topViewController.view.addSubview(loadingView)
        loadingView.state = .loading
        loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
        
        commentRequest.perform((currentDisplayModel?.identifier)!,
                               comment!).then { result -> Void in
                                if let commentResult = result["result"].bool {
                                    self.loadingView.state = commentResult ? .successed : .failed
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                                                  execute: {
                                                                    self.loadingView.removeFromSuperview()
                                    })
                                    KPUserManager.sharedManager.currentUser?.reviews?.append(self.currentDisplayModel!)
                                    KPUserManager.sharedManager.storeUserInformation()
                                    completion?(true)
                                }
                                    print("Add New Comment Result:\(result)")
        }.catch { (error) in
            self.loadingView.state = .failed
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                          execute: {
                                            self.loadingView.removeFromSuperview()
            })
            completion?(false)
        }
    }
    
    func getComments(_ completion: ((_ successed: Bool,
                                     _ comments: [KPCommentModel]?) -> Swift.Void)?) {
        
        let commentRequest = KPGetCommentRequest()
        commentRequest.perform((currentDisplayModel?.identifier)!).then { result -> Void in
            var resultComments = [KPCommentModel]()
            if result["result"].boolValue {
                if let commentDatas = result["data"]["comments"].arrayObject {
                    for case let commentDataModel as Dictionary<String, Any> in commentDatas {
                        if let commentModel = KPCommentModel(JSON: commentDataModel) {
                            resultComments.append(commentModel)
                        }
                    }
                }
                completion?(true, resultComments)
            } else {
                completion?(true, nil)
            }
        }.catch { (error) in
            completion?(false, nil)
        }
    }
    
    // Rating API

    func addRating(_ wifi: NSNumber? = 0,
                   _ seat: NSNumber? = 0,
                   _ food: NSNumber? = 0,
                   _ quiet: NSNumber? = 0,
                   _ tasty: NSNumber? = 0,
                   _ cheap: NSNumber? = 0,
                   _ music: NSNumber? = 0,
                   _ completion: ((_ successed: Bool) -> Swift.Void)?) {
        let newRatingRequest = KPNewRatingRequest()
        
        loadingView.loadingContents = ("新增中...", "新增成功", "新增失敗")
        UIApplication.shared.KPTopViewController().view.addSubview(loadingView)
        loadingView.state = .loading
        loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
        
        newRatingRequest.perform((currentDisplayModel?.identifier)!,
                                 wifi,
                                 seat,
                                 food,
                                 quiet,
                                 tasty,
                                 cheap,
                                 music).then { result -> Void in
                                    if let commentResult = result["result"].bool {
                                        self.loadingView.state = commentResult ? .successed : .failed
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                                                      execute: {
                                                                        self.loadingView.removeFromSuperview()
                                        })
                                        completion?(commentResult)
                                    }
                                    print("Result\(result)")
        }.catch { (error) in
                self.loadingView.state = .failed
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                          execute: {
                                            self.loadingView.removeFromSuperview()
            })
            completion?(false)
        }
    }
    
    func getRatings(_ completion: ((_ successed: Bool,
        _ rating: KPRateDataModel?) -> Swift.Void)?) {
        
        let getRatingRequest = KPGetRatingRequest()
        getRatingRequest.perform((currentDisplayModel?.identifier)!).then { result -> Void in
            if let ratingResult = KPRateDataModel(JSON: result["data"].dictionaryObject!) {
                completion?(true, ratingResult)
            }
            completion?(false, nil)
        }.catch { (error) in
            completion?(false, nil)
        }
    }
    
    // Photo API
    
    func getPhotos(_ completion: ((_ successed: Bool,
        _ photos: [String]?) -> Swift.Void)?) {
        
        let getPhotoRequest = KPGetPhotoRequest()
        getPhotoRequest.perform((currentDisplayModel?.identifier)!).then { result -> Void in
            print("Get Photo Result:\(result)")
        }.catch { (error) in
            completion?(false, nil)
        }
    }
    
    
    // Favorite / Visit
    
    func addFavoriteCafe(_ completion: ((Bool) -> Swift.Void)? = nil) {
        
        let addRequest = KPFavoriteRequest()
        
        addRequest.perform((currentDisplayModel?.identifier)!,
                           KPFavoriteRequest.requestType.add).then { result -> Void in
                            KPUserManager.sharedManager.currentUser?.favorites?.append(self.currentDisplayModel!)
                            KPUserManager.sharedManager.storeUserInformation()
                            completion?(true)
                            print("Result\(result)")
            }.catch { error in
                print("Add Favorite Cafe error\(error)")
                completion?(false)
        }
    }
    
    func removeFavoriteCafe(_ cafeID: String,
                            _ completion: ((Bool) -> Swift.Void)? = nil) {
        
        let removeRequest = KPFavoriteRequest()
        removeRequest.perform(cafeID,
                              KPFavoriteRequest.requestType.delete).then { result -> Void in
                                //                                if let found = self.currentUser?.favorites?.first(where: {$0.identifier == cafeID}) {
                                if let foundOffset = KPUserManager.sharedManager.currentUser?.favorites?.index(where: {$0.identifier == cafeID}) {
                                    KPUserManager.sharedManager.currentUser?.favorites?.remove(at: foundOffset)
                                }
                                KPUserManager.sharedManager.storeUserInformation()
                                completion?(true)
                                print("Result\(result)")
            }.catch { (error) in
                print("error\(error)")
                completion?(false)
        }
    }
    
    func addVisitedCafe(_ completion: ((Bool) -> Swift.Void)? = nil) {
        let addRequest = KPVisitedRequest()
        addRequest.perform((currentDisplayModel?.identifier)!,
                           KPVisitedRequest.requestType.add).then { result -> Void in
                            KPUserManager.sharedManager.currentUser?.visits?.append(self.currentDisplayModel!)
                            KPUserManager.sharedManager.storeUserInformation()
                            completion?(true)
                            print("Result\(result)")
            }.catch { (error) in
                print("Remove Visited Cafe error\(error)")
                completion?(false)
        }
    }
    
    func removeVisitedCafe(_ cafeID: String,
                           _ completion: ((Bool) -> Swift.Void)? = nil) {
        let removeRequest = KPVisitedRequest()
        removeRequest.perform(cafeID,
                              KPVisitedRequest.requestType.delete).then { result -> Void in
                                if let foundOffset = KPUserManager.sharedManager.currentUser?.visits?.index(where: {$0.identifier == cafeID}) {
                                    KPUserManager.sharedManager.currentUser?.visits?.remove(at: foundOffset)
                                }
                                KPUserManager.sharedManager.storeUserInformation()
                                completion?(true)
                                print("Result\(result)")
            }.catch { (error) in
                print("Remove Visited Error \(error)")
                completion?(false)
        }
    }

}
