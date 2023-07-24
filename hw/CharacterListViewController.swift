import UIKit

class CharacterListViewController: UIViewController {
    private let tableView = UITableView()
    private var characters: [Character] = [
        Character(id: 1, name: "Jerry Smith", status: Character.Status.alive, species: "Human", gender: Character.Gender.male , location: "Earth", image: "1"),
        Character(id: 2, name: "Evil Morti", status: Character.Status.alive, species: "Human", gender: Character.Gender.male , location: "Citadel", image: "2"),
        Character(id: 3, name: "Jessica", status: Character.Status.alive, species: "Human", gender: Character.Gender.female , location: "Earth", image: "3"),
        Character(id: 4, name: "Fufel Rick", status: Character.Status.alive, species: "Human", gender: Character.Gender.male , location: "Earth (Dimension J19ζ7)", image: "4"),
        Character(id: 5, name: "Evil Rick", status: Character.Status.dead, species: "Human-Cyborg", gender: Character.Gender.male , location: "Cytadel of Ricks", image: "5"),
        Character(id: 6, name: "Ethan", status: Character.Status.alive, species: "Human", gender: Character.Gender.male , location: "Earth", image: "6"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Rick and Morty Characters"
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        
        view.addSubview(tableView)
    
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension CharacterListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as! CharacterTableViewCell
        let character = characters[indexPath.row]
        cell.configure(with: character)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        let detailViewController = CharacterDetailViewController(character: character)
        detailViewController.delegate = self
        present(detailViewController, animated: true, completion: nil)
    }
}

extension CharacterListViewController: CharacterDetailDelegate {
    func characterDetailViewControllerDidUpdateCharacter(_ character: Character) {
        if let index = characters.firstIndex(where: { $0.id == character.id }) {
            characters[index] = character
            tableView.reloadData()
        }
    }
}


