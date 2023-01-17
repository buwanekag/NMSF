//
//  ZoneTypeJsonPayload.swift
//  NMSF
//
//  Created by Matt Stanford on 5/25/21.
//

import Foundation

struct ZoneTypeJsonPayload: Codable, JsonPayloadType {
    let id: String?
    let attributes: Attributes?
    let relationships: Relationships?
    
    struct Attributes: Codable {
        let label: String?
        let abbreviation: String?
        let textDescription: String?
        
        private enum CodingKeys: String, CodingKey {
            case label, abbreviation
            case textDescription = "description"
        }
    }
    
    struct Relationships: Codable {}
    
    func createEntity(coreDataManager: CoreDataManager, includedMap: [String: JSON]?) -> ZoneType? {
        guard let entityId = id,
            let entity = coreDataManager.getExistingOrAddNew(ofType: ZoneType.self, entityId: entityId) else {
            return nil
        }
        
        coreDataManager.managedContext.performAndWait {
            entity.name = attributes?.label
            entity.abbreviation = attributes?.abbreviation
            entity.textDescription = attributes?.textDescription
        }
        
        return entity
    }
}
