import XCTest

class OpenMarvelUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func testExample() {
        XCUIApplication().launch()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
