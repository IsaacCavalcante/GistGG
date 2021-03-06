//
//  Comment.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 02/04/21.
//

import Foundation

struct GistComment {
    private var owner: String
    private var body: String
    private var createdAt: Date
    private var ownerImageUrl: String
    
    init(owner: String, body: String, createdAt: Date, ownerImageUrl: String) {
        self.owner = owner
        self.body = body
        self.ownerImageUrl = ownerImageUrl
        self.createdAt = createdAt
    }
    
    func getOwner() -> String{
        return self.owner
    }
    
    func getBody() -> String{
        return self.body
    }
    
    func getOwnerImageUrl() -> String{
        return self.ownerImageUrl
    }
    
    func getCreatedAt() -> Date{
        return self.createdAt
    }
}
