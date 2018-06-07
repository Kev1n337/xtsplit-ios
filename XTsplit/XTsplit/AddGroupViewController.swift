//
//  AddGroupViewController.swift
//  XTsplit
//
//  Created by Kevin Linne on 06.10.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import UIKit
import Firebase

class AddGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    enum Color {
        case red
        case green
        case purple
        case blue
        case pink
        case lightGreen
    }
    
    var currentColor: Color = .red
    var friendsDict = Dictionary<String, String>()
    let db = FIRDatabase.database().reference()

    @IBOutlet weak var groupNameInput: PaddingTextField!
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var pinkButton: UIButton!
    @IBOutlet weak var lightGreenButton: UIButton!
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsTableView.reloadData()
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        friendsTableView.tableFooterView = UIView()
        
        groupNameInput.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        db.child("users").child(UserDefaults.standard.string(forKey: KEY_UID)!).child("friends").observe(.value, with: { (snapshot) in
            if let myFriendsDict = snapshot.value as? [String : String] {
                self.friendsDict = myFriendsDict
                self.friendsTableView.reloadData()
            }
            
        })
        
        friendsTableView.allowsMultipleSelectionDuringEditing = true
        friendsTableView.setEditing(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.groupNameInput {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func redPressed(_ sender: AnyObject) {
        checkColor(color: .red)
        currentColor = .red
    }
    @IBAction func bluePressed(_ sender: AnyObject) {
        checkColor(color: .blue)
        currentColor = .blue
    }
    @IBAction func greenPressed(_ sender: AnyObject) {
        checkColor(color: .green)
        currentColor = .green
    }
    @IBAction func purplePressed(_ sender: AnyObject) {
        checkColor(color: .purple)
        currentColor = .purple
    }
    @IBAction func pinkPressed(_ sender: AnyObject) {
        checkColor(color: .pink)
        currentColor = .pink
    }
    @IBAction func lightGreenPressed(_ sender: AnyObject) {
        checkColor(color: .lightGreen)
        currentColor = .lightGreen
    }
    
    func checkColor(color: Color) {
        redButton.setImage(UIImage(named: "red.png"), for: .normal)
        blueButton.setImage(UIImage(named: "blue.png"), for: .normal)
        greenButton.setImage(UIImage(named: "green.png"), for: .normal)
        purpleButton.setImage(UIImage(named: "purple.png"), for: .normal)
        pinkButton.setImage(UIImage(named: "pink.png"), for: .normal)
        lightGreenButton.setImage(UIImage(named: "light-green.png"), for: .normal)
        
        switch color {
        case .red: redButton.setImage(UIImage(named: "red-checked.png"), for: .normal)
        case .blue: blueButton.setImage(UIImage(named: "blue-checked.png"), for: .normal)
        case .green: greenButton.setImage(UIImage(named: "green-checked.png"), for: .normal)
        case .purple: purpleButton.setImage(UIImage(named: "purple-checked.png"), for: .normal)
        case .pink: pinkButton.setImage(UIImage(named: "pink-checked.png"), for: .normal)
        case .lightGreen: lightGreenButton.setImage(UIImage(named: "light-green-checked.png"), for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsDict.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var friendsArray = Array(friendsDict.values)
        let friend = friendsArray[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "friendCell")
        cell.textLabel?.text = friend
        
        return cell
    }
    
    
    
    func colorString(color: Color) -> String {
        switch color {
        case .red: return "red"
        case .blue: return "blue"
        case .green: return "green"
        case .purple: return "purple"
        case .pink: return "pink"
        case .lightGreen: return "light-green"
        }
    }
    
    func isValid(name: String) -> Bool {
        return true
    }
    

    @IBAction func createGroupPressed(_ sender: AnyObject) {
        if let indexPaths = friendsTableView.indexPathsForSelectedRows {
            var selectedFriendsDict = Dictionary<String, String>()
            var selectedFriendsIds = Array(friendsDict.keys)
            var selectedFriendsNames = Array(friendsDict.values)
            for path in indexPaths {
                selectedFriendsDict.updateValue(selectedFriendsNames[path.row], forKey: selectedFriendsIds[path.row])
            }
            selectedFriendsDict.updateValue(UserDefaults.standard.string(forKey: KEY_USERNAME)!, forKey: UserDefaults.standard.string(forKey: KEY_UID)!)
            
            
            db.child("users").child("id")
            
            
            if isValid(name: groupNameInput.text!) {
                let finalDict: Dictionary<String, Any> = [
                    "name": groupNameInput.text!,
                    "color": colorString(color: currentColor),
                    "users": selectedFriendsDict
                ]
                
                db.child("groups").childByAutoId().setValue(finalDict, withCompletionBlock: { (err, ref) in
                    if err != nil {
                        print(err?.localizedDescription)
                    } else {
                        for user in selectedFriendsDict {
                            self.db.child("users").child(user.key).child("groups").child(ref.key).setValue(true)
                        }
                    }
                    
                })
            }
            
            self.performSegue(withIdentifier: "groupAdded", sender: nil)
            
        }
        
    }
    
    
}
