import Foundation
import FirebaseAuth
import Data
import Domain

public func makeGithubFirebaseAuthFactory(_ completion: @escaping (ThirdPartyClient.AuthResult) -> Void) {
    let provider = OAuthProvider(providerID: "github.com")
    
    provider.scopes = ["gist", "read:user"]
    
    provider.getCredentialWith(nil) { credential, error in
        if error != nil {
            completion(.failure(.configuration))
        }
        if let credentials = credential {
            Auth.auth().signIn(with: credentials) { authResult, error in
                if error != nil {
                    completion(.failure(.unauthorized))
                }
                
                guard let oauthCredential = authResult?.credential as? OAuthCredential, let accessToken = oauthCredential.accessToken else { return completion(.failure(.unauthorized)) }
                
                let accountModel = AccountModel(accessToken: accessToken)
                completion(.success(accountModel))
            }
        }
    }
}
