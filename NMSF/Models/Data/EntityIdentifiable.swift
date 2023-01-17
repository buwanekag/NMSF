//
//  EntityIdentifiable.swift
//  NMSF
//
//  Created by Matt Stanford on 5/20/21.
//

import Foundation
import CoreData

protocol EntityIdentifiable where Self: NSManagedObject {
    var entityId: String? { get set }
}

extension EntityIdentifiable {
    static func objectPredicate(entityId: String) -> NSPredicate? {
        return NSPredicate(format: "entityId == %@", entityId)
    }
}
