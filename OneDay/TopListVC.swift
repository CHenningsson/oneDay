//
//  TopListVC.swift
//  OneDay
//
//  Created by Carl Henningsson on 3/28/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class TopListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let topTenLbl: UILabel = {
        let tt = UILabel()
        tt.text = "Topp 10"
        tt.font = UIFont(name: SF_MEDIUM, size: 30)!
        tt.textColor = PRIMARY_TEXT
        tt.textAlignment = .left
        
        return tt
    }()
    
    let closeBtn: UIButton = {
        let cBtn = UIButton(type: .custom)
        cBtn.setImage(UIImage(named: "closeBtn"), for: .normal)
        cBtn.addTarget(self, action: #selector(dismissTopList), for: .touchUpInside)
        
        return cBtn
    }()
    
    let points: UILabel = {
        let p = UILabel()
        p.text = "Dina Poäng: \(FeedVC.localPoints)p"
        p.font = UIFont(name: SF_REGULAR, size: 17)!
        p.textColor = SECONDARY_TEXT
        p.textAlignment = .left
        
        return p
    }()
    
    let seperator: UIView = {
        let s = UIView()
        s.backgroundColor = HINT_TEXT
        
        return s
    }()
    
    let showWholeTopList: UIButton = {
        let swtt = UIButton(type: .system)
        swtt.tintColor = HINT_TEXT
        swtt.setTitle("Visa Hela Topp Listan", for: .normal)
        swtt.titleLabel?.font = UIFont(name: SF_LIGHT, size: 15)!
        swtt.addTarget(self, action: #selector(showTopList), for: .touchUpInside)
        
        return swtt
    }()
    
    let shareOnFacebook: UIButton = {
        let sof = UIButton(type: .custom)
        sof.setImage(UIImage(named: "fb-logo"), for: .normal)
        sof.addTarget(self, action: #selector(loginToFacebook), for: .touchUpInside)
        
        return sof
    }()
    
    var topListPosts = [TopListPost]()
    var user = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(closeBtn)
        view.addSubview(topTenLbl)
        view.addSubview(points)
        view.addSubview(seperator)
        view.addSubview(showWholeTopList)
        view.addSubview(shareOnFacebook)
        
        let rightConstant = view.frame.width / 4 - 25
        
        _ = closeBtn.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 50, heightConstant: 50)
        _ = topTenLbl.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 40, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = points.anchor(topTenLbl.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = seperator.anchor(points.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 1)
        _ = tableView.anchor(seperator.bottomAnchor, left: view.leftAnchor, bottom: showWholeTopList.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 10, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        _ = showWholeTopList.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 20, widthConstant: view.frame.width / 2, heightConstant: 50)
        _ = shareOnFacebook.anchor(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: rightConstant, widthConstant: 50, heightConstant: 50)
        
            if currentReachabilityStatus != .notReachable {
                DataService.ds.REF_USERS.queryOrdered(byChild: "points").observe(.value, with: { (snapshot) in
                    self.topListPosts = []
                    if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        for snap in snapshot {
                            if let postDict = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                let post = TopListPost(postKey: key, postData: postDict)
                                self.topListPosts.append(post)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }, withCancel: nil)
            }
        
        tableView.isScrollEnabled = false
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil  {
                self.tableView.reloadData()
                print("Kal:")
            }
        }
    }
    
    func loginToFacebook() {
        
        if user != nil {
            print("Kal: User is sign in")
        } else {
            let facebookLogin = FBSDKLoginManager()
            facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
                if error != nil {
                    print("Kal: Unable to authenticate with Facebook - \(error)")
                } else if result?.isCancelled == true {
                    print("Kal: User cancelled authentication")
                } else {
                    print("Kal: Successfully authenticated with Facebook")
                    let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    self.firebaseAuth(credential)
                }
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Kal: Unable to authenticate with Firebase - \(error)")
            } else {
                print("Kal: Successfully authenticated with Firebase")
//                self.userCreatedFacebook()
            }
        })
    }
    
    func userCreatedFacebook() {
        let user: Dictionary<String, AnyObject> = [
            "displayName": self.user!.displayName! as AnyObject,
            "points": FeedVC.localPoints as AnyObject
        ]
        let firebaseUser = DataService.ds.REF_BASE.child("users").childByAutoId()
        firebaseUser.setValue(user)
    }
    
    func dismissTopList() {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if currentReachabilityStatus != .notReachable {
            if user != nil {
                return 1
            } else {
                messageForUser(message: "Anslut med Facebook, för att se topp lisan. ", viewController: self)
                return 0
            }
        } else {
            messageForUser(message: "Koppla upp dig till Internet, för att se topp listan.", viewController: self)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topListPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = topListPosts.reversed()[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? TopListCell {
            cell.configureTopListCell(post: post)
            return cell
        } else {
            return TopListCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
    }
    
    func showTopList() {
        tableView.isScrollEnabled = true
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
