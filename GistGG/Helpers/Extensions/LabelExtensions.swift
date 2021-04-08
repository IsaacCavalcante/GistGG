//
//  Utils.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 07/04/21.
//

import Foundation
import UIKit


extension UILabel {
    func typeAnimation (withText: String) {
        let titleText = withText
        self.text? = ""
        var index = 0.0

        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * index, repeats: false, block: {_ in
                self.text?.append(letter)
            })
            index+=1
            
        }
    }
}


