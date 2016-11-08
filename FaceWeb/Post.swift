//
//  Post.swift
//  FaceWeb
//
//  Created by Mark Funnell on 11/7/16.
//  Copyright © 2016 Mark Funnell. All rights reserved.
//

import Foundation
import Firebase


class Post {
    
    private var _caption: String!
    private var _imageurl: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }
    
    var imageurl: String {
        return _imageurl
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageurl: String, likes: Int) {
        
        self._caption = caption
        self._imageurl = imageurl
        self._likes = likes
        
        
    }
    
    init(postKey: String, postData: Dictionary<String, Any>) {
        
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String {
            
            self._caption = caption
            
        }
        
        if let imageurl = postData["imageurl"] as? String {
            
            self._imageurl = imageurl
            
        }
        
        if let likes = postData["likes"] as? Int {
            
            self._likes = likes
            
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
    }
    
    func adjustLikes(addLike: Bool) {
        
        if addLike {
            
            _likes = _likes + 1
            
        } else {
            
            _likes = likes - 1
    
        }
        
        _postRef.child("likes").setValue(_likes)
        
    }
}
