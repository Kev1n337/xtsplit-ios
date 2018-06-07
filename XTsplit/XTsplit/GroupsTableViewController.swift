//
//  GroupsTableViewController.swift
//  XTsplit
//
//  Created by Kevin Linne on 02.10.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import UIKit
import Firebase

class GroupsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var usersLabel: UILabel!
    @IBOutlet weak var sum: UILabel!
    
    var groups = [Group]()
    let db = FIRDatabase.database().reference()
    var selectedGroup = -1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db.child("users").child(UserDefaults.standard.string(forKey: KEY_UID)!).child("groups").observe(.value, with: { (snapshot) in
            
            if let myGroupsDict = snapshot.value as? [String : Bool] {
                let groupsArray = Array(myGroupsDict.keys)
                
                self.db.child("groups").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        self.groups = []
                        for snap in snapshots {
                            if let groupsDict = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                if groupsArray.contains(key) {
                                    let group = Group(groupKey: key, dictionary: groupsDict)
                                    self.groups.append(group)
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                })
            }
        
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "groupDetail", sender: self.tableView.cellForRow(at: indexPath))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groups[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as? GroupCell {
            cell.configureCell(group: group)
            return cell
        } else {
            return GroupCell()
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            switch identifier {
            case "groupDetail":
                let groupDetailVC = segue.destination as? GroupTabBarController
                if let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell) {
                    groupDetailVC?.group = groups[indexPath.row]
                }
                
            default: break
                
            }
        }
    }
 

}
