//
//  KPUserManager.swift
//  kapi-kaffeine
//
//  Created by YU CHONKAO on 2017/5/25.
//  Copyright © 2017年 kapi-kaffeine. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FacebookLogin
import FacebookCore
import ObjectMapper

public class KPUserManager {
    
    
    static let sharedManager = KPUserManager() 
    
    
    // MARK: Initialization
    
    private init() {
        
        // 讀取資料
        KPUserDefaults.loadUserInformation()

        // 建立Current User
        if KPUserDefaults.accessToken != nil {
            let currentUserInfo = ["access_token": KPUserDefaults.accessToken]
            self.currentUser = Mapper<KPUser>().map(JSONObject: currentUserInfo)
        }
    }
    
    
    // MARK: Properties
    
    var currentUser: KPUser?
    
    //
    
    // MARK: API
    
    func logIn(_ viewController: UIViewController,
               completion: ((Bool) -> Swift.Void)? = nil) {
        
        let loginManager = LoginManager()
        
        loginManager.loginBehavior = LoginBehavior.native;
        loginManager.logIn([.publicProfile],
                           viewController: viewController) { (loginResult) in
                            switch loginResult {
                            case .failed(let error):
                                print(error)
                            case .cancelled:
                                print("User cancelled login.")
                            case .success( _, _, let accessToken):
                                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                                FIRAuth.auth()?.signIn(with: credential,
                                                       completion: { (user, error) in
                                                        if let error = error {
                                                            print("Login error: \(error.localizedDescription)")
                                                            let alertController = UIAlertController(title: "Login Error",
                                                                                                    message: error.localizedDescription,
                                                                                                    preferredStyle: .alert)
                                                            let okayAction = UIAlertAction(title: "OK",
                                                                                           style: .cancel,
                                                                                           handler: nil)
                                                            alertController.addAction(okayAction)
                                                            viewController.present(alertController,
                                                                                   animated: true,
                                                                                   completion: nil)
                                                            completion?(false)
                                                            return
                                                        }
                                                        
                                                        
                                                        let loginRequest = KPLoginRequest()
                                                        loginRequest.perform(user?.uid,
                                                                             user?.displayName,
                                                                             user?.photoURL?.absoluteString,
                                                                             user?.email ?? "unknown").then { result -> Void in
                                                                                
                                                                                // 建立 Current User
                                                                                self.currentUser =
                                                                                    Mapper<KPUser>().map(JSONObject: result["data"].dictionaryValue)
                                                                                self.currentUser?.accessToken = result["token"].stringValue
                                                                                KPUserDefaults.accessToken = self.currentUser?.accessToken
                                                            
                                                            }.catch { error in
                                                                print("Error")
                                                            }
                                                        
                                                        completion?(true)
                                                        viewController.dismiss(animated: true, completion: {
                                                            print("Successfully Logged In")
                                                            
                                                        })
                                })
                            }
        }
    }
    
}
