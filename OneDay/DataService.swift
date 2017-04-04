//
//  DataService.swift
//  OneDay
//
//  Created by Carl Henningsson on 3/30/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = FIRDatabase.database().reference()
let URL_BASE_STORAGE = FIRStorage.storage().reference()

class DataService {

    static let ds = DataService()
    
    fileprivate var _REF_BASE = URL_BASE
    fileprivate var _REF_ORGANIZATIONS = URL_BASE.child("organizations")
    fileprivate var _REF_USERS = URL_BASE.child("users")
    
    fileprivate var _REF_STORAGE_BASE = URL_BASE_STORAGE

    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    var REF_ORGANIZATIONS: FIRDatabaseReference {
        return _REF_ORGANIZATIONS
    }
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_STORAGE_BASE: FIRStorageReference {
        return _REF_STORAGE_BASE
    }
}
