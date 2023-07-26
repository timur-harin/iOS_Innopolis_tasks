//
//  CharacterModel+CoreDataProperties.swift
//  hw
//
//  Created by Timur Kharin on 25.07.2023.
//
//

import Foundation
import CoreData


extension CharacterModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterModel> {
        return NSFetchRequest<CharacterModel>(entityName: "CharacterModel")
    }

    @NSManaged public var id: Int64
    @NSManaged public var gender: String?
    @NSManaged public var status: String?
    @NSManaged public var name: String?
    @NSManaged public var species: String?
    @NSManaged public var location: String?
    @NSManaged public var image: String?

}

extension CharacterModel : Identifiable {

}
