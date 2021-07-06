import Foundation
import Data

public final class FirebaseAdapter: ThirdPartyClient {
    private var authMethod:  ((@escaping (ThirdPartyClient.AuthResult) -> Void) -> Void)?
    public init(authMethod: @escaping (@escaping (ThirdPartyClient.AuthResult) -> Void) -> Void) {
        self.authMethod = authMethod
    }
    
    public func thirdPartyAuth(completion: @escaping (ThirdPartyClient.AuthResult) -> Void) {
        authMethod?(completion)
    }
}
