import XCTest
import Domain

class DataTests: XCTestCase {
    func test_auth_should_call_client_auth_method_correctly() {
        let clientSpy = ThirdPartyClientSpy()
        let sut = ThirdPartyRemoteAuthentication(client: clientSpy)
        
        sut.auth() { _ in }
        
        XCTAssertEqual(clientSpy.callsCounter, 1, "auth method called more than once")
    }
}

class ThirdPartyRemoteAuthentication: Authentication {
    private let client: ThirdPartyClient
    init(client: ThirdPartyClient) {
        self.client = client
    }
    func auth(completion: @escaping (Authentication.Result) -> Void) {
        client.thirdPartyAuth { _ in }
    }
}


//Esse seria o papel do FirebaseAdapter
class ThirdPartyClientSpy: ThirdPartyClient {
    var callsCounter = 0
    func thirdPartyAuth(completion: @escaping (ThirdPartyClient.Result) -> Void) {
        callsCounter += 1
    }
    
}

protocol ThirdPartyClient {
    typealias Result = Swift.Result<AccountModel, Error>
    func thirdPartyAuth(completion: @escaping (Result) -> Void)
}
