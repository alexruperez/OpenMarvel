public final class CharactersUseCase {
    let provider: CharactersProviderContract

    public init(_ provider: CharactersProviderContract) {
        self.provider = provider
    }

    public func characters(nameStartsWith: String?,
                           offset: Int?,
                           orderBy: Order,
                           completion: @escaping CharactersCompletion) {
        provider.characters(nameStartsWith: nameStartsWith,
                            offset: offset,
                            orderBy: orderBy,
                            completion: completion)
    }

    public func character(_ id: Int, completion: @escaping CharacterCompletion) {
        provider.character(id, completion: completion)
    }
}
