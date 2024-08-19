//
//  Expense+CoreDataProperties.swift
//  Travel Buddy
//
//  Created by Admin on 2024-08-17.
//
//

import Foundation
import CoreData


extension Expense {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }

    @NSManaged public var amount: Double
    @NSManaged public var name: String?
    @NSManaged public var trip: Trip?

}

extension Expense : Identifiable {

}
