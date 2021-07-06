import Foundation
import Domain

public protocol ThirdPartyClient {
    typealias AuthResult = Swift.Result<AccountModel, DomainError>
    func thirdPartyAuth(completion: @escaping (AuthResult) -> Void)
}
