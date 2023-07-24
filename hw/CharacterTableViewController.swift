import UIKit

class CharacterTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CharacterTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with character: Character) {
        textLabel?.text = character.name
        detailTextLabel?.text = "Status: \(character.status)"
        imageView?.image = UIImage(named: character.image)        
    }
}

