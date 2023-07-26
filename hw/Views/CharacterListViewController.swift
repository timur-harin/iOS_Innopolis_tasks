import CoreData
import UIKit

class CharacterListViewController: UIViewController {
    private let tableView = UITableView()
    private var coreDataService: CoreDataService!
    private var manager: NetworkManger = .init()
    var page = 1
    var previousPage: String? = nil
    var nextPage: String? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rick and Morty Characters"
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
 
        coreDataService = .init(delegate: self)
                
        DispatchQueue.global().async { [weak self] in
            self?.loadCharacters()
            DispatchQueue.main.async { [weak self] in
                self?.reloadData()
            }
        }
        do {
            try coreDataService.frc.performFetch()
        } catch {
            print(error)
        }
        reloadData()
    }
    
    private func reloadData(){
        tableView.reloadData()
    }
    
    private func setupUI() {
        setupTableView()
        setupButtonsView()
    }

    
    private func setupButtonsView(){
        view.backgroundColor = .white
        view.addSubview(nextButton)
        view.addSubview(previousButton)

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)

        previousButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            previousButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            previousButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])

    }

    private func setupTableView() {
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)

        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: -(nextButton.frame.height + 80)).isActive = true
    }
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        return button
    }()

    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Previous", for: .normal)
        return button
    }()

    @objc func nextButtonTapped() {
        manager.pageFetchCharacters(page: page) { result in
            switch result {
            case let .success(responce):
                self.page += 1
//                self.characters = self.mappingCharacter(responce)
                self.tableView.reloadData()
            case .failure:
                print("Error")
                return
            }
        }
    }

    @objc func previousButtonTapped() {
        manager.pageFetchCharacters(page: page - 1) { result in
            switch result {
            case let .success(responce):
                self.page -= 1
//                self.characters = self.mappingCharacter(responce)
                self.tableView.reloadData()
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
    }
}

extension CharacterListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}


extension CharacterListViewController{
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
