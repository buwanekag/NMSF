//
//  SiteContact+CustomExtensions.swift
//  NMSF
//
//  Created by Matt Stanford on 5/25/21.
//

import CoreData
import Foundation

extension SiteContact {
    
    static func deleteAndReAdd(_ contactStrings: [String]?, siteEntityId: String, coreDataManager: CoreDataManager) -> NSSet? {
        
        deleteEntities(for: siteEntityId, coreDataManager: coreDataManager)
        return addEntities(contactStrings, siteEntityId: siteEntityId, coreDataManager: coreDataManager)
    }
    
    private static func deleteEntities(for entityId: String, coreDataManager: CoreDataManager) {
        let predicate = NSPredicate(format: "relevantSite.entityId == %@", entityId)
        return coreDataManager.deleteObjects(ofType: SiteContact.self, predicate: predicate)
    }
    
    private static func addEntities(_ contactStrings: [String]?, siteEntityId: String, coreDataManager: CoreDataManager) -> NSSet? {
        
        guard let contactStrings = contactStrings else {
            return nil
        }
        
        let entities = contactStrings.compactMap { contactString -> SiteContact? in
            if let managedObject = NSEntityDescription.insertNewObject(forEntityName: SiteContact.entityName, into: coreDataManager.managedContext) as? SiteContact {
                
                managedObject.content = contactString
                return managedObject
            } else {
                return nil
            }
        }
        
        return NSSet(array: entities)
    }
}
