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
        
        expect(sut, exp, completeWith: .failure(.unexpected)) {
            clientSpy.completesWithError(DomainError.unexpected)
        }
    }
    
    func test_auth_should_complete_with_success_if_client_completes_success() {
        let (sut, clientSpy) = makeSut()
        let expectedResult = makeThirdPartyAccountModel()
        let exp = expectation(description: "completion to auth remote account should response until 1 second")
        
        expect(sut, exp, completeWith: .success(expectedResult)) {
            clientSpy.completesWithSucces()
        }
    }
}

extension DataTests {
    func makeSut() -> (sut: ThirdPartyRemoteAuthentication, clientSpy: ThirdPartyClientSpy) {
        let clientSpy = ThirdPartyClientSpy()
        let sut = ThirdPartyRemoteAuthentication(client: clientSpy)
        
        return (sut: sut, clientSpy: clientSpy)
    }
    
    func expect(_ sut: ThirdPartyRemoteAuthentication, _ exp: XCTestExpectation, completeWith expectedResult: Authentication.Result, when action: () -> Void,  file: StaticString = #filePath, line: UInt = #line) {
        
        sut.auth() { receivedResult  in
            switch (receivedResult, expectedResult) {
            case (.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedAccount), .success(let receivedAccount)): XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)
            default: XCTFail("Expected \(expectedResult) received \(receivedResult) insted", file: file, line: line)
                
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1)
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
        completion?(.success(makeThirdPartyAccountModel()))
    }
}
