import Foundation
import XCTest
import KIF

extension XCTestCase {
    
    func waitForAsyncExpectations(_ seconds: TimeInterval = 1) {
        let delayExpectation = expectation(description: "Waiting for async expectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            delayExpectation.fulfill()
        }
        waitForExpectations(timeout: seconds)
    }
    
    func tester(file: String = #file, _ line: Int = #line) -> KIFUITestActor {
        return KIFUITestActor(inFile: file, atLine: line, delegate: self)
    }

    func system(file: String = #file, _ line: Int = #line) -> KIFSystemTestActor {
        return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
    }
}
