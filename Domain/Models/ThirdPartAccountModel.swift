import Foundation

open class ThirdPartAccountModel: AccountModel {
    var refreshToken: String?
    
    init(accessToken: String, refreshToken: String) {
        super.init(accessToken: accessToken)
        self.refreshToken = refreshToken
    }
    
    required public init(accessToken: String) {
        super.init(accessToken: accessToken)
    }
}
