//
//  GistBuilder.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 01/04/21.
//

import Foundation

class GistBuilder {
    private var id: String
    private var ownerName: String?
    private var ownerImageUrl: String?
    private var coments: Int?
    private var commits: Int?
    private var files: [String:String]?
    
    init(id: String) {
        self.id = id
    }
    
    func of(_ ownerName: String) -> GistBuilder {
        self.ownerName = ownerName
        return self
    }
    
    func withImage(_ ownerImageUrl: String) -> GistBuilder{
        self.ownerImageUrl = ownerImageUrl
        return self
    }
    
    func andNumberOfComents(_ coments: Int) -> GistBuilder{
        self.coments = coments
        return self
    }
    
    func andNumberOfComits(_ commits: Int) -> GistBuilder{
        self.commits = commits
        return self
    }
    
    func withFiles(_ files: [String:String]) -> GistBuilder{
        self.files = files
        return self
    }
    
    func thatsAll() -> Gist{
        return Gist(id: self.id, ownerName: self.ownerName ?? "", ownerImageUrl: self.ownerImageUrl ?? "", coments: self.coments ?? 0, commits: self.commits ?? 0, files: self.files ?? [String:String]())
    }
}
