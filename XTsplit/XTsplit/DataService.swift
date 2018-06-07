//
//  DataService.swift
//  XTsplit
//
//  Created by Kevin Linne on 11.09.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let ds = DataService()
    
    var REF_BASE = FIRDatabase.database().reference()
    var REF_USERS = FIRDatabase.database().reference().child("users")
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        let uid = UserDefaults.standard.value(forKey: "uid") as! String
        return REF_USERS.child(uid)
    }
    
    func createFirebaseUser(_ uid: String, user: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(user)
    }

    
}
