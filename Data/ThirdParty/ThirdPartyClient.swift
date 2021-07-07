import Foundation
import Domain

public protocol ThirdPartyClient {
    typealias AuthResult = Swift.Result<AccountModel, ThirdPartyError>
    func thirdPartyAuth(completion: @escaping (AuthResult) -> Void)
}
