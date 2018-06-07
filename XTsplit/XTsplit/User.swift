//
//  User.swift
//  XTsplit
//
//  Created by Kevin Linne on 13.09.16.
//  Copyright © 2016 Kevin Linne. All rights reserved.
//

import Foundation
import Firebase

class User: Hashable, Equatable {
    var username: String
    var uid: String
    
    init(uid: String, username: String) {
        self.username = username
        self.uid = uid
    }
    
    
    var hashValue: Int {
        get {
            return uid.hashValue
        }
    }
}


func ==(lhs: User, rhs: User) -> Bool {
    return lhs.uid == rhs.uid
}
