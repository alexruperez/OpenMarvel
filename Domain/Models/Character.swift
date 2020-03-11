import Foundation

public struct Character {
    public let id: Int
    public let name: String
    public let description: String
    public let thumbnailURL: URL?
    public let urls: [AnyHashable: URL]

    public init(id: Int,
                name: String,
                description: String,
                thumbnailURL: URL?,
                urls: [AnyHashable: URL]) {
        self.id = id
        self.name = name
        self.description = description
        self.thumbnailURL = thumbnailURL
        self.urls = urls
    }
}
