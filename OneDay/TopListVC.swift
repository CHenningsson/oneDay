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
import Social

class TopListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var pp = 0
    
    let topTenLbl: UILabel = {
        let tt = UILabel()
        tt.text = "Topplistan"
        tt.font = UIFont(name: SF_MEDIUM, size: 30)!
        tt.textColor = PRIMARY_TEXT
        tt.textAlignment = .left
        
        return tt
    }()
    
    let closeBtn: UIButton = {
        let cBtn = UIButton(type: .custom)
        cBtn.setImage(UIImage(named: "closeBtn-new"), for: .normal)
        cBtn.addTarget(self, action: #selector(dismissTopList), for: .touchUpInside)
        
        return cBtn
    }()
    
    let points: UILabel = {
        let p = UILabel()
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
    
    let showWholeTopList: UILabel = {
        let swtt = UILabel()
        swtt.textColor = HINT_TEXT
        swtt.text = "Ta en screenshot och dela på Facebook eller Twitter"
        swtt.font = UIFont(name: SF_LIGHT, size: 15)!
        swtt.numberOfLines = 0
        swtt.textAlignment = .center
        
        return swtt
    }()
    
    let share: UIButton = {
        let sof = UIButton(type: .custom)
        sof.setImage(UIImage(named: "share-new"), for: .normal)
        sof.addTarget(self, action: #selector(shareToFacebook), for: .touchUpInside)
        
        return sof
    }()
    
    var topListPosts = [TopListPost]()
    var user = FIRAuth.auth()?.currentUser
    static var pointsUser: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            DataService.ds.REF_USERS.child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let point = value?["points"] as? Int
                self.pp = point!
                self.points.text = "Dina Poäng: \(self.pp)p"
                print("Kal: \(self.pp)")
            })
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(closeBtn)
        view.addSubview(topTenLbl)
        view.addSubview(points)
        view.addSubview(seperator)
        view.addSubview(showWholeTopList)
        view.addSubview(share)
        
        let rightConstant = view.frame.width / 4 - 25
        
        _ = closeBtn.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 50, heightConstant: 50)
        _ = topTenLbl.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 40, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = points.anchor(topTenLbl.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = seperator.anchor(points.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 1)
        _ = tableView.anchor(seperator.bottomAnchor, left: view.leftAnchor, bottom: showWholeTopList.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 10, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        _ = showWholeTopList.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 20, bottomConstant: 20, rightConstant: 20, widthConstant: view.frame.width / 2, heightConstant: 50)
        _ = share.anchor(nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: rightConstant, widthConstant: 50, heightConstant: 50)
    }
    
    func shareToFacebook() {
        
        let alert = UIAlertController(title: "Dela", message: "Dela dina poäng med dina vänner!", preferredStyle: .actionSheet)
        
        let actionFacebook = UIAlertAction(title: "Dela på Facebook", style: .default) { (action) in
            
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                post?.add(URL(string: "https://itunes.apple.com/se/app/oneday-microdonate/id1220479316?l=en&mt=8"))
                
                self.present(post!, animated: true, completion: nil)
        
            } else {
                self.showAlertError(service: "Facebook")
            }
        }
        
        let actionTwitter = UIAlertAction(title: "Dela på Twitter", style: .default) { (action) in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                post?.setInitialText("Jag har nu \(self.pp) poäng! Hur många har du? \n\nhttps://itunes.apple.com/se/app/oneday-microdonate/id1220479316?l=en&mt=8")
                
                self.present(post!, animated: true, completion: nil)
            } else {
                self.showAlertError(service: "Twitter")
            }
        }
        
        let actionCancel = UIAlertAction(title: "Avbryt", style: .cancel, handler: nil)
        
        alert.addAction(actionFacebook)
        alert.addAction(actionTwitter)
        alert.addAction(actionCancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertError(service: String) {
    
        let alert = UIAlertController(title: "Error", message: "Du är inte kopplad till \(service), gå till telefonens inställningar för att koppla upp dig.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    
    }
 
    func dismissTopList() {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if currentReachabilityStatus != .notReachable {
            if user != nil {
                return 1
            } else {
                messageForUser(message: "Anslut med Facebook, för att se topplisan. ", viewController: self)
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
