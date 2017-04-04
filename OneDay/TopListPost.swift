//
//  TopListPost.swift
//  OneDay
//
//  Created by Carl Henningsson on 4/1/17.
//  Copyright © 2017 Henningsson Company. All rights reserved.
//

import Foundation

class TopListPost {

    fileprivate var _displayName: String!
    fileprivate var _points: Int!
    fileprivate var _postKey: String!
    
    var displayName: String {
        return _displayName
    }
    var points: Int {
        return _points
    }
    var postKey: String {
        return _postKey
    }
    
    init(displayName: String, points: Int) {
        self._displayName = displayName
        self._points = points
    }
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let displayName = postData["displayName"] as? String {
            self._displayName = displayName
        }
        if let points = postData["points"] as? Int {
            self._points = points
        }
    }
}
