struct DataEntity: Decodable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [CharacterEntity]
}
