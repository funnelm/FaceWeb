//
//  DataService.swift
//  FaceWeb
//
//  Created by Mark Funnell on 11/7/16.
//  Copyright © 2016 Mark Funnell. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper


let DB_BASE = FIRDatabase.database().reference()
let STORE_BASE = FIRStorage.storage().reference()



class DataService {
    
    //Singleton - instance of a class thats globally accessible but only 1 instance
    //Global = FULL CAPS :)
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    private var _REF_POST_IMAGES = STORE_BASE.child("postPics")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
         
        let user = REF_USERS.child(uid!)
        
        return user
        
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    
    
}
