public enum CharactersError: Error {
    case marvel(code: String, message: String)
    case notFound
    case underlying(Error)
}

public typealias CharacterCompletion = (_ result: Result<Character, CharactersError>) -> Void

public typealias CharactersCompletion = (_ result: Result<[Character], CharactersError>) -> Void

public protocol CharactersProviderContract {
    func characters(nameStartsWith: String?,
                    orderBy: Order,
                    completion: @escaping CharactersCompletion)
    func character(_ id: Int,
                   completion: @escaping CharacterCompletion)
}
