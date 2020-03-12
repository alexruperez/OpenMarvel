import XCTest
@testable import Domain

class DomainTests: XCTestCase {
    func testCharactersMarvelErrorLocalizedDescription() {
        let message = "Test"
        let error = CharactersError.marvel(code: "", message: message)
        XCTAssertEqual(message, error.localizedDescription)
    }

    func testCharactersNotFoundErrorLocalizedDescription() {
        let error = CharactersError.notFound
        XCTAssertEqual("Character not found.", error.localizedDescription)
    }

    func testCharactersUnderlyingErrorLocalizedDescription() {
        let error = CharactersError.underlying(NSError())
        XCTAssertEqual("Ooops, an unknown error occurred.", error.localizedDescription)
    }
}
