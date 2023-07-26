import CoreData
import UIKit

class CharacterListViewController: UIViewController {
    private let tableView = UITableView()
    private var coreDataService: CoreDataService!
    private var manager: NetworkManger = .init()
    var page = 1
    var previousPage: String? = nil
    var nextPage: String? = nil

    lazy var characterListView: CharacterListView = {
        let view = CharacterListView(frame: .zero)
        view.delegate = self
        view.dataSource = self
        view.delegateButtons = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rick and Morty Characters"

        setupUI()

        coreDataService = .init(delegate: self)

        DispatchQueue.global().async { [weak self] in
            self?.loadCharacters()
            DispatchQueue.main.async { [weak self] in
                self?.characterListView.reloadData()
            }
        }
        do {
            try coreDataService.frc.performFetch()
        } catch {
            print(error)
        }
        characterListView.reloadData()
    }

    private func setupUI() {
        view.addSubview(characterListView)
        characterListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(staticConstraints())
    }
    
    

    private func staticConstraints() -> [NSLayoutConstraint] {
        return [
            characterListView.topAnchor.constraint(equalTo: view.topAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }
}

extension CharacterListViewController: CharacterListViewDelegate {
    func nextButtonTapped() {
        manager.pageFetchCharacters(page: page) { result in
            switch result {
            case let .success(responce):
                self.page += 1
                self.characterListView.reloadData()
            case .failure:
                print("Error")
                return
            }
        }
    }

    func previousButtonTapped() {
        manager.pageFetchCharacters(page: page - 1) { result in
            switch result {
            case let .success(responce):
                self.page -= 1
                self.characterListView.reloadData()
            case .failure:
                print("Error")
                return
            }
        }
    }
}

extension CharacterListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataService.numberOfCharacters()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as! CharacterTableViewCell
        let entity = coreDataService.frc.object(at: IndexPath(row: indexPath.row, section: indexPath.section))
        let character = coreDataService.mappingModel(characterCore: entity)
        cell.configure(with: character, tableView: tableView, indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = coreDataService.frc.object(at: IndexPath(row: indexPath.row, section: indexPath.section))
        let character = coreDataService.mappingModel(characterCore: entity)
        let detailViewController = CharacterDetailViewController(character: character)
        detailViewController.delegate = self
        present(detailViewController, animated: true)
    }
}

extension CharacterListViewController: CharacterDetailDelegate {
    func characterDetailViewControllerDidUpdateCharacter(_ character: Character) {
          coreDataService.updateCharacter(character)
        characterListView.reloadData()
    }
}

extension CharacterListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        characterListView.reloadData()
    }
}

extension CharacterListViewController {
    func mappingCharacter(_ response: CharacterResponseModel) -> [Character] {
        var results: [Character] = .init()

        previousPage = response.info.prev?.description
        nextPage = response.info.next?.description

        for result in response.results {
            var status: Character.Status = .unknown
            switch result.status {
            case .alive:
                status = .alive
            case .dead:
                status = .dead
            case .unknown:
                status = .unknown
            }

            var gender: Character.Gender = .unknown
            switch result.gender {
            case .female:
                gender = .female
            case .genderless:
                gender = .genderless
            case .male:
                gender = .male
            case .unknown:
                gender = .unknown
            }
            let character = Character(
                id: result.id, name: result.name, status: status,
                species: result.species, gender: gender,
                location: result.location.name, image: result.image)

            results.append(character)
        }
        return results
    }

    func loadCharacters() {
        manager.fetchCharacters { [weak self] result in
            switch result {
            case let .success(responce):
                let data = self?.mappingCharacter(responce) ?? []
                self?.coreDataService.saveCharactersToCoreData(data)
            case .failure:
                return
            }
        }
    }
}

