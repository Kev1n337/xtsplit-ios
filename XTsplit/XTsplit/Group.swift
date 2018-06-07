//
//  Group.swift
//  XTsplit
//
//  Created by Kevin Linne on 13.09.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Group {
    
    private var _participants: [User]!
    private var _name: String!
    private var _bills: [Bill]?
    private var _color: UIColor!
    private var _groupKey: String!
    private var _groupRef: FIRDatabaseReference!
    
    var participants: [User]? {
        return _participants
    }
    
    var name: String {
        return _name
    }
    
    var bills: [Bill]? {
        return _bills
    }
    
    var color: UIColor {
        return _color
    }
    
    var groupKey: String {
        return _groupKey
    }
    
    init(groupKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._groupKey = groupKey
        
        if let name = dictionary["name"] as? String {
            self._name = name
        }
        
        if let color = dictionary["color"] as? String {
            switch color {
            case "red":
                _color = UIColor(hex:0xD02A2B)
            case "blue":
                _color = UIColor(hex: 0x0664FF)
            case "green":
                _color = UIColor(hex: 0x13B04F)
            case "purple":
                _color = UIColor(hex: 0xA62CAF)
            case "pink":
                _color = UIColor(hex: 0xE32F66)
            case "light-green":
                _color = UIColor(hex: 0x45DC00)
            default:
                _color = UIColor.gray
            }
        }
        if let bills = dictionary["bills"] as? Dictionary<String, AnyObject> {
            _bills = []
            for bill in bills {
                self._bills!.append(Bill(billKey: bill.key, dictionary: bill.value as! Dictionary<String, AnyObject>))
            }
        }
        
        if let users = dictionary["users"] as? Dictionary<String, String> {
            _participants = []
            
            for (uid, username) in users {
                self._participants.append(User(uid: uid, username: username))
            }
        }
        
        self._groupRef = FIRDatabase.database().reference().child("groups").child(_groupKey)
    }
    
    func calculateSum() -> Double {
        var sum = 0.0
        if let bills = bills {
            for bill in bills{
                sum += bill.value
            }
        }
        
        return sum
    }
}
