import Foundation
import Alamofire
import SwiftyJSON

protocol GistManagerDelegate {
    func updateGistInformation(_ gistManager: GistManager)
    func didFailWithError(error: Error)
}

enum GistManagerError: Error {
    case errorToConvertToJSON
}

class GistManager{
    var delegate: GistManagerDelegate?
    private var gist: Gist?
    
    func fetchRequest (with parameters: String...) {
        var urlString: String = K.Url.GIST_BASE_URL
        parameters.forEach { (parameter) in
            urlString += "/\(parameter)"
        }
        performRequest(url: urlString)
        
    }
    
    private func performRequest (url: String) {
        DispatchQueue.global(qos: .utility).async {
            let gistResult = GistServices.makeApiCall(with: url)
 
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
        let commentsResult = GistServices.makeApiCall(with: commentUrl)
        var gistComments = [GistComment]()
        switch commentsResult {
            case let .success(commentData):
                let commentsJson = self.parseJSON(commentData)
                for (_, object) in commentsJson {
                    
                    let dateFormatter = ISO8601DateFormatter()
                    let createdAt = dateFormatter.date(from: object["created_at"].stringValue)!

                    gistComments.append(GistComment(owner: object["user"]["login"].stringValue, body: object["body"].stringValue, createdAt: createdAt))
                }
                
            case .failure(_): break
        }
        gistBuilder = gistBuilder.andComments(gistComments)
    }
    
    private func mountCommits(with json: JSON, gistBuilder: inout GistBuilder) {
        let commitsUrl = json["commits_url"].stringValue
        let commitsResult = GistServices.makeApiCall(with: commitsUrl)
        var gistCommits = [GistCommit]()
        switch commitsResult {
            case let .success(commentData):
                let commentsJson = self.parseJSON(commentData)
                for (_, object) in commentsJson {
                    
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
            
            let filesResult = GistServices.makeApiCall(with: file.1["raw_url"].stringValue)
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
    
    func getCommits() -> [GistCommit] {
        return gist?.getCommits() ?? [GistCommit]()
    }
    
    func getNumberOfComments() -> Int {
        return getComments().count
    }
    
    func getNumberOfCommits() -> Int {
        return gist?.getCommits()?.count ?? 0
    }
    
    func getNumberOfFiles() -> Int {
        return getFilesDictionary().count
    }
    
    func getFilesDictionary() -> [(String,String)] {
        var filesDictionary = [(String,String)]()
        
        gist?.getFiles()?.forEach({ (file) in
            filesDictionary.append((file.getName(), file.getBody()))
        })
        
        return filesDictionary
    }
    
    func getComments() -> [(String,String,Date)] {
        var filesDictionary = [(String,String,Date)]()
        
        gist?.getComments()?.forEach({ (comment) in
            filesDictionary.append((comment.getOwner(), comment.getBody(), comment.getCreatedAt()))
        })
        
        return filesDictionary
    }
}
