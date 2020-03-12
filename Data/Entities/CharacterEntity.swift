import Domain

struct CharacterEntity: Entity {
    let id: Int
    let name: String
    let description: String
    let thumbnail: ThumbnailEntity
    let urls: [URLEntity]

    func toDomain() throws -> Character {
        Character(id: id,
                  name: name,
                  description: description,
                  thumbnailURL: try? thumbnail.toDomain(),
                  urls: try urls.toDictionary())
    }
}
