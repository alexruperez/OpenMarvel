import Domain
import Moya

enum CharactersService: Service {
    case characters(nameStartsWith: String?, orderBy: Order)
    case character(id: Int)

    var baseURLString: String { "https://gateway.marvel.com:443/v1/public" }

    var mockName: String { "character" }

    var parameters: [String : Any] { ["apikey": "acf7c2130d3523a49e85b76222973315"] }

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
        case let .characters(nameStartsWith, orderBy):
            let order = orderBy == .descending ? "-" : ""
            var parameters = self.parameters
            parameters["orderBy"] = "\(order)name"
            parameters["nameStartsWith"] = nameStartsWith
            return .requestParameters(parameters: parameters,
                                      encoding: encoding)
        case .character:
            return .requestPlain
        }
    }
}
