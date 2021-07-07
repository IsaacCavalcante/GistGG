import Foundation
import Domain

public class SigninPresenter {
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
