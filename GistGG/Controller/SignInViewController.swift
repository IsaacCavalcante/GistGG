//
//  SignInViewController.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 04/04/21.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var gistGGLabel: UILabel!
    private let spinnerView = SpinnerViewController()
    var provider = OAuthProvider(providerID: "github.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gistGGLabel.font = UIFont(name: "Font Awesome 5 Brands", size: 50)
        provider.scopes = ["gist"]
        
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
        self.addChild(self.spinnerView)
        self.spinnerView.view.frame = self.view.frame
        self.view.addSubview(self.spinnerView.view)
        self.spinnerView.didMove(toParent: self)
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                self.spinnerView.willMove(toParent: nil)
                self.spinnerView.view.removeFromSuperview()
                self.spinnerView.removeFromParent()
                // Handle error.
            }
            
            
            
            if credential != nil {
                Auth.auth().signIn(with: credential!) { authResult, error in
                    self.spinnerView.willMove(toParent: nil)
                    self.spinnerView.view.removeFromSuperview()
                    self.spinnerView.removeFromParent()
                    if error != nil {
                        // Handle error.
                    }
                    // User is signed in.
                    // IdP data available in authResult.additionalUserInfo.profile.
                    
                    guard let oauthCredential = authResult?.credential as? OAuthCredential else {
                        return
                    }
                    print(oauthCredential.accessToken)
                    self.performSegue(withIdentifier: K.Segue.signInToScanSegue, sender: nil)
                    // GitHub OAuth access token can also be retrieved by:
                    // oauthCredential.accessToken
                    // GitHub OAuth ID token can be retrieved by calling:
                    // oauthCredential.idToken
                }
            }
        }
    }
}
