//
//  Person+CoreDataProperties.swift
//  TestCases
//
//  Created by LAP1120 on 16/10/25.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?

}

extension Person : Identifiable {

}
