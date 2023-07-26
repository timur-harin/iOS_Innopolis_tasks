import UIKit

class CharacterDetailView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CharacterDetailTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        addSubview(imageView)
        addSubview(tableView)

        let padding: CGFloat = 20.0

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -padding),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func configure(with character: Character) {
        imageView.download(from: character.image, contentMode: .scaleAspectFit)
        tableView.reloadData()
    }

    func setTableViewDataSource(_ dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }

    func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }

    func reloadData() {
        tableView.reloadData()
    }
}
