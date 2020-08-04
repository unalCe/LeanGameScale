//
//  CDGame+CoreDataProperties.swift
//  
//
//  Created by Unal Celik on 4.08.2020.
//
//

import Foundation
import CoreData


extension CDGame {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDGame> {
        return NSFetchRequest<CDGame>(entityName: "CDGame")
    }

    @NSManaged public var name: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var metacritic: Float
    @NSManaged public var imageData: Data?

}
