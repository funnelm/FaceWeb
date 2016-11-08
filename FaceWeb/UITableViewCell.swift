//
//  UITableViewCell.swift
//  FaceWeb
//
//  Created by Mark Funnell on 11/6/16.
//  Copyright © 2016 Mark Funnell. All rights reserved.
//

import UIKit
import Firebase

class UITVC: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likes: UILabel!

    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func configureCell(post: Post, img: UIImage? = nil) {
        
        self.post = post
        self.caption.text = post.caption
        self.likes.text = "\(post.likes)"
        
        if img != nil {
            
            self.postImage.image = img
            
        } else {
                
            let ref = FIRStorage.storage().reference(forURL: post.imageurl)
                
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                
                if error != nil {
                    
                    print("MF: Unable to dl img from Firebase")
                    
                } else {
                    
                    print("MF: Image dl from Firebase")
                    
                    if let imgData = data {
                        
                        if let actualImg = UIImage(data: imgData) {
                            
                            self.postImage.image = actualImg
                            FeedVC.imageCache.setObject(actualImg, forKey: post.imageurl as NSString)
                            
                        }
                        
                    }
                    
                }
                 
            })
                    
        }
        
    }
    

}
