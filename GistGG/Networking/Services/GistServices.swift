//
//  GistServices.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 02/04/21.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case url
    case server
}

class GistServices {
    
    class func makeApiCall(with path: String) -> Result<Data?, NetworkError> {
        guard let url = URL(string: path) else {
            return .failure(.url)
        }
        var result: Result<Data?, NetworkError>!
        
        let semaphore = DispatchSemaphore(value: 0)
        AF.request(url, method: .get).response { (response) in
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
}
