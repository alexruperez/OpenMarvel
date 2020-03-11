struct ResponseEntity: Decodable {
    let code: Int
    let status: String
    let data: DataEntity
}
