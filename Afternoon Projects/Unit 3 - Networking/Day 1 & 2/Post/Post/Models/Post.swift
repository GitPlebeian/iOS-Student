//
//  Post.swift
//  Post
//
//  Created by Jackson Tubbs on 8/12/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class Post: Codable {
    
    let text: String
    let timestamp: TimeInterval
    let username: String
    
    init(text: String, username: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.text = text
        self.username = username
        self.timestamp = timestamp
    }
    
    var date: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
