import XCTest
import Presentation
@testable import UI


final class SigninControllerTests: XCTestCase {
    func test_sut_implements_alertview_protocol() {
        let sut = SigninViewController()
        XCTAssertNotNil(sut as AlertView)
    }
}
