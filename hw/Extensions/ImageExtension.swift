import CoreData
import UIKit

extension UIImageView {
    func load(characterID: Int, mode: ContentMode, tableView: UITableView, indexPath: IndexPath, completion: (() -> Void)? = nil) {
        if let cachedImage = fetchImageFromCoreData(characterID: characterID) {
            self.image = cachedImage
            self.contentMode = mode
            completion?()
            tableView.reloadRows(at: [indexPath], with: .none)
            return
        }

        let imageUrlString = "https://rickandmortyapi.com/api/character/avatar/\(characterID).jpeg"

        guard let url = URL(string: imageUrlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let downloadedImage = UIImage(data: data) else { return }

            self?.saveImageToCoreData(characterID: characterID, image: downloadedImage)

            DispatchQueue.main.async {
                self?.image = downloadedImage
                self?.contentMode = mode
                completion?()
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        }.resume()
    }

    private func fetchImageFromCoreData(characterID: Int) -> UIImage? {
        let fetchRequest: NSFetchRequest<CharacterCore> = CharacterCore.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", characterID)

        do {
            let context = CoreDataStack.shared.context
            let fetchedCharacters = try context.fetch(fetchRequest)
            if let characterObject = fetchedCharacters.first, let imageData = characterObject.image {
                if let data = Data(base64Encoded: imageData) {
                    return UIImage(data: data)
                } else {
                    return nil
                }
            }
        } catch {
            print("Error fetching image from Core Data: \(error)")
        }

        return nil
    }

    private func saveImageToCoreData(characterID: Int, image: UIImage) {
        if let imageDataString = image.pngData()?.base64EncodedString() {
            let context = CoreDataStack.shared.context

            if let entity = NSEntityDescription.entity(forEntityName: "CharacterCore", in: context) {
                let characterObject = NSManagedObject(entity: entity, insertInto: context)
                characterObject.setValue(characterID, forKey: "id")
                characterObject.setValue(imageDataString, forKey: "image")

                do {
                    try context.save()
                } catch {
                    print("Error saving image to Core Data: \(error)")
                }
            }
        }
    }
}
