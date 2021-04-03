//
//  SpinnerViewController.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 03/04/21.
//

import UIKit

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
