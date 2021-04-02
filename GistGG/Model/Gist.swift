//
//  Gist.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 31/03/21.
//

import Foundation

struct Gist {
    private var id: String
    private var ownerName: String?
    private var ownerImageUrl: String?
    private var coments: Int?
    private var commits: Int?
    private var files: [String:String]?
    
    init(id: String, ownerName: String, ownerImageUrl: String, coments: Int, commits: Int, files: [String:String]) {
        self.id = id
        self.ownerName = ownerName
        self.ownerImageUrl = ownerImageUrl
        self.coments = coments
        self.commits = commits
        self.files = files
    }
    
    func getId() -> String {
        return self.id
    }
    
    func getOwnerName() -> String? {
        return self.ownerName ?? ""
    }
    
    func getOwnerImageUrl() -> String? {
        return self.ownerImageUrl ?? ""
    }
    
    func getComents() -> Int? {
        return self.coments ?? 0
    }
    
    func getCommits() -> Int? {
        return self.commits ?? 0
    }
    
    func getfiles() -> [String:String]? {
        return self.files ?? [String:String]()
    }
}
