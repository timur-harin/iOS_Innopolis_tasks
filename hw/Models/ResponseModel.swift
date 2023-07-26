import Foundation

struct CharacterResponseModel: Codable {
    let info: Info
    let results: [ResponseCharacter]
}

struct Info: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}

struct ResponseCharacter: Codable {
    let id: Int
    let name, species, type: String
    let status: ResponseStatus
    let gender: ResponseGender
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Location: Codable {
    let name: String
    let url: String
}

enum ResponseGender: String, Codable {
    case female
    case male
    case genderless
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        switch rawValue {
        case "Female": self = .female
        case "Male": self = .male
        case "Genderless": self = .genderless
        case "unknown": self = .unknown
        default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid gender value")
        }
    }
}

enum ResponseStatus: String, Codable {
    case alive
    case dead
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)

        switch rawValue {
        case "Alive": self = .alive
        case "Dead": self = .dead
        case "unknown": self = .unknown
        default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid status value")
        }
    }
}
