//
//  UserAuthSingleton.swift
//  GistGG
//
//  Created by Isaac Cavalcante on 05/04/21.
//

import Foundation

class UserAuthSingleton {
    
    private var userToken: String?
    private var userEmail: String?
    
    static var shared: UserAuthSingleton = {
        let instance = UserAuthSingleton()
        return instance
    }()

    private init() {}

    func getUserToken() -> String? {
        return userToken
    }
    
    func getUserName() -> String? {
        return userEmail
    }
    
    func setUserToken(with token: String) {
        UserAuthSingleton.shared.userToken = token
    }
    
    func setUserEmail(with email: String) {
        UserAuthSingleton.shared.userEmail = email
    }
}
