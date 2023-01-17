//
//  NSManagedObject+Identification.swift
//  NMSF
//
//  Created by Matt Stanford on 5/20/21.
//

import Foundation
import CoreData

extension NSManagedObject {
    static var entityName: String {
        return String(describing: self)
    }
}
