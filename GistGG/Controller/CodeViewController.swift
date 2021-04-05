//
//  CodeViewController.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 03/04/21.
//

import UIKit
import SwiftUI

class CodeViewController: UIViewController {
    
    let childView = UIHostingController(rootView: CodeView())
    
    var file: (String, String, String)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(childView)
        view.addSubview(childView.view)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        childView.view.translatesAutoresizingMaskIntoConstraints = false
        childView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        childView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        childView.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        childView.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
}
