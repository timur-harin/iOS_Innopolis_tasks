import CoreData
import Foundation

public extension CharacterCore {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CharacterCore> {
        return NSFetchRequest<CharacterCore>(entityName: "CharacterCore")
    }

    @NSManaged var id: Int64
    @NSManaged var gender: String?
    @NSManaged var status: String?
    @NSManaged var name: String?
    @NSManaged var species: String?
    @NSManaged var location: String?
    @NSManaged var image: String?
}

extension CharacterCore: Identifiable {}
