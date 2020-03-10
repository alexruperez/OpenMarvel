import Domain
import Moya

public final class CharactersProvider: CharactersProviderContract {
    let provider: MoyaProvider<CharactersService>

    public convenience init() {
        self.init(MoyaProvider<CharactersService>())
    }

    init(_ provider: MoyaProvider<CharactersService>) {
        self.provider = provider
    }

    public func characters(nameStartsWith: String?,
                           orderBy: Order,
                           completion: @escaping CharactersCompletion) {
        provider.request(.characters(nameStartsWith: nameStartsWith, orderBy: orderBy)) { result in
            switch result {
            case let .success(response):
                do {
                    let characters = try response.map([CharacterEntity].self).toDomain()
                    completion(.success(characters))
                } catch {
                    completion(.failure(.underlying(error)))
                }
            case let .failure(error):
                completion(.failure(.underlying(error)))
            }
        }
    }

    public func character(id: Int, completion: @escaping CharacterCompletion) {
        provider.request(.character(id: id)) { result in
            switch result {
            case let .success(response):
                do {
                    let character = try response.map(CharacterEntity.self).toDomain()
                    completion(.success(character))
                } catch {
                    completion(.failure(.underlying(error)))
                }
            case let .failure(error):
                completion(.failure(.underlying(error)))
            }
        }
    }
}
