//
//  ListItem.swift
//  Verve
//
//  Created by Gül Karataş on 8.05.2024.
//

import Foundation
import UIKit
import CoreData

import Foundation
import CoreData

@objc(ListItem)
public class ListItem: NSManagedObject {

}
public func println(){
    //n
}

extension ListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListItem> {
        return NSFetchRequest<ListItem>(entityName: "ListItem")
    }

    @NSManaged public var desc: String?
    @NSManaged public var id: String?

}

extension ListItem : Identifiable {

}
