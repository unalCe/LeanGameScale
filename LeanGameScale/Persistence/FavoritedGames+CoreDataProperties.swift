//
//  FavoritedGames+CoreDataProperties.swift
//  
//
//  Created by Unal Celik on 7.08.2020.
//
//

import Foundation
import CoreData


extension FavoritedGames {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritedGames> {
        return NSFetchRequest<FavoritedGames>(entityName: "FavoritedGames")
    }

    @NSManaged public var id: Int32
    @NSManaged public var imageData: Data?
    @NSManaged public var metacritic: Float
    @NSManaged public var name: String?
    @NSManaged public var genres: String?

}
