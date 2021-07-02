import Foundation

open class AccountModel: Equatable {
    private var accessToken: String?
    required public init(accessToken: String) {
        self.accessToken = accessToken
    }

    public static func == (lhs: AccountModel, rhs: AccountModel) -> Bool {
        lhs.accessToken == rhs.accessToken
    }
}
