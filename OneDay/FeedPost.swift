//
//  FeedPost.swift
//  OneDay
//
//  Created by Carl Henningsson on 3/30/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import Foundation

class FeedPost {
    
    fileprivate var _NAME: String!
    fileprivate var _IMAGEURL: String!
    fileprivate var _POSTKEY: String!
    
    var NAME: String {
        return _NAME
    }
    var IMAGEURL: String {
        return _IMAGEURL
    }
    var POSTKEY: String {
        return _POSTKEY
    }
    
    init(NAME: String, IMAGEURL: String) {
        self._NAME = NAME
        self._IMAGEURL = IMAGEURL
    }
    
    init(POSTKEY: String, postData: Dictionary<String, AnyObject>) {
        self._POSTKEY = POSTKEY
        
        if let NAME = postData["name"] as? String {
            self._NAME = NAME
        }
        if let IMAGEURL = postData["imageUrl"] as? String {
            self._IMAGEURL = IMAGEURL
        }
    }
}
