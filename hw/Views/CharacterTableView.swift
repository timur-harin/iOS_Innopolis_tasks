import UIKit

class CharacterTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CharacterTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with character: Character, tableView: UITableView, indexPath: IndexPath) {
        textLabel?.text = character.name
        detailTextLabel?.text = "Status: \(character.status)"
        DispatchQueue.main.async {
            self.imageView?.download(from: character.image, contentMode: .scaleAspectFit)
            self.setNeedsLayout()
        }
    }
}
