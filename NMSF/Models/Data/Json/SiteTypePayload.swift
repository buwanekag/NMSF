//
//  SiteTypePayload.swift
//  NMSF
//
//  Created by Matt Stanford on 5/21/21.
//

import Combine
import Foundation

struct SiteTypeJsonPayload: Codable, JsonPayloadType {
    let id: String?
    let attributes: Attributes?
    let relationships: Relationships?
    
    struct Attributes: Codable {
        let label: String
    }
    
    struct Relationships: Codable {}
    
    func createEntity(coreDataManager: CoreDataManager, includedMap: [String: JSON]?) -> SiteType? {
        guard let entityId = id,
            let entity = coreDataManager.getExistingOrAddNew(ofType: SiteType.self, entityId: entityId) else {
            return nil
        }
        
        coreDataManager.managedContext.performAndWait {
            entity.name = attributes?.label
        }
        
        return entity
    }
}

