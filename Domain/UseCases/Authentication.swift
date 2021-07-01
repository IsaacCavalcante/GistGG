import Foundation

public protocol Authentication {
    typealias Result = Swift.Result<AccountModel, Error>
    func auth(completion: @escaping (Result) -> Void)
}
