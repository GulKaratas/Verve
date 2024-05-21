//
//  BoughtListItem.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.

import Foundation
import UIKit
import CoreData

import Foundation
import CoreData

@objc(BoughtListItem)
public class BoughtListItem: NSManagedObject {

}

extension BoughtListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BoughtListItem> {
        return NSFetchRequest<BoughtListItem>(entityName: "BoughtListItem")
    }

    @NSManaged public var desc: String?
    @NSManaged public var id: String?

}

extension BoughtListItem : Identifiable {

}
