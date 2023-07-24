//
//  CharacterViewController.swift
//  hw
//
//  Created by Timur Kharin on 24.07.2023.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    private let character: Character

    init(character: Character) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
