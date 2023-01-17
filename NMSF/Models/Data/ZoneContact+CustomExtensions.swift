//
//  ZoneContact+CustomExtensions.swift
//  NMSF
//
//  Created by Matt Stanford on 5/25/21.
//

import CoreData
import Foundation

extension ZoneContact {
    static func deleteAndReAdd(_ contactStrings: [String]?, zoneEntityId: String, coreDataManager: CoreDataManager) -> NSSet? {
        
        deleteEntities(for: zoneEntityId, coreDataManager: coreDataManager)
        return addEntities(contactStrings, zoneEntityId: zoneEntityId, coreDataManager: coreDataManager)
    }
    
    private static func deleteEntities(for entityId: String, coreDataManager: CoreDataManager) {
        let predicate = NSPredicate(format: "relevantZone.entityId == %@", entityId)
        return coreDataManager.deleteObjects(ofType: ZoneContact.self, predicate: predicate)
    }
    
    private static func addEntities(_ contactStrings: [String]?, zoneEntityId: String, coreDataManager: CoreDataManager) -> NSSet? {
        
        guard let contactStrings = contactStrings else {
            return nil
        }
        
        let entities = contactStrings.compactMap { contactString -> ZoneContact? in
            if let managedObject = NSEntityDescription.insertNewObject(forEntityName: ZoneContact.entityName, into: coreDataManager.managedContext) as? ZoneContact {
                
                managedObject.content = contactString
                return managedObject
            } else {
                return nil
            }
        }
        
        return NSSet(array: entities)
    }
}
