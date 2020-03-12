public enum CharactersError: Error {
    case marvel(code: String, message: String)
    case notFound
    case underlying(Error)

    public var localizedDescription: String {
        switch self {
        case .marvel(_, let message):
            return message
        case .notFound:
            return "Character not found."
        case .underlying:
            return "Ooops, an unknown error occurred."
        }
    }
}

public typealias CharacterCompletion = (_ result: Result<Character, CharactersError>) -> Void

public typealias CharactersCompletion = (_ result: Result<[Character], CharactersError>) -> Void

public protocol CharactersProviderContract {
    func characters(nameStartsWith: String?,
                    offset: Int?,
                    orderBy: Order,
                    completion: @escaping CharactersCompletion)
    func character(_ id: Int,
                   completion: @escaping CharacterCompletion)
}
