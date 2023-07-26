import UIKit

protocol CharacterListViewDelegate: AnyObject {
    func nextButtonTapped()
    func previousButtonTapped()
}

class CharacterListView: UIView {
    weak var delegateButtons: CharacterListViewDelegate?

    private let tableView = UITableView()
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

    weak var delegate: UITableViewDelegate? {
        get { return tableView.delegate }
        set { tableView.delegate = newValue }
    }

    var dataSource: UITableViewDataSource? {
        get { return tableView.dataSource }
        set { tableView.dataSource = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setupUI()
    }

    private func setupUI() {
        setupTableView()
        setupButtonsView()
    }

    private func setupButtonsView() {
        backgroundColor = .white
        addSubview(nextButton)
        addSubview(previousButton)

        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)

        previousButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nextButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            previousButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            previousButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }

    @objc private func nextButtonTapped() {
        delegateButtons?.nextButtonTapped()
    }

    @objc private func previousButtonTapped() {
        delegateButtons?.previousButtonTapped()
    }

    private func setupTableView() {
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)

        addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: -(nextButton.frame.height + 80)).isActive = true
    }

    func reloadData() {
        tableView.reloadData()
    }
}
