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
        gistGGLabel.font = UIFont(name: "Font Awesome 5 Brands", size: 50)
        provider.scopes = ["gist"]
        spinnerView.delegate = self
        
        let titleText = K.GistGG
        gistGGLabel.text = ""
        var index = 0.0
        
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * index, repeats: false, block: {_ in
                self.gistGGLabel.text?.append(letter)
            })
            index+=1
            
        }
        
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
                self.spinnerView.spinnerOff()
                self.showAlertError(errorMessage: "Couldn't login in GitHub")
            } else {
                if let credential = credential {
                    Auth.auth().signIn(with: credential) { authResult, error in
                        self.spinnerView.willMove(toParent: nil)
                        self.spinnerView.view.removeFromSuperview()
                        if let error = error {
                            print(error)
                            self.showAlertError(errorMessage: "Couldn't login in GitHub")
                        } else {
                            guard let oauthCredential = authResult?.credential as? OAuthCredential else {
                                return
                            }
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.gistToken = oauthCredential.accessToken!
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
