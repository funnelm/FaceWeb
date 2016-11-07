//
//  DataService.swift
//  FaceWeb
//
//  Created by Mark Funnell on 11/7/16.
//  Copyright © 2016 Mark Funnell. All rights reserved.
//

import Foundation
import Firebase


let DB_BASE = FIRDatabase.database().reference()



class DataService {
    
    //Singleton - instance of a class thats globally accessible but only 1 instance
    //Global = FULL CAPS :)
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    
    
}
