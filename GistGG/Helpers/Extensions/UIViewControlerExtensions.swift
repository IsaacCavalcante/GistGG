//
//  UIViewControlerExtensions.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 07/04/21.
//

import Foundation
import UIKit

extension UIViewController {
    func addAndShow(_ viewToPresent: UIViewController){
        self.addChild(viewToPresent)
        viewToPresent.view.frame = self.view.frame
        self.view.addSubview(viewToPresent.view)
        viewToPresent.didMove(toParent: self)
    }
}
