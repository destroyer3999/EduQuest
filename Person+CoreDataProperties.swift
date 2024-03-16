//
//  Person+CoreDataProperties.swift
//  EduQuest
//
//  Created by Alumno on 15/03/24.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?

}

extension Person : Identifiable {

}
