//
//  GistFile.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 02/04/21.
//

import Foundation

struct GistFile {
    private var name: String
    private var type: String
    private var language: String
    private var body: String
    
    init(name: String, type: String, language: String, body: String) {
        self.name = name
        self.type = type
        self.language = language
        self.body = body
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getType() -> String {
        return self.type
    }
    
    func getLanguage() -> String {
        return self.language
    }
    
    func getBody() -> String {
        return self.body
    }
}
