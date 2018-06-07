//
//  MembersViewController.swift
//  XTsplit
//
//  Created by Kevin Linne on 09.10.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import UIKit
import Firebase

class MembersViewController: UIViewController, AddMemberDelegate, UITableViewDelegate, UITableViewDataSource {

    var group: Group?
    var users = [User]()
    var userDict = Dictionary<String, String>()
    let db = FIRDatabase.database().reference()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tabCon = self.tabBarController as! GroupTabBarController
        group = tabCon.group
        
        tableView.delegate = self
        tableView.dataSource = self
        
        users = group!.participants!
        for user in users {
            userDict[user.uid] = user.username
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            self.tableView.contentInset = UIEdgeInsetsMake( y, 0, 0, 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(MembersViewController.addTapped(sender:))), animated: true)

    }
    
    func memberAddedResponse(user:User) {
        userDict[user.uid] = user.username
        users.append(user)
        if group != nil {
            db.child("groups").child(group!.groupKey).child("users").setValue(userDict)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "membersCell", for: indexPath)
        
        cell.textLabel?.text = users[indexPath.row].username
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func addTapped(sender: UIButton!) {
        self.performSegue(withIdentifier: "addUser", sender: sender)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "addUser":
                let addUserVC = segue.destination as? AddFriendViewController
                
                addUserVC?.delegate = self
                addUserVC?.addMember = true
            default: break
            }
        }

    }
 

}
