//
//  OrganizationCell.swift
//  OneDay
//
//  Created by Carl Henningsson on 3/28/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Firebase

class OrganizationCell: UITableViewCell {
    
    let imageViewView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "default-img")
        imgView.contentMode = .scaleAspectFill
        
        return imgView
    }()
    
    lazy var organizationName: UILabel = {
        let on = UILabel()
        on.text = "Rädda Barnen"
        on.font = UIFont(name: SF_MEDIUM, size: 24)!
        on.textColor = .white
        on.layer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
        on.layer.shadowOffset = CGSize(width: 4, height: 2)
        on.layer.shadowRadius = 5
        on.layer.shadowOpacity = 0.8
        
        return on
    }()
    
    var post: FeedPost!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(post: FeedPost, img: UIImage? = nil) {
        
        self.post = post
        self.organizationName.text = post.NAME
        
        if img != nil {
            self.imageViewView.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.IMAGEURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download image from Firebase Storage, \(String(describing: error?.localizedDescription))")
                } else {
                    if let imgData = data {
                        print("image downloaded")
                        if let img = UIImage(data: imgData) {
                            self.imageViewView.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.IMAGEURL as NSString)
                        }
                    }
                }
            })
        }
        
        addSubview(imageViewView)
        addSubview(organizationName)
        
        imageViewView.anchorToTop(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        _ = organizationName.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
