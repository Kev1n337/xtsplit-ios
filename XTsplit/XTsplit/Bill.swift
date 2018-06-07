//
//  Bill.swift
//  XTsplit
//
//  Created by Kevin Linne on 02.10.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import Foundation
import Firebase

class Bill {
    private var _billKey: String!
    private var _date: Date!
    private var _name: String!
    private var _payer: User!
    private var _receiver: [User]!
    private var _value: Double!
    
    var date: Date {
        return _date
    }

    var name: String {
        return _name
    }
    
    var payer: User {
        return _payer
    }
    
    var receiver: [User] {
        return _receiver
    }
    
    var value: Double {
        return _value
    }
    
    init(billKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._billKey = billKey
        
        if let name = dictionary["name"] as? String {
            self._name = name
        }
        
        if let payer = dictionary["payer"] as? String {
            let ref = FIRDatabase.database().reference()
            ref.child("usernames").observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? Dictionary<String, String> {
                    for (uid, username) in value {
                        if(uid == payer) {
                            self._payer = User(uid: uid, username: username)
                        }
                    }
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        if let date = dictionary ["date"] as? String {
            self._date = Date(dateString: date)
        }
        
        if let receiver = dictionary["receiver"] as? Dictionary<String, String> {
            _receiver = []
            
            for (uid, username) in receiver {
                self._receiver.append(User(uid: uid, username: username))
            }
        }

        if let value = dictionary["value"] as? Double {
            self._value = value
        }
    }
}
