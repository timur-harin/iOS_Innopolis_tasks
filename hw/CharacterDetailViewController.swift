import UIKit

protocol CharacterDetailDelegate: AnyObject {
    func characterDetailViewControllerDidUpdateCharacter(_ character: Character)
}

class CharacterDetailViewController: UIViewController {
    
    weak var delegate: CharacterDetailDelegate?

    private var character: Character
    
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFit
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
   }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // Create UIPickerView for gender and status fields
    private lazy var genderPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    

    private lazy var statusPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private func createToolbarWithDoneButton() -> UIToolbar{
        let tool: UIToolbar = .init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        tool.barStyle = .default
        tool.isTranslucent = false
        tool.tintColor = .blue
        tool.sizeToFit ()
        let spaceArea: UIBarButtonItem = .init(systemItem: .flexibleSpace)
        let doneButton: UIBarButtonItem = .init(title: "Done", style: .done, target: self, action:#selector(pickerDoneButtonTapped))
        tool.setItems ([spaceArea, doneButton], animated: false)
        tool.isUserInteractionEnabled = true
        return tool
    }
    
    @objc private func pickerDoneButtonTapped() {
        view.endEditing(true)
        
    }


    init(character: Character) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = character.name
        view.backgroundColor = .systemGray6
        
        let padding: CGFloat = 20.0

        
        view.addSubview(imageView)
        if let image = UIImage(named: character.image) {
            imageView.image = image
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 200),
        ])

        
        tableView.register(CharacterDetailTableViewCell.self, forCellReuseIdentifier: "CustomCell")

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private var fieldOrder: [String] = ["Name", "Status", "Gender", "Species", "Location"]
    
}

extension CharacterDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CharacterDetailTableViewCell
        
        switch fieldOrder[indexPath.row] {
        case "Name":
            cell.textLabel?.text = "Name"
            cell.textField.text = character.name
            cell.textField.addTarget(self, action: #selector(nameTextFieldChanged(_:)), for: .editingChanged)
        case "Status":
            cell.textLabel?.text = "Status"
            cell.textField.text = character.status.description
            cell.textField.inputView = statusPickerView
            cell.textField.inputAccessoryView = createToolbarWithDoneButton()
            statusPickerView.selectRow(Character.Status.allCases.firstIndex(of: character.status)!, inComponent: 0, animated: true)
        case "Gender":
            cell.textLabel?.text = "Gender"
            cell.textField.text = character.gender.description
            cell.textField.inputView = genderPickerView
            cell.textField.inputAccessoryView = createToolbarWithDoneButton()
            genderPickerView.selectRow(Character.Gender.allCases.firstIndex(of: character.gender)!, inComponent: 0, animated: true)
        case "Species":
            cell.textLabel?.text = "Species"
            cell.textField.text = character.species
            cell.textField.addTarget(self, action: #selector(speciesTextFieldChanged(_:)), for: .editingChanged)
        case "Location":
            cell.textLabel?.text = "Location"
            cell.textField.text = character.location
            cell.textField.addTarget(self, action: #selector(locationTextFieldChanged(_:)), for: .editingChanged)
        
        default:
            break
        }

        return cell
    }

    @objc private func nameTextFieldChanged(_ textField: UITextField) {
        character.name = textField.text ?? ""
    }

    @objc private func speciesTextFieldChanged(_ textField: UITextField) {
        character.species = textField.text ?? ""
    }
    
    @objc private func locationTextFieldChanged(_ textField: UITextField) {
        character.location = textField.text ?? ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveChanges()
    }

    private func saveChanges() {
           delegate?.characterDetailViewControllerDidUpdateCharacter(character)
    }
}

extension CharacterDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genderPickerView {
            return Character.Gender.allCases.count
        } else if pickerView == statusPickerView {
            return Character.Status.allCases.count
        }
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genderPickerView {
            return Character.Gender.allCases[row].description
        } else if pickerView == statusPickerView {
            return Character.Status.allCases[row].description
        }
        return nil
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genderPickerView {
            character.gender = Character.Gender.allCases[row]
        } else if pickerView == statusPickerView {
            character.status = Character.Status.allCases[row]
        }
        tableView.reloadData()
    }
}

extension Character.Gender: CustomStringConvertible {
    var description: String {
        switch self {
        case .female:
            return "Female"
        case .male:
            return "Male"
        case .genderless:
            return "Genderless"
        case .unknown:
            return "Unknown"
        }
    }
}

extension Character.Status: CustomStringConvertible {
    var description: String {
        switch self {
        case .alive:
            return "Alive"
        case .dead:
            return "Dead"
        case .unknown:
            return "Unknown"
        }
    }
}


class CharacterDetailTableViewCell: UITableViewCell {
    var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 120).isActive = true
        textField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
}

