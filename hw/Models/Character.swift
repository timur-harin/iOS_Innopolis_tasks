import Foundation

struct Character: Codable {
    enum Gender: String, CaseIterable, Codable {
        case female
        case male
        case genderless
        case unknown
    }

    enum Status: String, CaseIterable, Codable {
        case alive
        case dead
        case unknown
    }

    var id: Int
    var name: String
    var status: Status
    var species: String
    var gender: Gender
    var location: String
    var image: String
}
