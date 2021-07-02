import Foundation
import Domain

public class ThirdPartyRemoteAuthentication: Authentication {
    private let client: ThirdPartyClient
    public init(client: ThirdPartyClient) {
        self.client = client
    }
    public func auth(completion: @escaping (Authentication.Result) -> Void) {
        client.thirdPartyAuth { result in
            switch result{
            case .success(let response):
                completion(.success(response))
            case .failure:
                completion(.failure(.unexpected))
            }
        }
    }
}
