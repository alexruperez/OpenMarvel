import Foundation
import CryptoKit

struct AuthenticationEntity: Encodable {
    let apikey = "acf7c2130d3523a49e85b76222973315"
    let ts = Int(Date().timeIntervalSince1970)
    let hash: String?

    init() {
        let hashString = String(ts) + "8eb4796ec0063ecae141f5862f141db35ea12c87" + apikey
        if let hashData = hashString.data(using: .utf8) {
            hash = Insecure.MD5.hash(data: hashData).map { String(format: "%02hhx", $0) }.joined()
        } else {
            hash = nil
        }
    }

    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let dictionary = jsonObject as? [String: Any] else {
            throw EncodingError.invalidValue(
                jsonObject, EncodingError.Context(codingPath: [CodingKeys.apikey,
                                                               CodingKeys.ts,
                                                               CodingKeys.hash],
                                                  debugDescription: "Invalid authentication format."))
        }
        return dictionary
    }
}
