public enum CharactersError: Error {
    case underlying(Error)
}

public typealias CharacterCompletion = (_ result: Result<Character, CharactersError>) -> Void

public typealias CharactersCompletion = (_ result: Result<[Character], CharactersError>) -> Void


public protocol CharactersProviderContract {
    func characters(nameStartsWith: String?,
                    orderBy: Order,
                    completion: @escaping CharactersCompletion)
    func character(id: Int,
                   completion: @escaping CharacterCompletion)
}
