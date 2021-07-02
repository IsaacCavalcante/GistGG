import XCTest
import Domain
import Data

class DataTests: XCTestCase {
    func test_auth_should_call_client_auth_method_correctly() {
        let (sut, clientSpy) = makeSut()
        
        sut.auth() { _ in }
        
        XCTAssertEqual(clientSpy.callsCounter, 1, "auth method called more than once")
    }
    
    func test_auth_should_complete_with_error_if_client_completes_with_error() {
        let (sut, clientSpy) = makeSut()
        
        let exp = expectation(description: "completion to auth remote account should response until 1 second")
        let expectedResult = DomainError.unexpected
        sut.auth() { receivedResult  in
            switch (receivedResult) {
            case .failure(let expectedError): XCTAssertEqual(expectedError, expectedResult)
            case .success: XCTFail("Error expected result \(expectedResult) and received \(receivedResult)")
                break
            }
            
            exp.fulfill()
        }
        
        clientSpy.completesWithError(DomainError.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_auth_should_complete_with_success_if_client_completes_success() {
        let (sut, clientSpy) = makeSut()
        let expectedResult = ThirdPartAccountModelSpy(accessToken: "any_token")
        let exp = expectation(description: "completion to auth remote account should response until 1 second")
        sut.auth() { receivedResult  in
            switch (receivedResult) {
            case .failure: XCTFail("Error expected result \(expectedResult) and received \(receivedResult)")
            case .success(let expectedAccount): XCTAssertEqual(expectedAccount, expectedResult)
                
            }
            
            exp.fulfill()
        }
        
        clientSpy.completesWithSucces()
        wait(for: [exp], timeout: 1)
    }
}

extension DataTests {
    func makeSut() -> (sut: ThirdPartyRemoteAuthentication, clientSpy: ThirdPartyClientSpy) {
        let clientSpy = ThirdPartyClientSpy()
        let sut = ThirdPartyRemoteAuthentication(client: clientSpy)
        
        return (sut: sut, clientSpy: clientSpy)
    }
}


//Esse seria o papel do FirebaseAdapter
class ThirdPartyClientSpy: ThirdPartyClient {
    var callsCounter = 0
    var completion: ((ThirdPartyClient.Result) -> Void)?
    
    func thirdPartyAuth(completion: @escaping (ThirdPartyClient.Result) -> Void) {
        callsCounter += 1
        self.completion = completion
    }
    
    func completesWithError(_ error: DomainError) {
        completion?(.failure(.unexpected))
    }
    
    func completesWithSucces() {
        completion?(.success(ThirdPartAccountModelSpy(accessToken: "any_token")))
    }
}

class ThirdPartAccountModelSpy: ThirdPartAccountModel {}
