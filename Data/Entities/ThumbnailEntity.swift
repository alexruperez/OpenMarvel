import Foundation

struct ThumbnailEntity: Entity {
    let path: String
    let `extension`: String

    func toDomain() throws -> URL {
        guard !path.hasSuffix("image_not_available"),
            let url = URL(string: path + "." + self.extension) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [CodingKeys.path,
                                                   CodingKeys.extension],
                                      debugDescription: "Invalid URL format.")
            )
        }
        return url
    }
}
