import XCTest

class OpenMarvelUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func testHappyPath() {
        let app = XCUIApplication()
        app.launch()
        let cellsQuery = app.collectionViews.cells.otherElements
        cellsQuery.containing(.staticText, identifier: "3-D Man").element.tap()
        let charactersNavigationBar = app.navigationBars["Characters"]
        charactersNavigationBar.buttons["Bookmarks"].tap()
        app.sheets["Links"].scrollViews.otherElements.buttons["Cancel"].tap()
        charactersNavigationBar.buttons["Share"].tap()
        app.navigationBars["UIActivityContentView"].buttons["Close"].tap()
        charactersNavigationBar.buttons["OpenMarvel"].tap()
        #if !targetEnvironment(macCatalyst)
        app.collectionViews.element.swipeUp()
        app.collectionViews.element.swipeUp()
        #endif
        let openmarvelNavigationBar = app.navigationBars["OpenMarvel"]
        openmarvelNavigationBar.buttons["Search"].tap()
        let searchField = openmarvelNavigationBar.searchFields["Search characters"]
        searchField.tap()
        searchField.typeText("Iron Man")
        app.buttons["Search"].tap()
        cellsQuery.containing(.staticText, identifier: "Iron Man").element.tap()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
