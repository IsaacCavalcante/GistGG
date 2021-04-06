//
//  Gist.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 31/03/21.
//

import Foundation

struct Gist {
    private var id: String
    private var ownerName: String
    private var ownerImageUrl: String
    private var comments: [GistComment]
    private var commits: [GistCommit]
    private var files: [GistFile]
    private var createdAt: Date
    
    init(id: String, ownerName: String, ownerImageUrl: String, comments: [GistComment], commits: [GistCommit], files: [GistFile], createdAt: Date) {
        self.id = id
        self.ownerName = ownerName
        self.ownerImageUrl = ownerImageUrl
        self.comments = comments
        self.commits = commits
        self.files = files
        self.createdAt = createdAt
    }
    
    func getId() -> String {
        return self.id
    }
    
    func getOwnerName() -> String {
        return self.ownerName
    }
    
    func getOwnerImageUrl() -> String {
        return self.ownerImageUrl
    }
    
    func getComments() -> [GistComment] {
        return self.comments
    }
    
    mutating func addComment(newComment: GistComment) {
        self.comments.append(newComment)
    }
    
    func getCommits() -> [GistCommit] {
        return self.commits
    }
    
    func getFiles() -> [GistFile] {
        return self.files
    }
    
    func getCreatedAt() -> Date {
        return self.createdAt
    }
}
