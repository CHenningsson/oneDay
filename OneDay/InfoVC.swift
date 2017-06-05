//
//  InfoVC.swift
//  OneDay
//
//  Created by Carl Henningsson on 5/16/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(dismiss)
        view.addSubview(oneDay)
        view.addSubview(oneDayText)
        view.addSubview(team)
        view.addSubview(teamNew)
        view.addSubview(feedback)
        view.addSubview(feedbackNew)
        view.addSubview(copyright)
        
        _ = dismiss.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 50, heightConstant: 50)
        _ = oneDay.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 50, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        _ = oneDayText.anchor(oneDay.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 7.5, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        _ = team.anchor(oneDayText.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        _ = teamNew.anchor(team.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 7.5, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        _ = feedback.anchor(teamNew.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        _ = feedbackNew.anchor(feedback.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 7.5, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 0)
        _ = copyright.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 20, bottomConstant: 20, rightConstant: 20, widthConstant: 0, heightConstant: 0)

    }
    
    let oneDay: UILabel = {
        let od = UILabel()
        od.textColor = logoBlue
        od.text = "OneDay - MicroDonate"
        od.font = UIFont(name: SF_REGULAR, size: 22)!
        od.textAlignment = .left
        
        return od
    }()
    
    let oneDayText: UILabel = {
        let odt = UILabel()
        odt.textAlignment = .left
        odt.textColor = SECONDARY_TEXT
        odt.font = UIFont(name: SF_LIGHT, size: 16)!
        odt.text = "Appen skapades på grund av bristen på medkänsla runt om i världen. OneDay låter dig som medmänniska ta handling och hjälpa till genom att bidra till en bättre värld. Du väljer mellan de organisationer som är inkluderade i appen och donerar ett belopp mellan 10kr och 109kr. Du får poäng för varje donation för att hålla koll på hur mycket du bidrar med."
        odt.numberOfLines = 0
        
        return odt
    }()
    
    let team: UILabel = {
        let t = UILabel()
        t.text = "Bli en i teamet"
        t.font = UIFont(name: SF_REGULAR, size: 22)!
        t.textAlignment = .left
        t.textColor = logoBlue
        
        return t
    }()
    
    let teamNew: UILabel = {
        let tn = UILabel()
        tn.textAlignment = .left
        tn.textColor = SECONDARY_TEXT
        tn.font = UIFont(name: SF_LIGHT, size: 16)!
        tn.text = "Skicka ett mail till \"henningssoncompany@gmail.com\" med ämnesraden Team"
        tn.numberOfLines = 0
        
        return tn
    }()
    
    let feedback: UILabel = {
        let f = UILabel()
        f.text = "Ge OneDay feedback"
        f.font = UIFont(name: SF_REGULAR, size: 22)!
        f.textAlignment = .left
        f.textColor = logoBlue
        
        return f
    }()
    
    let feedbackNew: UILabel = {
        let fn = UILabel()
        fn.textAlignment = .left
        fn.textColor = SECONDARY_TEXT
        fn.font = UIFont(name: SF_LIGHT, size: 16)!
        fn.text = "Skicka ett mail till \"henningssoncompany@gmail.com\" med ämnesraden Feedback"
        fn.numberOfLines = 0
        
        return fn
    }()
    
    let copyright: UILabel = {
        let cr = UILabel()
        cr.text = "Copyright © Carl Henningsson, Henningsson Company"
        cr.font = UIFont(name: SF_LIGHT, size: 12)!
        cr.textColor = HINT_TEXT
        cr.textAlignment = .left
        
        return cr
    }()
    
    let dismiss: UIButton = {
        let diss = UIButton(type: .custom)
        diss.setImage(UIImage(named: "closeBtn-new"), for: .normal)
        diss.addTarget(self, action: #selector(dismissInfoVC), for: .touchUpInside)
        
        return diss
    }()
    
    func dismissInfoVC() {
        dismiss(animated: true, completion: nil)
    }

}
