//
//  ViewController.swift
//  XTsplit
//
//  Created by Kevin Linne on 11.09.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import Firebase


class LoginViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var pwdInput: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        if let uid = UserDefaults.standard.object(forKey: KEY_UID) {
            self.performCorrectSegue(uid: uid as! String)
        }
        
    }
    
    
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        if let email = emailInput.text , email != "", let pwd = pwdInput.text , pwd != "" {
            
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error != nil {
                    
                    if error?._code == STATUS_ACCOUNT_NONEXIST {
                        self.registerUser(email: email, password: pwd)
                    } else {
                        self.alert(message: "Bitte überprüfe deine Email und das Passwort", title: "Could not log in")
                    }
                } else {
                    
                    self.performCorrectSegue(uid: (user?.uid)!)
                    
                }
                
            })
        } else {
            self.alert(message: "Die Felder dürfen nicht leer sein", title: "Email und Passwort benötigt")
        
        }
        
    }

    @IBAction func loginWithFBPressed(_ sender: AnyObject) {
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else if (result?.isCancelled)! {
                print("Cancelled")
            } else {
                let accessToken = FBSDKAccessToken.current().tokenString
                print("Successfully logged in with Facebook. \(accessToken)")
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken!)
                
                FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                    if error != nil {
                        print("Firebase login failed. \(error)")
                    } else {
                        print("Logged in \(user)")
                        
                        
                        let fireUser = ["provider": user!.providerID]
                        
                        
                        DataService.ds.createFirebaseUser(user!.uid, user: fireUser)
                        
                        
                        UserDefaults.standard.setValue(user?.uid, forKeyPath: "uid")
                        
                        
                        self.performCorrectSegue(uid: user!.uid)
                    }
                })
            }
        }
    }
    
    func registerUser(email: String, password: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                self.alert(message: "Es gab ein Problem bei der Registrierung. Probiere es später erneut", title: "Account konnte nicht erstellt werden")
            } else {
                UserDefaults.standard.setValue(user?.uid, forKeyPath: "uid")
                
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    let fireUser = ["provider": user!.providerID]
                    DataService.ds.createFirebaseUser(user!.uid, user: fireUser)
                })
                
                self.performSegue(withIdentifier: SEGUE_SET_USERNAME, sender: nil)
            }
            
            
        })
    }
    
    func performCorrectSegue(uid: String) {
        let ref = FIRDatabase.database().reference()
        
        
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            
            if let username = value?["username"] as? String {
                UserDefaults.standard.set(username, forKey: "username")
                self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)

            } else {
                self.performSegue(withIdentifier: SEGUE_SET_USERNAME, sender: nil)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }

    }
}

