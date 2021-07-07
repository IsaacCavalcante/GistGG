import XCTest
import Infra
import Data

class FirebaseAdapterTest: XCTestCase {
    func test_thirdPartyAuth_should_call_auth_method_correctly() {
        let exp = expectation(description: "completion to third party auth account should response until 1 second")
        let authMethodFake: ((ThirdPartyClient.AuthResult) -> Void) -> Void = { result in
            XCTAssertTrue(true)
            exp.fulfill()
        }
        let sut = FirebaseAdapter(authMethod: authMethodFake)
        
        sut.thirdPartyAuth { _ in }
        
        wait(for: [exp], timeout: 1)
    }
}
