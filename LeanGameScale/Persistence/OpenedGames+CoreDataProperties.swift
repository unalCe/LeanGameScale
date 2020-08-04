//
//  OpenedGames+CoreDataProperties.swift
//  
//
//  Created by Unal Celik on 4.08.2020.
//
//

import Foundation
import CoreData


extension OpenedGames {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OpenedGames> {
        return NSFetchRequest<OpenedGames>(entityName: "OpenedGames")
    }

    @NSManaged public var gameId: Int32

}
