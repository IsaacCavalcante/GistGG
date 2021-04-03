//
//  GistBuilder.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 01/04/21.
//

import Foundation

class GistBuilder {
    private var id: String
    private var ownerName: String
    private var ownerImageUrl: String?
    private var coments: [GistComment]?
    private var commits: [GistCommit]?
    private var files: [GistFile]?
    private var createdAt: Date
    
    init(id: String, ownerName: String, createdAt: Date) {
        self.id = id
        self.ownerName = ownerName
        self.createdAt = createdAt
    }
    
    func of(_ ownerName: String) -> GistBuilder {
        self.ownerName = ownerName
        return self
    }
    
    func withImage(_ ownerImageUrl: String) -> GistBuilder{
        self.ownerImageUrl = ownerImageUrl
        return self
    }
    
    func andComments(_ coments: [GistComment]) -> GistBuilder{
        self.coments = coments
        return self
    }
    
    func andCommits(_ commits: [GistCommit]) -> GistBuilder{
        self.commits = commits
        return self
    }
    
    func withFiles(_ files: [GistFile]) -> GistBuilder{
        self.files = files
        return self
    }
    
    func thatsAll() -> Gist{
        let gist = Gist(id: self.id, ownerName: self.ownerName, ownerImageUrl: self.ownerImageUrl ?? "", coments: self.coments ?? [], commits: self.commits ?? [], files: self.files ?? [], createdAt: self.createdAt)
        
        return gist
    }
}
