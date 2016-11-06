//
//  ViewController.swift
//  FaceWeb
//
//  Created by Mark Funnell on 11/6/16.
//  Copyright © 2016 Mark Funnell. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passField: FancyField!
    
   
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let hasKeychain = KeychainWrapper.standard.string(forKey: KEY_UID) {
            
            performSegue(withIdentifier: "GoToFeed", sender: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fbBTNTapped(_ sender: Any) {
        
        let fbLogin = FBSDKLoginManager()
        
        fbLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                
                print("MF: Unable to authenticate with Facebook - \(error)")
                
            } else if result?.isCancelled == true {
                
                print("MF: User cancelled Facebook authentication - \(error)")
                
            } else {
                
                print("MF: Authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pass = passField.text {
            
            
            //Pass must be 6 char min
            FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { (user, error) in
                
                if error == nil {
                    
                    print("MF: Email user authenticated")
                    
                    
                    
                } else {
                    
                    FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
                        
                        if error != nil {
                         
                            print("MF: Unable to authenticate Firebase - email create")
                            
                        } else {
                        
                            print("MF: Email user authenticated - email create")
                            self.completeSignIn(id: (user?.uid)!)
                            
                        }
                        
                    })
                    
                }
                
            })
            
        }
        
    }
    
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
        
            if error != nil {
                
                print("MF: Unable to authenticate with Firebase - \(error)")
                
            } else {
                
                print("MF: Authenticated with Firebase")
                
                if let user = user {
                    
                    self.completeSignIn(id: user.uid)
        
                }
                
                
            }
            
        })
        
    }
    
    func completeSignIn(id: String) {
        
        if let saveSuccessful: Bool = KeychainWrapper.standard.set(id, forKey: KEY_UID) {
            
            print("MF: Saved to keychain")
            performSegue(withIdentifier: "GoToFeed", sender: nil)
    
        } else {
            
            print("MF: uhoh")
            
        }
        
    }
    
}

