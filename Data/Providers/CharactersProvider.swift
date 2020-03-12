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
                           offset: Int?,
                           orderBy: Order,
                           completion: @escaping CharactersCompletion) {
        provider.request(.characters(nameStartsWith: nameStartsWith,
                                     offset: offset,
                                     orderBy: orderBy)) { result in
            switch result {
            case let .success(response):
                do {
                    let characters = try response.map(ResponseEntity.self).data.results.toDomain()
                    completion(.success(characters))
                } catch let MoyaError.objectMapping(mappingError, response) {
                    do {
                        let errorEntity = try response.map(ErrorEntity.self)
                        completion(.failure(.marvel(code: errorEntity.code,
                                                    message: errorEntity.message)))
                    } catch {
                        completion(.failure(.underlying(mappingError)))
                    }
                } catch {
                    completion(.failure(.underlying(error)))
                }
            case let .failure(error):
                completion(.failure(.underlying(error)))
            }
        }
    }

    public func character(_ id: Int, completion: @escaping CharacterCompletion) {
        provider.request(.character(id)) { result in
            switch result {
            case let .success(response):
                do {
                    let characters = try response.map(ResponseEntity.self).data.results.toDomain()
                    if let character = characters.first {
                        completion(.success(character))
                    } else {
                        completion(.failure(.notFound))
                    }
                } catch let MoyaError.objectMapping(_, response) {
                    do {
                        let errorEntity = try response.map(ErrorEntity.self)
                        completion(.failure(.marvel(code: errorEntity.code,
                                                    message: errorEntity.message)))
                    } catch {
                        completion(.failure(.underlying(error)))
                    }
                } catch {
                    completion(.failure(.underlying(error)))
                }
            case let .failure(error):
                completion(.failure(.underlying(error)))
            }
        }
    }
}
