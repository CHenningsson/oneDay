//
//  LanchScreen.swift
//  OneDay
//
//  Created by Carl Henningsson on 3/30/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Firebase

class LanchScreen: UIViewController {

    let logo: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "logo")
        img.contentMode = .scaleAspectFill
        img.alpha = 0
        
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//                let firebaseAuth = FIRAuth.auth()
//                do {
//                    try firebaseAuth?.signOut()
//                } catch let signOutError as NSError {
//                    print ("Error signing out: %@", signOutError)
//                }
        
        view.addSubview(logo)
        _ = logo.anchor(view.centerYAnchor, left: view.centerXAnchor, bottom: nil, right: nil, topConstant: -100, leftConstant: -100, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 200)
        animateLogo()
    }
    
    func animateLogo() {
        
        UIView.animate(withDuration: 1, animations: {
            
            self.logo.frame = CGRect(x: -100, y: -100, width: 200, height: 200)
            self.logo.alpha = 1
            
        }) { (true) in
            
            UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let x: CGFloat = self.view.frame.width / 2
                let y: CGFloat = self.view.frame.height / 2
                
                self.logo.frame = CGRect(x: x, y: y, width: 0, height: 0)
                self.logo.alpha = 0
                
            }) { (true) in
                
                if FIRAuth.auth()?.currentUser != nil {
                    self.performSegue(withIdentifier: SEUGE_FEEDVC, sender: nil)
                } else {
                    self.performSegue(withIdentifier: SEUGE_ACCUONT_CREATED, sender: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sac" {
            if let newVC = segue.destination as? AccountCreated {
                newVC.segueDismiss = false
            }
        }
    }
}
