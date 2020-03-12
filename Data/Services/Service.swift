import Foundation
import Moya

protocol Service: TargetType {
    static var mockBundle: String { get }
    var baseURLString: String { get }
    var mockName: String { get }
    var contentType: String { get }
    var mockExtension: String { get }
    var parameters: [String: Any] { get }
    var encoding: ParameterEncoding { get }
}

extension Service {
    static var mockBundle: String { "com.alexruperez.DataTests" }
    var baseURL: URL { URL(string: baseURLString)! }
    var method: Moya.Method { .get }
    var contentType: String { "application/json; charset=utf-8" }
    var mockExtension: String { "json" }
    var encoding: ParameterEncoding { URLEncoding.queryString }
    var sampleData: Data {
        guard let mockBundle = Bundle(identifier: Self.mockBundle),
            let url = mockBundle.url(forResource: mockName, withExtension: mockExtension),
            let data = try? Data(contentsOf: url) else {
                return Data()
        }
        return data
    }
    var headers: [String: String]? { ["Content-type": contentType] }
}
