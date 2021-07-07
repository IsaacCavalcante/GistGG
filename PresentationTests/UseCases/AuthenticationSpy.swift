import Foundation
import Domain

class AuthenticationSpy: Authentication {
    var completion: ((Authentication.Result) -> Void)?
    
    func auth(completion: @escaping (Authentication.Result) -> Void) {
        self.completion = completion
    }
    
    func completeWithError (_ error: DomainError) {
        completion?(.failure(error))
    }
    
    func completeWithAccountModel (_ accountModel: AccountModel) {
        completion?(.success(accountModel))
    }
}
