import Foundation
import Alamofire
import SwiftyJSON
import Firebase

protocol GistManagerDelegate {
    func updateGistInformation(_ gistManager: GistManager)
    func updateGistComments(_ gistManager: GistManager)
    func didFailCreateCommentWithError(error: Error)
    func didFailWithError(error: Error)
}

enum GistManagerError: Error {
    case errorToConvertToJSON
}

class GistManager{
    var delegate: GistManagerDelegate?
    private var gist: Gist?

    
    func mountUrl (parameters: String...) -> String{
        var urlString: String = K.Url.GIST_BASE_URL
        
        parameters.forEach { (parameter) in
            urlString += "/\(parameter)"
        }
        
        return urlString
    }
    
    func performRequest (url: String) {
        DispatchQueue.global().async {
            let gistResult = GistServices.makeGetApiCall(with: url)
            
            switch gistResult {
            case let .success(data):
                let gistJson = self.parseJSON(data)
                self.gist = self.mountGist(with: gistJson)
                self.delegate?.updateGistInformation(self)
            case let .failure(error):
                self.delegate?.didFailWithError(error: error)
            }
        }
    }
    
    private func parseJSON(_ gistResult: Data?) -> JSON {
        var json = JSON()
        do {
            json = try JSON(data: gistResult!)
        } catch {
            self.delegate?.didFailWithError(error: GistManagerError.errorToConvertToJSON)
        }
        return json
    }
    
    private func mountGist(with json: JSON) -> Gist {
        
        let id = json["id"].stringValue
        let ownerName = json["owner"]["login"].stringValue
        let ownerImageUrl = json["owner"]["avatar_url"].stringValue
        
        let dateFormatter = ISO8601DateFormatter()
        let createdAt = dateFormatter.date(from:json["created_at"].stringValue)!
        
        var gistBuilder = GistBuilder(id: id, ownerName: ownerName, createdAt: createdAt)
        
        if(ownerImageUrl != " "){
            gistBuilder = gistBuilder.withImage(ownerImageUrl)
        }
        
        mountComments(with: json, gistBuilder: &gistBuilder)
        mountCommits(with: json, gistBuilder: &gistBuilder)
        mountFiles(with: json, gistBuilder: &gistBuilder)
        
        return gistBuilder.thatsAll()
    }
    
    private func mountComments(with json: JSON, gistBuilder: inout GistBuilder) {
        let commentUrl = json["comments_url"].stringValue
        let commentsResult = GistServices.makeGetApiCall(with: commentUrl)
        var gistComments = [GistComment]()
        switch commentsResult {
        case let .success(commentData):
            let commentsJson = self.parseJSON(commentData)
            for (_, object) in commentsJson {
                
                let dateFormatter = ISO8601DateFormatter()
                let createdAt = dateFormatter.date(from: object["created_at"].stringValue)!
                
                gistComments.append(GistComment(owner: object["user"]["login"].stringValue, body: object["body"].stringValue, createdAt: createdAt, ownerImageUrl: object["user"]["avatar_url"].stringValue))
            }
            
        case .failure(_): break
        }
        gistBuilder = gistBuilder.andComments(gistComments)
    }
    
    private func mountCommits(with json: JSON, gistBuilder: inout GistBuilder) {
        let commitsUrl = json["commits_url"].stringValue
        let commitsResult = GistServices.makeGetApiCall(with: commitsUrl)
        var gistCommits = [GistCommit]()
        switch commitsResult {
        case let .success(commitData):
            let commitsJson = self.parseJSON(commitData)
            for (_, object) in commitsJson {
                
                let dateFormatter = ISO8601DateFormatter()
                let createdAt = dateFormatter.date(from: object["committed_at"].stringValue)!
                
                gistCommits.append(GistCommit(owner: object["user"]["login"].stringValue, createdAt: createdAt))
            }
            
        case .failure(_): break
        }
        gistBuilder = gistBuilder.andCommits(gistCommits)
    }
    
    private func mountFiles(with json: JSON, gistBuilder: inout GistBuilder) {
        let filesJson = json["files"]
        var gistFiles = [GistFile]()
        
        filesJson.forEach { (file) in
            
            let filesResult = GistServices.makeGetApiCall(with: file.1["raw_url"].stringValue)
            switch filesResult {
            case let .success(fileData):
                let code = String(decoding: fileData!, as: UTF8.self)
                gistFiles.append(GistFile(name: file.0, type: file.1["type"].stringValue, language: file.1["language"].stringValue, body: code))
                
            case .failure(_): break
            }
        }
        
        gistBuilder = gistBuilder.withFiles(gistFiles)
    }
    
    func getGistOwnerName() -> String? {
        return gist?.getOwnerName()
    }
    
    func getGistId() -> String? {
        return gist?.getId()
    }
    
    func getGistUrlImage() -> String? {
        return gist?.getOwnerImageUrl()
    }
    
    func getNumberOfComments() -> Int {
        return getComments().count
    }
    
    func getNumberOfCommits() -> Int {
        return gist?.getCommits().count ?? 0
    }
    
    func getNumberOfFiles() -> Int {
        return getFiles().count
    }
    
    func getFiles() -> [(String,String,String)] {
        var filesDictionary = [(String,String,String)]()
        
        gist?.getFiles().forEach({ (file) in
            filesDictionary.append((file.getName(), file.getLanguage(), file.getBody()))
        })
        
        return filesDictionary
    }
    
    func getComments() -> [(String,String,String,Date)] {
        var comments = [(String,String,String,Date)]()
        
        gist?.getComments().forEach({ (comment) in
            comments.append((comment.getOwner(), comment.getOwnerImageUrl(),comment.getBody(), comment.getCreatedAt()))
        })
        
        return comments
    }
    
    func createComment(comment: String)  {
        if gist != nil {
            let url = mountUrl(parameters: gist!.getId(),"comments")
            let json = JSON(["body": comment])
            DispatchQueue.global().async {
                let gistResult = GistServices.makePostApiCall(toUrl: url, withBody: json, usingCredentials: true)
                
                switch gistResult {
                case let .success(data):
                    let commentJson = self.parseJSON(data)
                    let dateFormatter = ISO8601DateFormatter()
                    let createdAt = dateFormatter.date(from: commentJson["created_at"].stringValue)!
                    
                    let comment = GistComment(owner: commentJson["user"]["login"].stringValue, body: commentJson["body"].stringValue, createdAt: createdAt, ownerImageUrl: commentJson["user"]["avatar_url"].stringValue)
                    
                    self.gist?.addComment(newComment: comment)
                    self.delegate?.updateGistComments(self)
                case let .failure(error):
                    self.delegate?.didFailCreateCommentWithError(error: error)
                }
            }
        }
    }
    
    func getCommits() -> [GistCommit] {
        return gist?.getCommits() ?? [GistCommit]()
    }
}
