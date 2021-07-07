import Foundation
import Presentation

class AlertViewSpy: AlertView {
    var emit: ((AlertViewModel) -> Void)?
    
    func observer(completion: @escaping (AlertViewModel) -> Void) {
        self.emit = completion
    }
    
    public func showMessage(viewModel: AlertViewModel) {
        self.emit?(viewModel)
    }
}
