//
//  AddBillViewController.swift
//  XTsplit
//
//  Created by Kevin Linne on 11.10.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import UIKit
import Eureka
import Firebase

protocol AddBillDelegate {
    func billAddedResponse(bill:Bill)
}


class AddBillViewController: FormViewController {
    
    var delegate: AddBillDelegate?
    var groupKey: String?
    let db = FIRDatabase.database().reference()
    
    var users = [User]()
    var usernames = [String]()
    
    override func viewDidLayoutSubviews() {
        if let rect = self.navigationController?.navigationBar.frame {
            let y = rect.size.height + rect.origin.y
            self.tableView?.contentInset = UIEdgeInsetsMake( y, 0, 0, 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(BillsViewController.addTapped(sender:))), animated: true)
        //self.tabBarController?.navigationItem.setRightBarButton(UIBarButtonItem(title: "Hinzufügen", style: .done, target: self, action: nil), animated: true)
        self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Hinzufügen", style: .done, target: self, action: #selector(AddBillViewController.addTapped(sender:))), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.child("groups").child(groupKey!).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let users = snapshot.value as? Dictionary<String, String> {
                for user in users {
                    self.users.append(User(uid: user.key, username: user.value))
                    self.usernames.append(user.value)
                }
                self.initializeForm()
            }
        })
        
        
        
    }
    
    func initializeForm() {
        form = Section()
            <<< TextRow(){
                $0.title = "Titel"
                $0.placeholder = "Rechnungstitel"
                $0.tag = "title"
                $0.validationOptions = .validatesOnChangeAfterBlurred
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleMaxLength(maxLength: 12))
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< DecimalRow(){
                $0.title = "Betrag"
                $0.placeholder = "Wie teuer war die Rechnung?"
                $0.tag = "amount"
                $0.validationOptions = .validatesOnDemand
                $0.add(rule: RuleGreaterThan(min: 0))
                $0.add(rule: RuleRequired())
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            
            +++ Section()
            <<< DateInlineRow(){
                $0.title = "Datum"
                $0.value = Date()
                $0.tag = "billDate"
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        //cell.titleLabel?.textColor = .red
                        cell.textLabel?.textColor = .red
                    }
            }
            <<< PickerInlineRow<String>(){
                $0.title = "Bezahler"
                $0.options = usernames
                $0.tag = "payer"
                $0.validationOptions = .validatesOnDemand
                $0.add(rule: RuleRequired())
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.textLabel?.textColor = .red
                    }
            }
            
            +++ SelectableSection<ListCheckRow<String>>("Beteiligte", selectionType: .multipleSelection) { section in
                section.tag = "receiver"
            }
            
        for user in usernames {
            form.last! <<< ListCheckRow<String>(){
                $0.title = user
                $0.selectableValue = user
                $0.value = nil
            }
        }
            
            form +++ Section()
            <<< TextAreaRow(){
                $0.tag = "notes"
                $0.title = "Notizen"
                $0.placeholder = "Notizen"
        }
    }
    
    func addTapped(sender: UIButton!) {
        
        var billDict = Dictionary<String, Any>()
        
        if let title = form.rowBy(tag: "title")?.baseValue {
            billDict["name"] = title
        }
        if let amount = form.rowBy(tag: "amount")?.baseValue {
            billDict["value"] = amount
        }
        if let date = form.rowBy(tag: "billDate")?.baseValue {
            /*
                TODO: Format date
            */
            print("\(date)")
        }
        if let payer = form.rowBy(tag: "payer")?.baseValue {
            billDict["payer"] = payer
        }
        if let notes = form.rowBy(tag: "notes")?.baseValue {
            billDict["notes"] = notes
        }
        
        let receiverSection = form.sectionBy(tag: "receiver") as? SelectableSection<ListCheckRow<String>>
        let receiver = receiverSection!.selectedRows()
        var billReceiver = Dictionary<String, String>()
        if receiver.count > 0 {
            db.child("usernames").observeSingleEvent(of: .value, with: { (snapshot) in
                if let usernames = snapshot.value as? Dictionary<String, String> {
                    for rec in receiver {
                        for user in usernames {
                            if rec.value == user.key {
                                billReceiver[user.value] = user.key
                            }
                        }
                    }
                    
                    billDict["receiver"] = billReceiver
                    
                    self.db.child("groups").child(self.groupKey!).child("bills").childByAutoId().setValue(billDict, withCompletionBlock: { (err, reference) in
                        if err != nil {
                            print(err?.localizedDescription)
                        } else {
                            self.delegate?.billAddedResponse(bill: Bill(billKey: reference.key, dictionary: billDict as Dictionary<String, AnyObject>))
                            self.navigationController?.popViewController(animated: true)
                        }
                    })
                }
            })
        }
        
        
        
        
        if form.validate().count == 0 {
            
        }
        
        //self.performSegue(withIdentifier: "addBill", sender: sender)
    }
    
}
