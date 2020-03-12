import Domain
import Moya
import XCTest
@testable import Data

class DataTests: XCTestCase {
    private let timeOutResponse = EndpointSampleResponse.networkError(NSError(domain: NSURLErrorDomain,
                                                                              code: URLError.timedOut.rawValue,
                                                                              userInfo: nil))
    private let errorResponse = EndpointSampleResponse.networkResponse(500, Data())

    func charactersProvider(_ response: EndpointSampleResponse? = nil) -> CharactersProviderContract {
        var endpointClosure = MoyaProvider<CharactersService>.defaultEndpointMapping

        if let response = response {
            endpointClosure = { target in
                return Endpoint(url: URL(target: target).absoluteString,
                                sampleResponseClosure: { response },
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.headers)
            }
        }

        let moyaProvider = MoyaProvider<CharactersService>(endpointClosure: endpointClosure,
                                                           stubClosure: MoyaProvider.immediatelyStub)

        return CharactersProvider(moyaProvider)
    }

    func testCharactersSuccess() {
        let success = expectation(description: "success")

        charactersProvider().characters(nameStartsWith: nil,
                                        offset: nil,
                                        orderBy: .ascending) { result in
            if case let .success(characters) = result {
                XCTAssert(!characters.isEmpty)
                success.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCharactersTimeOut() {
        let timeOut = expectation(description: "timeOut")

        charactersProvider(timeOutResponse).characters(nameStartsWith: nil,
                                                       offset: nil,
                                                       orderBy: .descending) { result in
            if case let .failure(error) = result,
                case let .underlying(underlying) = error,
                case let .underlying(moyaError as NSError, _) = underlying as? MoyaError {
                XCTAssertEqual(moyaError.code, URLError.timedOut.rawValue)
                timeOut.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCharactersServerError() {
        let serverError = expectation(description: "serverError")

        charactersProvider(errorResponse).characters(nameStartsWith: nil,
                                                     offset: nil,
                                                     orderBy: .ascending) { result in
            if case let .failure(error) = result,
                case let .underlying(underlying) = error,
                case let .dataCorrupted(context) = underlying as? DecodingError,
                let contextError = context.underlyingError as NSError? {
                XCTAssertEqual(contextError.code, NSPropertyListReadCorruptError)
                serverError.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCharacterSuccess() {
        let success = expectation(description: "success")

        charactersProvider().character(0) { result in
            if case let .success(character) = result {
                XCTAssertNotNil(character)
                success.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCharacterTimeOut() {
        let timeOut = expectation(description: "timeOut")

        charactersProvider(timeOutResponse).character(0) { result in
            if case let .failure(error) = result,
                case let .underlying(underlying) = error,
                case let .underlying(moyaError as NSError, _) = underlying as? MoyaError {
                XCTAssertEqual(moyaError.code, URLError.timedOut.rawValue)
                timeOut.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCharacterServerError() {
        let serverError = expectation(description: "serverError")

        charactersProvider(errorResponse).character(0) { result in
            if case let .failure(error) = result,
                case let .underlying(underlying) = error,
                case let .objectMapping(moyaError as NSError, _) = underlying as? MoyaError,
                case let .dataCorrupted(context) = moyaError as? DecodingError,
                let contextError = context.underlyingError as NSError? {
                XCTAssertEqual(contextError.code, NSPropertyListReadCorruptError)
                serverError.fulfill()
            }
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
