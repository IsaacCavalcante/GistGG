import XCTest
import Domain
import Presentation

class PresentationTests: XCTestCase {
    func test_sigin_should_show_generic_error_message_if_authentication_fails() {
        let test = makeSut()
        let alertViewSpy = test.alertViewSpy
        let authenticationSpy = test.authenticationSpy
        let sut = test.sut
        let exp = expectation(description: "completion to auth remote account should response until 1 second")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Error", message: "Algo inesperado aconteceu. Tente novamente em alguns instantes"))
            exp.fulfill()
        }
        sut.signin()
        authenticationSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_sigin_should_show_unauthorized_message_if_authentication_fails() {
        let test = makeSut()
        let alertViewSpy = test.alertViewSpy
        let authenticationSpy = test.authenticationSpy
        let sut = test.sut
        let exp = expectation(description: "completion to auth remote account should response until 1 second")
        alertViewSpy.observer { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Error", message: "Autenticação de usuário falhou"))
            exp.fulfill()
        }
        sut.signin()
        authenticationSpy.completeWithError(.unauthorized)
        wait(for: [exp], timeout: 1)
    }
}

extension PresentationTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> (sut: SigninPresenter, alertViewSpy: AlertViewSpy, authenticationSpy: AuthenticationSpy) {
        let alertViewSpy = AlertViewSpy()
        let authenticationSpy = AuthenticationSpy()
        let sut = SigninPresenter(alertView: alertViewSpy, authentication: authenticationSpy)
        
        return (sut, alertViewSpy, authenticationSpy)
    }
}
