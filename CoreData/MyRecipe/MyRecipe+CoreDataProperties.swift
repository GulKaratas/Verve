//
//  MyRecipe+CoreDataProperties.swift
//  Verve
//
//  CCreated by Gül Karataş on 8.05.2024.
//
//

import Foundation
import UIKit
import CoreData


extension MyRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyRecipe> {
        return NSFetchRequest<MyRecipe>(entityName: "MyRecipe")
    }

    @NSManaged public var deletedData: Date?
    @NSManaged public var img: UIImage?
    @NSManaged public var ingredients: String?
    @NSManaged public var method: String?
    @NSManaged public var name: String?

}

extension MyRecipe : Identifiable {

}
