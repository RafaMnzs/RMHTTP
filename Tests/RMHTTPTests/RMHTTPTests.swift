import XCTest
@testable import RMHTTP

final class RMHTTPTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RMHTTP().text, "Hello, World!")
    }
}
