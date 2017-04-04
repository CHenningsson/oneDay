//
//  FeedVC.swift
//  OneDay
//
//  Created by Carl Henningsson on 3/28/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.activityIndicatorViewStyle = .gray
        
        return ai
    }()
    
    static var localPoints: Int = 390
    
    var feedPosts = [FeedPost]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "\(FeedVC.localPoints) p"
        
        view.addSubview(activityIndicator)
        _ = activityIndicator.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        activityIndicator.stopAnimating()
        
        if currentReachabilityStatus != .notReachable {
        
            DataService.ds.REF_ORGANIZATIONS.observe(.value, with: { (snapshot) in
            
                self.feedPosts = []
            
                if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshot {
                        if let postDict = snap.value as? Dictionary<String, AnyObject> {
                            let key = snap.key
                            let post = FeedPost(POSTKEY: key, postData: postDict)
                            self.feedPosts.append(post)
                        }
                    }
                }
                self.tableView.reloadData()
            }, withCancel: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if currentReachabilityStatus != .notReachable {
            if feedPosts.count > 0 {
                activityIndicator.stopAnimating()
                return 1
            } else {
                return 0
            }
        } else {
            messageForUser(message: "Please Connect To The Internet.", viewController: self)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = feedPosts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? OrganizationCell {
            if let img = FeedVC.imageCache.object(forKey: post.IMAGEURL as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return OrganizationCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 4
    }
    
    func messageForUser(message: String, viewController: UIViewController) {
    
        let messageLbl = UILabel(frame: CGRect(x: 20, y: 0, width: view.frame.width - 40, height: view.frame.height))
        messageLbl.text = message
        messageLbl.textColor = HINT_TEXT
        messageLbl.textAlignment = .center
        messageLbl.numberOfLines = 0
        messageLbl.font = UIFont(name: SF_LIGHT, size: 18)!
        
        self.tableView.backgroundView = messageLbl
        self.tableView.separatorStyle = .none
    }
}
