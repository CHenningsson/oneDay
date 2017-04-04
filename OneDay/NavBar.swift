//
//  NavBar.swift
//  OneDay
//
//  Created by Carl Henningsson on 3/28/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import UIKit

class NavBar: UINavigationController {

    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: SF_LIGHT, size: 20)!, NSForegroundColorAttributeName: PRIMARY_TEXT]
        
        navBar.layer.shadowColor = UIColor(white: 0, alpha: 0.2).cgColor
        navBar.layer.shadowOpacity = 1
        navBar.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}
