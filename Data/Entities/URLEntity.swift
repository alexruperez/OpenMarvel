import Foundation

struct URLEntity: Tuple {
    let type: String
    let url: String

    func tupleKey() -> AnyHashable { type.replacingOccurrences(of: "link", with: "") }

    func toDomain() throws -> URL {
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [CodingKeys.url],
                                      debugDescription: "Invalid URL format.")
            )
        }
        return url
    }
}
