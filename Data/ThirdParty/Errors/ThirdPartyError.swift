import Foundation

public enum ThirdPartyError: Error {
    case noConnectivity
    case configuration
    case unauthorized
}
