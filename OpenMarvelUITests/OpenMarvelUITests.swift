import XCTest

class OpenMarvelUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func testExample() {
        let app = XCUIApplication()
        app.launch()
        let cellsQuery = app.collectionViews.cells
        cellsQuery.otherElements.containing(.staticText, identifier:"3-D Man").element.tap()
        let charactersNavigationBar = app.navigationBars["Characters"]
        charactersNavigationBar.buttons["Bookmarks"].tap()
        app.sheets["Links"].scrollViews.otherElements.buttons["Cancel"].tap()
        charactersNavigationBar.buttons["Share"].tap()
        app.navigationBars["UIActivityContentView"].buttons["Close"].tap()
        let openmarvelButton = charactersNavigationBar.buttons["OpenMarvel"]
        openmarvelButton.tap()
        let searchField = app.navigationBars["OpenMarvel"].searchFields["Search characters"]
        searchField.tap()
        searchField.typeText("Iron Man")
        app.buttons["Search"].tap()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
