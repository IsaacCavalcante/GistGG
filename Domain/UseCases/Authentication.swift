import Foundation

public protocol Authentication {
    typealias Result = Swift.Result<AccountModel, DomainError>
    func auth(completion: @escaping (Result) -> Void)
}
