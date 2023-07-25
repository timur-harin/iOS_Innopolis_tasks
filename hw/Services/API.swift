import Moya

enum API {
    case getCharacters
    case pageGetCharacters(page: Int)
}

extension API: TargetType {
    var baseURL: URL {
        return URL(string: "https://rickandmortyapi.com/api")!
    }

    var path: String {
        switch self {
        case .getCharacters:
            return "/character"
        case .pageGetCharacters(let page):
            return "/character?page=\(page)"
        }
  
    }

    var method: Method {
        switch self {
        case .getCharacters:
            return .get
        case .pageGetCharacters:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getCharacters:
            return .requestPlain
        case .pageGetCharacters:
            return .requestPlain
        
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
