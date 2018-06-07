//
//  SetUsernameViewController.swift
//  XTsplit
//
//  Created by Kevin Linne on 24.09.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import UIKit
import Firebase

class SetUsernameViewController: UIViewController {

    
    @IBOutlet weak var usernameField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextPressed(_ sender: AnyObject) {
        if inputValid() {
            
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
    
    
    func inputValid() -> Bool {
        let ref = FIRDatabase.database().reference()
        
        if let username = usernameField.text , username != "" {
            if username.characters.count < 5 {
                alert(message: "Wähle einen Username, der aus mindestens 5 Zeichen besteht.", title: "Username zu kurz")
            } else {
                let regex = "^(?=.{5,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$"
                let test = NSPredicate(format:"SELF MATCHES %@", regex)

                if test.evaluate(with: username) {
                    
                    
                    ref.child("usernames").observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.hasChild(username) {
                            self.alert(message: "Wähle einen anderen Benutzernamen", title: "Name schon vergeben")
                        } else {
                            self.saveUsernameToFirebase(username: username)
                            UserDefaults.standard.set(username, forKey: KEY_USERNAME)
                            self.performSegue(withIdentifier: SEGUE_LOGGED_IN, sender: nil)
                        }
                    })
                    
                    
                } else {
                    print(username)
                    alert(message: "Der Username darf nur Buchstaben, Zahlen und Unterstriche enthalten", title: "Unerlaubte Zeichen")
                }
            }
        } else {
            alert(message: "Wähle einen Username, der aus mindestens 5 Zeichen besteht.", title: "Username darf nicht leer sein")
        }
        
        return true
    }
    
    func saveUsernameToFirebase(username: String) {
        let uid = UserDefaults.standard.string(forKey: KEY_UID)!
        let ref = FIRDatabase.database().reference()
        ref.child("users").child(uid).child("username").setValue(username)
        ref.child("usernames").child(username).setValue(uid)
    }
    

}
