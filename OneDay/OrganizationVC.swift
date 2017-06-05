//
//  OrganizationVC.swift
//  OneDay
//
//  Created by Carl Henningsson on 4/5/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit
import Firebase
import Social
import StoreKit

class OrganizationVC: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    fileprivate var _feedPost: FeedPost!
    
    var feedPost: FeedPost {
        get {
            return _feedPost
        } set {
            _feedPost = newValue
        }
    }
    
    let organizationImage: UIImageView = {
        let oImg = UIImageView()
        oImg.image = UIImage(named: "")
        oImg.contentMode = .scaleAspectFill
        oImg.clipsToBounds = true
        
        return oImg
    }()
    
    let iconone: UIButton = {
        let i = UIButton(type: .custom)
        i.setImage(UIImage(named: "coin-new"), for: .normal)
        i.addTarget(self, action: #selector(purchaseOne), for: .touchUpInside)
        
        return i
    }()
    
    let icontwo: UIButton = {
        let i = UIButton(type: .custom)
        i.setImage(UIImage(named: "coins-new"), for: .normal)
        i.addTarget(self, action: #selector(purchaseTwo), for: .touchUpInside)
    
        return i
    }()
    
    let iconthree: UIButton = {
        let i = UIButton(type: .custom)
        i.setImage(UIImage(named: "bill-new"), for: .normal)
        i.addTarget(self, action: #selector(purchaseThree), for: .touchUpInside)
    
        return i
    }()
    
    let iconfour: UIButton = {
        let i = UIButton(type: .custom)
        i.setImage(UIImage(named: "bills-new"), for: .normal)
        i.addTarget(self, action: #selector(purchaseFour), for: .touchUpInside)
        
        return i
    }()
    
    let donationInfo: UIView = {
        let di = UIView()
        di.backgroundColor = .white
        
        return di
    }()
    
    let seperatorOne: UIView = {
        let s = UIView()
        s.backgroundColor = DIVIDERS
        
        return s
    }()
    
    let seperatorThree: UIView = {
        let s = UIView()
        s.backgroundColor = DIVIDERS
        
        return s
    }()
    
    let seperatorFour: UIView = {
        let s = UIView()
        s.backgroundColor = DIVIDERS
        
        return s
    }()
    
    let seperatorFive: UIView = {
        let s = UIView()
        s.backgroundColor = DIVIDERS
        
        return s
    }()
    
    let seperatorTwo: UIView = {
        let s = UIView()
        s.backgroundColor = DIVIDERS
        
        return s
    }()
    
    let donateText: UILabel = {
        let dt = UILabel()
        dt.text = "Hur mycket skulle du vilja donera till:"
        dt.font = UIFont(name: SF_LIGHT, size: 17)!
        dt.textColor = PRIMARY_TEXT
        dt.textAlignment = .center
        
        return dt
    }()
    
    let organizationName: UILabel = {
        let oN = UILabel()
        oN.text = ""
        oN.font = UIFont(name: SF_REGULAR, size: 26)!
        oN.textColor = PRIMARY_TEXT
        oN.textAlignment = .center
        oN.numberOfLines = 0
        
        return oN
    }()
    
    let shareBtn: UIButton = {
        let sBtn = UIButton(type: .custom)
        sBtn.setTitle("SHARE", for: .normal)
        sBtn.titleLabel?.font = UIFont(name: SF_LIGHT, size: 20)!
        sBtn.titleLabel?.textColor = .white
        sBtn.layer.shadowColor = UIColor(white: 0, alpha: 1).cgColor
        sBtn.layer.shadowOffset = CGSize(width: 4, height: 2)
        sBtn.layer.shadowRadius = 5
        sBtn.layer.shadowOpacity = 0.8
        sBtn.addTarget(self, action: #selector(shareDonation), for: .touchUpInside)
        
        return sBtn
    }()
    
    var user = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subViews()
        
        if currentReachabilityStatus != .notReachable {
            FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
                if user != nil {
                    DataService.ds.REF_USERS.child(user!.uid).observe(.value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let point = value?["points"] as? Int
                        self.pp = point!
                        self.title = "\(point!)p"
                    }, withCancel: nil)
                } else {
                    self.title = "XOXO"
                }
            })
        }
        
        iconone.isEnabled = false
        icontwo.isEnabled = false
        iconthree.isEnabled = false
        iconfour.isEnabled = false
        
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enable, loading")
            let productID: NSSet = NSSet(objects: ten, thirty, fifty, onehundred)
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("Please enable IAPs")
        }
        
        infoPlacer()
    }
    
    var pp = 0
    
    func infoPlacer(img: UIImage? = nil) {
        
        organizationName.text = "\(feedPost.NAME)?"
        
        if img != nil {
            self.organizationImage.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: feedPost.IMAGEURL)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Unable to download image from Firebase Storage, \(String(describing: error?.localizedDescription))")
                } else {
                    if let imgData = data {
                        print("image downloaded")
                        if let img = UIImage(data: imgData) {
                            self.organizationImage.image = img
                            FeedVC.imageCache.setObject(img, forKey: self.feedPost.IMAGEURL as NSString)
                        }
                    }
                }
            })
        }
    }
    
    func shareDonation() {
    
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
                post?.setInitialText("Jag har precis donerat till \(self.feedPost.NAME)! Gör det du också! \n\nhttps://itunes.apple.com/se/app/oneday-microdonate/id1220479316?l=en&mt=8")
                
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
    
    let coinTxt: UILabel = {
        let ct = UILabel()
        ct.text = "Donera 10kr och få 80 poäng"
        ct.font = UIFont(name: SF_LIGHT, size: 16)!
        ct.numberOfLines = 0
        ct.textColor = SECONDARY_TEXT
        ct.textAlignment = .left
        
        return ct
    }()
    
    let coinsTxt: UILabel = {
        let ct = UILabel()
        ct.text = "Donera 30kr och få 210 poäng"
        ct.font = UIFont(name: SF_LIGHT, size: 16)!
        ct.numberOfLines = 0
        ct.textColor = SECONDARY_TEXT
        ct.textAlignment = .left
        
        return ct
    }()
    
    let billTxt: UILabel = {
        let ct = UILabel()
        ct.text = "Donera 50kr och få 450 poäng"
        ct.font = UIFont(name: SF_LIGHT, size: 16)!
        ct.numberOfLines = 0
        ct.textColor = SECONDARY_TEXT
        ct.textAlignment = .left
        
        return ct
    }()
    
    let billsTxt: UILabel = {
        let ct = UILabel()
        ct.text = "Donera 109kr och få 1200 poäng"
        ct.font = UIFont(name: SF_LIGHT, size: 16)!
        ct.numberOfLines = 0
        ct.textColor = SECONDARY_TEXT
        ct.textAlignment = .left
        
        return ct
    }()
    
    func subViews() {
        
        view.addSubview(organizationImage)
        view.addSubview(iconone)
        view.addSubview(coinTxt)
        view.addSubview(seperatorThree)
        view.addSubview(icontwo)
        view.addSubview(coinsTxt)
        view.addSubview(iconthree)
        view.addSubview(billTxt)
        view.addSubview(iconfour)
        view.addSubview(billsTxt)
        view.addSubview(seperatorOne)
        view.addSubview(donationInfo)
        view.addSubview(donateText)
        view.addSubview(organizationName)
        view.addSubview(shareBtn)
        view.addSubview(seperatorFour)
        view.addSubview(seperatorFive)
        
        //new design
        let onethird = view.frame.height / 3
        let delar = onethird + 170
        let da = view.frame.height - delar
        let splitt = da / 4
        let iconHeight = splitt / 3
        let mm = splitt / 6
        
        _ = organizationImage.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: onethird)
        _ = donationInfo.anchor(organizationImage.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)
        
        _ = seperatorOne.anchor(donationInfo.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        _ = coinTxt.anchor(seperatorOne.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: iconHeight + 4, leftConstant: iconHeight, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = iconone.anchor(seperatorOne.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: mm, leftConstant: 0, bottomConstant: 0, rightConstant: mm, widthConstant: mm * 4, heightConstant: mm * 4)
        
        _ = seperatorThree.anchor(seperatorOne.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: splitt, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        _ = coinsTxt.anchor(seperatorThree.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: iconHeight + 4, leftConstant: iconHeight, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = icontwo.anchor(seperatorThree.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: mm, leftConstant: 0, bottomConstant: 0, rightConstant: mm, widthConstant: mm * 4, heightConstant: mm * 4)
        
        _ = seperatorFour.anchor(seperatorThree.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: splitt, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        _ = billTxt.anchor(seperatorFour.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: iconHeight + 4, leftConstant: iconHeight, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = iconthree.anchor(seperatorFour.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: mm, leftConstant: 0, bottomConstant: 0, rightConstant: mm, widthConstant: mm * 4, heightConstant: mm * 4)
        
        _ = seperatorFive.anchor(seperatorFour.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: splitt, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 1)
        _ = billsTxt.anchor(seperatorFive.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: iconHeight + 4, leftConstant: iconHeight, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = iconfour.anchor(seperatorFive.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: mm, leftConstant: 0, bottomConstant: 0, rightConstant: mm, widthConstant: mm * 4, heightConstant: mm * 4)
        
        _ = donateText.anchor(donationInfo.topAnchor, left: donationInfo.leftAnchor, bottom: nil, right: donationInfo.rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        _ = organizationName.anchor(donateText.bottomAnchor, left: donationInfo.leftAnchor, bottom: nil, right: donationInfo.rightAnchor, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)

        _ = shareBtn.anchor(nil, left: nil, bottom: donationInfo.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 10, rightConstant: 20, widthConstant: 0, heightConstant: 0)
    }
    
    let ten = "com.HenningssonCo.OneDay.TenKronor"
    let thirty = "com.HenningssonCo.OneDay.ThirtyKronor"
    let fifty = "com.HenningssonCo.OneDay.FiftyKronor"
    let onehundred = "com.HenningssonCo.OneDay.OnehundredKronor"
    
    
    func purchaseOne() {
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == ten) {
                p = product
                buyProduct()
            }
        }
    }
    
    func pOne() {
        print("Kal: 10kr")
        pp += 80
        print("Kal: \(pp)")
        updateUserPoints()
    }
    
    func purchaseTwo() {
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == thirty) {
                p = product
                buyProduct()
            }
        }
    }
    
    func pTwo() {
        print("Kal: 30kr")
        pp += 210
        print("Kal: \(pp)")
        updateUserPoints()
    }
    
    func purchaseThree() {
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == fifty) {
                p = product
                buyProduct()
            }
        }
    }
    
    func pThree() {
        print("Kal: 50kr")
        pp += 450
        print("Kal: \(pp)")
        updateUserPoints()
    }
    
    func purchaseFour() {
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == onehundred) {
                p = product
                buyProduct()
            }
        }
    }
    
    func pFour() {
        print("Kal: 109kr")
        pp += 1200
        print("Kal: \(pp)")
        updateUserPoints()
    }
    
    func buyProduct() {
        print("Buy " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }
    
    func updateUserPoints() {
        let firebaseUpdate = DataService.ds.REF_USERS.child(user!.uid).child("points")
        firebaseUpdate.setValue(pp)
    }
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product)
        }
        
        iconone.isEnabled = true
        icontwo.isEnabled = true
        iconthree.isEnabled = true
        iconfour.isEnabled = true
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transaction restored")
        
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case ten:
                print("Ten Kronor")
                pOne()
            case thirty:
                print("Thirty Kronor")
                pTwo()
            case fifty:
                print("Fifty Kronor")
                pThree()
            case onehundred:
                print("One Hundred Kronor")
                pFour()
            default:
                print("In App Purchase not found")
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error as Any)
            
            switch trans.transactionState {
            case .purchased:
                print("buy ok, unlock IAP HERE")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier
                
                switch prodID {
                case ten:
                    print("Ten Kronor")
                    pOne()
                case thirty:
                    print("Thirty Kronor")
                    pTwo()
                case fifty:
                    print("Fifty Kronor")
                    pThree()
                case onehundred:
                    print("One Hundred Kronor")
                    pFour()
                default:
                    print("In App Purchase not found")
                }
                
            queue.finishTransaction(trans)
            case .failed:
                print("Buy error")
                queue.finishTransaction(trans)
                break;
                
            default:
                print("Default")
                break
            }
        }
    }
}
