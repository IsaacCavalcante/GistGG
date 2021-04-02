import Foundation
import Alamofire
import SwiftyJSON

protocol GistManagerDelegate {
    func updateGistInformation(_ gistManager: GistManager)
    func didFailWithError(error: GistManagerError)
}

enum GistManagerError: Error {
    case couldntDoRequest
    case errorToConvertToJSON
}

class GistManager{
    var delegate: GistManagerDelegate?
    private var gist: Gist?
    
    func fetchRequest (withId id: String) {
        var urlString: String {
            get {
                return "\(K.Url.GIST_BASE_URL)/\(id)"
            }
        }
        performRequest(url: urlString)
        
    }
    
    private func performRequest (url: String) {
        
        AF.request(url, method: .get).response { (response) in
        
            switch response.result {
            case .failure(_):
                self.delegate?.didFailWithError(error: GistManagerError.couldntDoRequest)
            case .success(let value):
                self.parseJSON(value)
                self.delegate?.updateGistInformation(self)
            }
        }
    }
    
    
    
    private func parseJSON(_ gistResult: Data?) {
        do {
            let json: JSON = try JSON(data: gistResult!)
            self.gist = mountGist(with: json)
        } catch {
            self.delegate?.didFailWithError(error: GistManagerError.errorToConvertToJSON)
        }
    }

    private func mountGist(with json: JSON) -> Gist{
        let id = json["id"].stringValue
        let ownerName = json["owner"]["login"].stringValue
        let ownerImageUrl = json["owner"]["avatar_url"].stringValue
        let coments = Int(json["query"]["pageids"][0].stringValue) ?? 0
        let commits = Int(json["query"]["pageids"][0].stringValue) ?? 0
        let files = [String:String]()
        
        let gist = GistBuilder(id: id)
            .of(ownerName)
            .withImage(ownerImageUrl)
            .andNumberOfComents(coments)
            .andNumberOfComits(commits)
            .withFiles(files)
            .thatsAll()
            
        return gist
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
    
    func getNumberOfComents() -> Int? {
        return gist?.getComents()
    }
    
    func getNumberOfCommits() -> Int? {
        return gist?.getCommits()
    }
    
    func getNumberOfFiles() -> Int {
        let files = getFilesDictionary()
        
        
        return files?.count ?? 0
    }
    
    func getFilesDictionary() -> [String:String]? {
        return gist?.getfiles()
    }
}
