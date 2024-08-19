//
//  Trip+CoreDataProperties.swift
//  Travel Buddy
//
//  Created by Admin on 2024-08-17.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var startingLocation: String?
    @NSManaged public var destination: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var expenses: Expense?

}

extension Trip : Identifiable {

}
