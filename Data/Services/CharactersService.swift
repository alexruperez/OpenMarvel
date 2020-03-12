import Domain
import Moya

enum CharactersService: Service {
    case characters(nameStartsWith: String?, offset: Int?, orderBy: Order)
    case character(_ id: Int)

    var baseURLString: String { "https://gateway.marvel.com:443/v1/public" }

    var mockName: String { "character" }

    var parameters: [String: Any] { (try? AuthenticationEntity().toDictionary()) ?? [:] }

    var path: String {
        switch self {
        case .characters:
            return "/characters"
        case let .character(id):
            return "/characters/\(id)"
        }
    }

    var task: Task {
        switch self {
        case let .characters(nameStartsWith, offset, orderBy):
            let order = orderBy == .descending ? "-" : ""
            var parameters = self.parameters
            parameters["orderBy"] = "\(order)name"
            parameters["nameStartsWith"] = nameStartsWith
            parameters["offset"] = offset
            return .requestParameters(parameters: parameters,
                                      encoding: encoding)
        case .character:
            return .requestParameters(parameters: parameters,
                                      encoding: encoding)
        }
    }
}
