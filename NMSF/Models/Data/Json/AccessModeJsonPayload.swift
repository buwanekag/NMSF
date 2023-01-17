//
//  AccessModeJsonPayload.swift
//  NMSF
//
//  Created by Matt Stanford on 5/20/21.
//

import Combine
import Foundation

struct AccessModeJsonPayload: Decodable, JsonPayloadType {
    let id: String?
    let attributes: Attributes?
    let relationships: Relationships?
    
    struct Attributes: Codable {
        let label: String?
    }
    
    struct Relationships: Codable {}
    
    func createEntity(coreDataManager: CoreDataManager, includedMap: [String: JSON]?) -> AccessMode? {
        guard let entityId = id,
            let entity = coreDataManager.getExistingOrAddNew(ofType: AccessMode.self, entityId: entityId) else {
            return nil
        }
        
        coreDataManager.managedContext.performAndWait {
            entity.name = attributes?.label
        }
    
        return entity
    }
}
