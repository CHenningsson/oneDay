//
//  AccountCreated.swift
//  OneDay
//
//  Created by Carl Henningsson on 4/9/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class AccountCreated: UIViewController {
    
    //När användaren har sett tut
    let FBTitle: UILabel = {
        let fbT = UILabel()
        fbT.text = "För att samla poäng och se topplistan behöver du verifiera dig med Facebook. Klicka på Facebook loggan för verifiering."
        fbT.textColor = HINT_TEXT
        fbT.textAlignment = .center
        fbT.font = UIFont(name: SF_LIGHT, size: 20)!
        fbT.numberOfLines = 0
        
        return fbT
    }()
    
    let seccondTex: UILabel = {
        let st = UILabel()
        st.text = "Ingen verifiering behövs för att donera. Klicka på \"hoppa över\" för att komma vidare."
        st.textAlignment = .center
        st.textColor = SECONDARY_TEXT
        st.numberOfLines = 0
        st.font = UIFont(name: SF_ULTRALIGHT, size: 20)!
        
        return st
    }()
    
    let login: UIButton = {
        let l = UIButton(type: .custom)
        l.setImage(UIImage(named: "fb-logo"), for: .normal)
        l.addTarget(self, action: #selector(loginToFacebook), for: .touchUpInside)
        
        return l
    }()
    
    let skipBtn: UIButton = {
        let sBtn = UIButton(type: .custom)
        sBtn.setTitle("Hoppa över", for: .normal)
        sBtn.setTitleColor(HINT_TEXT, for: .normal)
        sBtn.titleLabel?.font = UIFont(name: SF_LIGHT, size: 17)!
        sBtn.addTarget(self, action: #selector(skipFBValidation), for: .touchUpInside)
        
        return sBtn
    }()
    
    //Koden för tut
    let titleText: UILabel = {
        let tt = UILabel()
        tt.text = "Hur funkar OneDay?"
        tt.textAlignment = .center
        tt.font = UIFont(name: SF_REGULAR, size: 24)!
        tt.textColor = logoBlue
        
        return tt
    }()
    
    
    let pointOne: UILabel = {
        let po = UILabel()
        po.text = "1. Välj den biståndsorganisation som du vill donera till."
        po.textColor = SECONDARY_TEXT
        po.font = UIFont(name: SF_LIGHT, size: 17)!
        po.numberOfLines = 0
        po.textAlignment = .center
        
        return po
    }()
    
    let pointTwo: UILabel = {
        let pt = UILabel()
        pt.text = "2. Välj mellan de fyra micro-belopp som presenteras och samla poäng."
        pt.textColor = SECONDARY_TEXT
        pt.font = UIFont(name: SF_LIGHT, size: 17)!
        pt.numberOfLines = 0
        pt.textAlignment = .center
        
        return pt
    }()
    
    let pointThree: UILabel = {
        let pt = UILabel()
        pt.text = "3. Jämför dina poäng med din omgivning och se vem som har donerat mest till välgörenhet med hjälp av topplistan."
        pt.textColor = SECONDARY_TEXT
        pt.font = UIFont(name: SF_LIGHT, size: 17)!
        pt.numberOfLines = 0
        pt.textAlignment = .center
        
        return pt
    }()
    
    let moveOn: UIButton = {
        let mo = UIButton(type: .custom)
        mo.setTitle("Gå Vidare", for: .normal)
        mo.tintColor = .white
        mo.titleLabel?.font = UIFont(name: SF_REGULAR, size: 20)!
        mo.titleLabel?.textAlignment = .center
        mo.layer.cornerRadius = 25.0
        mo.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        mo.layer.shadowOpacity = 1
        mo.layer.shadowRadius = 5.0
        mo.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        mo.backgroundColor = logoBlue
        mo.addTarget(self, action: #selector(moveOnBtn), for: .touchUpInside)
        
        return mo
    }()
    
    var segueDismiss: Bool = true
    var user = FIRAuth.auth()?.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let marginLeft = view.frame.width / 4
        let topMargin = view.frame.height / 6

        view.addSubview(FBTitle)
        view.addSubview(seccondTex)
        view.addSubview(login)
        view.addSubview(skipBtn)
        
        view.addSubview(titleText)
        view.addSubview(pointOne)
        view.addSubview(pointTwo)
        view.addSubview(pointThree)
        view.addSubview(moveOn)
        
        _ = FBTitle.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: topMargin, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 0)
        _ = seccondTex.anchor(FBTitle.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 0)
        _ = login.anchor(seccondTex.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 40, leftConstant: marginLeft - 37.5, bottomConstant: 0, rightConstant: 0, widthConstant: 75, heightConstant: 75)
        _ = skipBtn.anchor(seccondTex.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: marginLeft, widthConstant: 0, heightConstant: 75)
        
        _ = titleText.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 40, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        _ = pointOne.anchor(titleText.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        _ = pointTwo.anchor(pointOne.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        _ = pointThree.anchor(pointTwo.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 15, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        _ = moveOn.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 20, rightConstant: 20, widthConstant: 0, heightConstant: 50)
        
        FBTitle.alpha = 0
        seccondTex.alpha = 0
        login.alpha = 0
        skipBtn.alpha = 0
        
    }
    
    func moveOnBtn() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            
            self.titleText.alpha = 0
            self.pointOne.alpha = 0
            self.pointTwo.alpha = 0
            self.pointThree.alpha = 0
            self.moveOn.alpha = 0
            
        }) { (true) in
            
            self.FBTitle.alpha = 1
            self.seccondTex.alpha = 1
            self.login.alpha = 1
            self.skipBtn.alpha = 1
            
        }
        
    }
    
    func skipFBValidation() {
        if segueDismiss == false {
            performSegue(withIdentifier: SEUGE_DONE, sender: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func loginToFacebook() {
        if user != nil {
            print("Kal: User is sign in")
        } else {
            let facebookLogin = FBSDKLoginManager()
            facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
                if error != nil {
                    print("Kal: Unable to authenticate with Facebook - \(String(describing: error))")
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
                print("Kal: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("Kal: Successfully authenticated with Firebase")
                print(user!.displayName! as Any)
                let user = user!.displayName!
                let userUid = FIRAuth.auth()?.currentUser?.uid
                self.userCreatedFacebook(user: user, userUid: userUid!)
                
                if self.segueDismiss == false {
                    self.performSegue(withIdentifier: SEUGE_DONE, sender: nil)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    func userCreatedFacebook(user: String, userUid: String) {
        
        let currentUser: Dictionary<String, AnyObject> = [
            "displayName": user as AnyObject,
            "points": 0 as AnyObject
        ]
        
        let firebaseUser = DataService.ds.REF_BASE.child("users").child(userUid)
        firebaseUser.setValue(currentUser)
    }
}
