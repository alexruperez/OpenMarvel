protocol DomainTransformable {
    associatedtype DomainModel
    func toDomain() throws -> DomainModel
}

protocol TupleTransformable: DomainTransformable {
    func tupleKey() throws -> AnyHashable
    func toTuple() throws -> (AnyHashable, DomainModel)
}

extension TupleTransformable {
    func toTuple() throws -> (AnyHashable, DomainModel) {
        return (try tupleKey(), try toDomain())
    }
}

extension Array where Element: DomainTransformable {
    func toDomain() throws -> [Element.DomainModel] {
        try map { try $0.toDomain() }
    }
}

extension Array where Element: TupleTransformable {
    func toDictionary() throws -> [AnyHashable: Element.DomainModel] {
        try map { try $0.toTuple() }.reduce(into: [:]) { $0[$1.0] = $1.1 }
    }
}
