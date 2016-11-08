//
//  FeedVC.swift
//  FaceWeb
//
//  Created by Mark Funnell on 11/6/16.
//  Copyright © 2016 Mark Funnell. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signOutTapped: UIButton!
    
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
            
            print(snapshot.value)
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshot {
                    print("SNAP:\(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String,Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                    
                }
                
            }
            self.tableView.reloadData()
            
        })
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imageAdd: CircleView!
    
    @IBAction func addImageTapped(_ sender: Any) {
        
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            imageAdd.image = image
            
        } else {
            
            print("MF: Valid image was not selected")
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        //print("MF:\(post.caption)")
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UITVC") as? UITVC {
            
            if let img = FeedVC.imageCache.object(forKey: post.imageurl as NSString) {
                
                cell.configureCell(post: post, img: img)
                return cell
            } else {
                cell.configureCell(post: post, img: nil)
                return cell
            }
        
        } else {
            
            return UITVC()
            
        }

        
        //return tableView.dequeueReusableCell(withIdentifier: "UITVC") as! UITVC
        
    }
    
    
    
    @IBAction func SignOutPressed(_ sender: Any) {
  
        let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: "SignOut", sender: nil)
        
    }
   
    
    @IBAction func signOutTapped(_ sender: Any) {
        
        let removeSuccessful: Bool = KeychainWrapper.standard.remove(key: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        
        performSegue(withIdentifier: "SignOut", sender: nil)
        
    }
    
    @IBAction func SignOutClick(_ sender: Any) {
    }


}
