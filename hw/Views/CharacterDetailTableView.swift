import UIKit

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

    @available(*, unavailable)
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
