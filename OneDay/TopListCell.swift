//
//  TopListCell.swift
//  OneDay
//
//  Created by Carl Henningsson on 3/30/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Firebase

class TopListCell: UITableViewCell {
    
    let topListName: UILabel = {
        let ttn = UILabel()
        ttn.text = "Carl Henningsson"
        ttn.textAlignment = .left
        ttn.font = UIFont(name: SF_REGULAR, size: 15)!
        ttn.adjustsFontSizeToFitWidth = true
        ttn.textColor = SECONDARY_TEXT
        
        return ttn
    }()
    
    let topListPoints: UILabel = {
        let tpn = UILabel()
        tpn.text = "390p"
        tpn.textAlignment = .right
        tpn.font = UIFont(name: SF_REGULAR, size: 15)!
        tpn.adjustsFontSizeToFitWidth = true
        tpn.textColor = SECONDARY_TEXT
        
        return tpn
    }()
    
    let seperator: UIView = {
        let s = UIView()
        s.backgroundColor = DIVIDERS
       
        return s
    }()
    
    var post: TopListPost!
    var user = FIRAuth.auth()?.currentUser
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureTopListCell(post: TopListPost) {
        
        self.post = post
        self.topListName.text = post.displayName
        self.topListPoints.text = "\(post.points)p"
        
        if self.topListName.text == user!.displayName {
            self.topListName.font = UIFont(name: SF_SEMIBOLD, size: 15)!
            self.topListName.textColor = logoBlue
            self.topListPoints.font = UIFont(name: SF_SEMIBOLD, size: 15)!
            self.topListPoints.textColor = logoBlue
        } else {
            print("Kal: user does not exist!")
        }
        
        addSubview(topListName)
        addSubview(topListPoints)
        addSubview(seperator)
        
        _ = topListName.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = topListPoints.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = seperator.anchor(topListName.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
    }
}
