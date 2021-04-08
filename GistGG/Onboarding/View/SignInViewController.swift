//
//  SignInViewController.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 04/04/21.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController, SpinnerDelegate {
    
    @IBOutlet weak var gistGGLabel: UILabel!
    var spinnerView = SpinnerViewController()
    private var provider = OAuthProvider(providerID: "github.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Define that spinnerView delegate is self
        spinnerView.delegate = self
        
        gistGGLabel.font = UIFont(name: "Font Awesome 5 Brands", size: 50)
        gistGGLabel.typeAnimation(withText: K.GistGG)
        
        //Configuring scopes of provider. That configuration will allow
        provider.scopes = ["gist", "read:user"]
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func logInTapped(_ sender: UIButton) {
        spinnerView.spinnerOn()
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.spinnerView.spinnerOff()
                    self.showAlertError(errorMessage: "Couldn't login in GitHub")
                }
            } else {
                if let credential = credential {
                    Auth.auth().signIn(with: credential) { authResult, error in
                        DispatchQueue.main.async {
                            self.spinnerView.spinnerOff()
                        }
                        if let error = error {
                            print(error)
                            DispatchQueue.main.async {
                                self.showAlertError(errorMessage: "Couldn't login in GitHub")
                            }
                        } else {
                            guard let oauthCredential = authResult?.credential as? OAuthCredential else {
                                return
                            }
                            if let acessToken = oauthCredential.accessToken, let email = authResult?.user.email {
                                UserAuthSingleton.shared.setUserToken(with: acessToken)
                                UserAuthSingleton.shared.setUserEmail(with: email)
                            }
                            self.performSegue(withIdentifier: K.Segue.signInToScanSegue, sender: nil)
                        }
                    }
                }
                
            }
        }
    }
    
    private func showAlertError (errorMessage: String) {
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
