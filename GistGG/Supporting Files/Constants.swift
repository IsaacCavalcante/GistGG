//
//  Constants.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 31/03/21.
//

import Foundation

struct K {
    
    static let GistGG = "\u{f092} Gist GG"

    struct Cell {
        static let fileCell = "fileCell"
        static let commentCell = "commentCell"
        
        struct Nib {
            static let fileCellNibName = "FileTableViewCell"
            static let commentCellNibName = "CommentTableViewCell"
        }
    }
    
    struct Segue {
        static let signInToScanSegue = "signInToScanSegue"
        static let scanToGistSegue = "scanToGistSegue"
        static let gistToviewCodeSegue = "gistToCodeViewSegue"
        
    }
    
    struct Color {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
    }
    
    struct Url {
        static let GIST_BASE_URL = "https://api.github.com/gists"
    }
}
