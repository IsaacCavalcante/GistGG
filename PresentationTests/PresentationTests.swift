import XCTest
import Domain

class SigninPresenter {
    private let alertView: AlertView
    private let authentication: Authentication
    
    public init(alertView: AlertView, authentication: Authentication) {
        self.alertView = alertView
        self.authentication = authentication
    }
    
    public func signin() {
        authentication.auth { result in
            switch result {
            case .failure(let error):
                var errorMessage = "Algo inesperado aconteceu. Tente novamente em alguns instantes"
                switch error {
                case .unauthorized:
                    errorMessage = "Autenticação de usuário falhou"
                default:
                    break
                }
                self.alertView.showMessage(viewModel: AlertViewModel(title: "Error", message: errorMessage))
            case .success: break
            }
        }
    }
}

public protocol AlertView {
    func showMessage(viewModel: AlertViewModel)
}

public struct AlertViewModel: Equatable {
    public var title: String
    public var message: String
    
    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}

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

class AlertViewSpy: AlertView {
    var emit: ((AlertViewModel) -> Void)?
    
    func observer(completion: @escaping (AlertViewModel) -> Void) {
        self.emit = completion
    }
    
    public func showMessage(viewModel: AlertViewModel) {
        self.emit?(viewModel)
    }
}

class PresentationTests: XCTestCase {
    func test_sigin_should_show_generic_error_message_if_authentication_fails() {
        let alertViewSpy = AlertViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = SigninPresenter(alertView: alertViewSpy, authentication: authenticationSpy)
        let exp = expectation(description: "completion to auth remote account should response until 1 second")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Error", message: "Algo inesperado aconteceu. Tente novamente em alguns instantes"))
            exp.fulfill()
        }
        sut.signin()
        authenticationSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
}
