public final class CharactersUseCase {
    let provider: CharactersProviderContract

    public init(_ provider: CharactersProviderContract) {
        self.provider = provider
    }

    public func characters(nameStartsWith: String?,
                           orderBy: Order,
                           completion: @escaping CharactersCompletion) {
        provider.characters(nameStartsWith: nameStartsWith, orderBy: orderBy, completion: completion)
    }

    public func character(id: Int, completion: @escaping CharacterCompletion) {
        provider.character(id: id, completion: completion)
    }
}
