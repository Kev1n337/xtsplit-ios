//
//  AddFriendViewController.swift
//  XTsplit
//
//  Created by Kevin Linne on 08.10.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import UIKit
import Firebase


protocol AddMemberDelegate {
    func memberAddedResponse(user:User)
}

class AddFriendViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nameInput: UITextField!

    @IBOutlet weak var tableView: UITableView!
    
    let db = FIRDatabase.database().reference()
    
    var users = [User]()
    
    var addMember = false
    var delegate: AddMemberDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameInput.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
        if addMember == true {
            db.child("users").child(UserDefaults.standard.string(forKey: KEY_UID)!).child("friends").observeSingleEvent(of: .value, with: { (snapshot) in
                if let friends = snapshot.value as? Dictionary<String, String> {
                    for friend in friends {
                        self.users.append(User(uid: friend.key, username: friend.value))
                    }
                    self.tableView.reloadData()
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameInput.resignFirstResponder()
        
        users = []
        
        if addMember == false {
            db.child("usernames").observeSingleEvent(of: .value, with: { (snapshot) in
                self.users = []
                if let users = snapshot.value as? Dictionary<String, String> {
                    for user in users {
                        if user.key.contains(self.nameInput.text!) {
                            self.db.child("users").child(UserDefaults.standard.string(forKey: KEY_UID)!).child("friends").observeSingleEvent(of: .value, with: { (snapshot) in
                                var friends = Dictionary<String, String>()
                                if let exsFriends = snapshot.value as? Dictionary<String, String> {
                                    friends = exsFriends
                                }
                                var append = true
                                for friend in friends {
                                    if friend.key == user.value || user.value == UserDefaults.standard.string(forKey: KEY_UID) {
                                        append = false
                                    }
                                }
                                if(append == true) {
                                    self.users.append(User(uid: user.value, username: user.key))
                                }
                                self.tableView.reloadData()
                                
                            })
                        }
                    }
                }
                self.tableView.reloadData()
            })
        }
        
        
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row].username
        let cell = UITableViewCell(style: .default, reuseIdentifier: "userCell")
        cell.textLabel?.text = user
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if addMember == true {
            delegate?.memberAddedResponse(user: users[indexPath.row])
        } else {
            db.child("users").child(UserDefaults.standard.string(forKey: KEY_UID)!).child("friends").child(users[indexPath.row].uid).setValue(users[indexPath.row].username)
        }
        self.navigationController?.popViewController(animated: true)
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
