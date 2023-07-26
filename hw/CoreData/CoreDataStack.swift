import Foundation
import CoreData

class CoreDataService {
    weak var delegate: NSFetchedResultsControllerDelegate?

    init(delegate: NSFetchedResultsControllerDelegate? = nil) {
        self.delegate = delegate
    }
    
    lazy var frc: NSFetchedResultsController<CharacterCore> = {
        let fetchRequest = CharacterCore.fetchRequest()
        fetchRequest.sortDescriptors = [.init(key: "id", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: PersistentContainer.shared.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = delegate
        return controller
    }()
    
    func fetchCharacters() {
        do {
            try frc.performFetch()
        } catch {
            print(error)
        }
    }
    
    func numberOfCharacters() -> Int {
        guard let sections = frc.sections else { return 0 }
        return sections[0].numberOfObjects
    }
    
    
    func saveCharactersToCoreData(_ characters: [Character]){
        for character in characters {
            PersistentContainer.shared.performBackgroundTask { [character] backgroundContext in
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterCore")
                fetchRequest.predicate = NSPredicate(format: "id == %lld", Int64(character.id))
                let result = try? backgroundContext.fetch(fetchRequest)
                
                if result?.first != nil {
                  return
                } else{
                    let newEntry = CharacterCore(context: backgroundContext)
                    newEntry.id = Int64(character.id)
                    newEntry.name = character.name
                    newEntry.status = character.status.rawValue
                    newEntry.gender = character.gender.rawValue
                    newEntry.species = character.species
                    newEntry.location = character.location
                    newEntry.image = character.image
                    PersistentContainer.shared.saveContext(backgroundContext: backgroundContext)
                }
            }
                
        }
    }
    
    func mappingModel(characterCore: CharacterCore) -> Character {
        Character(
            id: Int(characterCore.id),
            name: characterCore.name ?? "",
            status: Character.Status(rawValue: characterCore.status ?? "") ?? .unknown,
            species: characterCore.species ?? "",
            gender: Character.Gender(rawValue: characterCore.gender ?? "") ?? .unknown,
            location: characterCore.location ?? "",
            image: characterCore.image ?? ""
        )
    }
    
    func fetchCharactersFromCoreData() -> [Character]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterCore")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        var characters: [Character] = .init()
        
        do {
            let result = (try? PersistentContainer.shared.viewContext.fetch(fetchRequest) as? [CharacterCore]) ?? []
            result.forEach { characterCore in
                characters.append(mappingModel(characterCore: characterCore)
                )
            }
            return characters
        }
    }
    
    func clear() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterCore")
        PersistentContainer.shared.performBackgroundTask { backgroundContext in
            try? backgroundContext.fetch(fetchRequest).forEach { element in
                if let element = element as? CharacterCore {
                    backgroundContext.delete(element)
                }
            }
            PersistentContainer.shared.saveContext(backgroundContext: backgroundContext)
        }
    }
    
    
    func fetchCharacter(at indexPath: IndexPath) -> CharacterCore {
        frc.object(at: indexPath)
    }
    
    func fetchChracter(id: Int64) -> CharacterCore? {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterCore")
            fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
            let results = try PersistentContainer.shared.viewContext.fetch(fetchRequest) as? [CharacterCore]
            return results?.first
        } catch {
            return nil
        }
    }
    
    func updateCharacter(_ character: Character) {
        guard let existingCharacter = fetchChracter(id: Int64(character.id)) else {
            
            return
        }
        
        existingCharacter.name = character.name
        existingCharacter.status = character.status.rawValue
        existingCharacter.gender = character.gender.rawValue
        existingCharacter.species = character.species
        existingCharacter.location = character.location
        existingCharacter.image = character.image
        
        PersistentContainer.shared.saveContext()
    }

    
}
