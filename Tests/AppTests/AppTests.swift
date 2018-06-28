import Run
import Dispatch
import XCTest
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

@testable import App

final class AppTests: XCTestCase {
    func testNothing() throws {
        let server = App.KevCodex.server()
        XCTAssert(server.serverPort == 8080)
    }

    static let allTests = [
        ("testNothing", testNothing)
    ]
}
