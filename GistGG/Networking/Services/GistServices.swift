//
//  GistServices.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 02/04/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import Firebase

enum NetworkError: Error {
    case url
    case server
    case auth
}

class GistServices {
    
    class func makeGetApiCall(with path: String) -> Result<Data?, NetworkError> {
        guard let url = URL(string: path) else {
            return .failure(.url)
        }
        
        let urlRequest = URLRequest(url: url)

        URLCache.shared.removeCachedResponse(for: urlRequest)
        
        var result: Result<Data?, NetworkError>!
        
        let semaphore = DispatchSemaphore(value: 0)
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .response { (response) in
            switch response.result {
            case .failure(_):
                result = .failure(.server)
            case .success(let value):
                result = .success(value)
            }
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
    
    class func makePostApiCall(toUrl path: String, withBody parameters: JSON, usingCredentials: Bool = false) -> Result<Data?, NetworkError> {
        
        guard let url = URL(string: path) else {
            return .failure(.url)
        }
        if let userName = UserAuthSingleton.shared.getUserName(), let password = UserAuthSingleton.shared.getUserToken() {
            var result: Result<Data?, NetworkError>!
            
            let semaphore = DispatchSemaphore(value: 0)
            
            var request = AF.request(url, method: .post, parameters: parameters)
            
            if(usingCredentials){
                let credentialData = "\(userName):\(password)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                
                let base64Credentials = credentialData.base64EncodedString()
                
                
                let headers = [HTTPHeader(name: "Authorization", value: "Basic \(base64Credentials)"),
                               HTTPHeader(name: "Accept", value: "application/json"),
                               HTTPHeader(name: "Content-Type", value: "application/json")]
                
                
                
                request = AF.request(url, method: .post,  parameters: parameters.dictionaryValue, encoder: JSONParameterEncoder.default, headers: HTTPHeaders(headers))
            }
            request
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .response { (response) in
                switch response.result {
                case .failure(_):
                    result = .failure(.server)
                case .success(let value):
                    result = .success(value)
                }
                semaphore.signal()
            }
            semaphore.wait()
            return result
        }
        return .failure(.auth)
    }
}
