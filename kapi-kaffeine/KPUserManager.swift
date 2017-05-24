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

public class KPUserManager {
    
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
                                                            completion!(false)
                                                        }
                                                        
                                                        completion!(true)
//                                                        viewController.dismiss(animated: true, completion: { 
//                                                            print("Successfully Logged In")
//                                                            
//                                                        })
                                })
                            }
        }
    }
}