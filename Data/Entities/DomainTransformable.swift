protocol DomainTransformable {
    associatedtype DomainModel

    func toDomain() throws -> DomainModel
}

extension Array where Element: DomainTransformable {
    func toDomain() throws -> [Element.DomainModel] {
        try map { try $0.toDomain() }
    }
}
