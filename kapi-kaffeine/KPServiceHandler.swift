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
    private var loadingView: KPLoadingView!
    
    
    // MARK: Initialization
    
    private init() {
        kapiDataRequest = KPCafeRequest()
        loadingView = KPLoadingView()
    }
    
    
    // MARK: Global API
    
    func fetchRemoteData(_ limitedTime: NSNumber? = nil,
                         _ socket: NSNumber? = nil,
                         _ standingDesk: NSNumber? = nil,
                         _ mrt: String? = nil,
                         _ city: String? = nil,
                         _ completion:((_ result: [KPDataModel]) -> Void)? = nil) {
        kapiDataRequest.perform(limitedTime,
                                socket,
                                standingDesk,
                                mrt,
                                city).then { result -> Void in
                                    var cafeDatas = [KPDataModel]()
                                    for data in (result["data"].arrayObject)! {
                                        let cafeData = KPDataModel(JSON: (data as! [String: Any]))
                                        if cafeData != nil {
                                            cafeDatas.append(cafeData!)
                                        }
                                    }
                                    completion?(cafeDatas)
            }.catch { error in
                print("Error")
        }
    }
    
    
    // Comment API
    
    var currentDisplayModel: KPDataModel?
    
    func addNewComment(_ comment: String? = "",
                       _ completion: ((_ successed: Bool) -> Void)?) {
        let newCommentRequest = KPNewCommentRequest()
        
        loadingView.loadingContents = ("新增中...", "新增成功", "新增失敗")
        UIApplication.shared.topViewController.view.addSubview(loadingView)
        loadingView.state = .loading
        loadingView.addConstraints(fromStringArray: ["V:|[$self]|",
                                                     "H:|[$self]|"])
        
        newCommentRequest.perform((currentDisplayModel?.identifier)!,
                                  comment!).then { result -> Void in
                                    if let commentResult = result["result"].bool {
                                        self.loadingView.state = commentResult ? .successed : .failed
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                                                      execute: {
                                                                        self.loadingView.removeFromSuperview()
                                        })
                                        if completion != nil {
                                            completion!(commentResult)
                                        }
                                    }
                                    print("Result\(result)")
        }.catch { (error) in
            self.loadingView.state = .failed
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                          execute: {
                                            self.loadingView.removeFromSuperview()
            })
            if completion != nil {
                completion!(false)
            }
        }
    }
    
    func getComments(_ completion: ((_ successed: Bool) -> Void)?) {
        
        let getCommentRequest = KPGetCommentRequest()
        getCommentRequest.perform((currentDisplayModel?.identifier)!).then { result -> Void in
            
            print("Result\(result)")
            
            }.catch { (error) in
            
        }
        
    }
    
    // Rating API

    func addNewRating(_ wifi: NSNumber? = 0,
                      _ seat: NSNumber? = 0,
                      _ food: NSNumber? = 0,
                      _ quiet: NSNumber? = 0,
                      _ tasty: NSNumber? = 0,
                      _ cheap: NSNumber? = 0,
                      _ music: NSNumber? = 0,
                      _ completion: ((_ successed: Bool) -> Void)?) {
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
                                        if completion != nil {
                                            completion!(commentResult)
                                        }
                                    }
                                    print("Result\(result)")
        }.catch { (error) in
                self.loadingView.state = .failed
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0,
                                          execute: {
                                            self.loadingView.removeFromSuperview()
            })
                if completion != nil {
                    completion!(false)
                }
        }

    }
}
