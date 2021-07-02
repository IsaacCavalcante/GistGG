import Foundation
import Domain

public protocol ThirdPartyClient {
    typealias Result = Swift.Result<AccountModel, DomainError>
    func thirdPartyAuth(completion: @escaping (Result) -> Void)
}
