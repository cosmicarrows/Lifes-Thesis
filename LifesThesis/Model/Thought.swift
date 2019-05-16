//
//  Thought.swift
//  LifesThesis
//
//  Created by Laurence Wingo on 2/9/19.
//  Copyright © 2019 Cosmic Arrows, LLC. All rights reserved.
//

import Foundation

class Thought {
    
    private(set) var username: String!
    private(set) var timestamp: Date!
    private(set) var thoughtTxt: String!
    private(set) var numLikes: Int!
    private(set) var numComments: Int!
    private(set) var documentID: String!
    
    init(username: String, timestamp: Date, thoughtTxt: String, numLikes: Int, numComments: Int, documentID: String) {
        self.username = username
        self.timestamp = timestamp
        self.thoughtTxt = thoughtTxt
        self.numLikes = numLikes
        self.numComments = numComments
        self.documentID = documentID
    }
    
}
