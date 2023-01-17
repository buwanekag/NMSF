//
//  ZoneJsonPayload.swift
//  NMSF
//
//  Created by Matt Stanford on 5/24/21.
//

import Combine
import Foundation

struct ZoneJsonPayload: Codable, JsonPayloadType {
    let id: String?
    let attributes: Attributes?
    let relationships: Relationships?
    
    struct Attributes: Codable {
        let label: String?
        let aboutDescription: String?
        let region: [[[Double]]]?
        let helpContact: [String]?
        
        private enum CodingKeys: String, CodingKey {
            case label,region,helpContact
            case aboutDescription = "description"
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            if let region = try? container.decodeIfPresent([[[Double]]].self, forKey: .region) {
                self.region = region
            } else if let region = try? container.decodeIfPresent([[Double]].self, forKey: .region) {
                self.region = [region]
            } else {
                self.region = nil
            }
            
            label = try container.decodeIfPresent(String.self, forKey: .label)
            aboutDescription = try container.decodeIfPresent(String.self, forKey: .aboutDescription)
            helpContact = try container.decodeIfPresent([String].self, forKey: .helpContact)
        }
    }
    
    struct Relationships: Codable {
        let supportsActivity: JsonResourceLinkArray?
        let habitats: JsonResourceLinkArray?
        let zoneType: JsonResourceLink?
    }
    
    func createEntity(coreDataManager: CoreDataManager, includedMap: [String : JSON]?) -> Zone? {
        guard let entityId = id,
              //Putting this here to filter out bad ViaPlace data for now
              self.attributes?.region != nil,
            let entity = coreDataManager.getExistingOrAddNew(ofType: Zone.self, entityId: entityId) else {
            return nil
        }
        coreDataManager.managedContext.performAndWait {
            
            entity.name = attributes?.label
            entity.aboutDescription = attributes?.aboutDescription
            
            if let activities: [Activity] = JsonHelpers.getEntitiesFrom(ActivityJsonPayload.self, coreDateManager: coreDataManager, links: relationships?.supportsActivity, includedMap: includedMap) {
                entity.activities = NSSet(array: activities)
            } else {
                entity.activities = nil
            }
            
            if let habitats: [Habitat] = JsonHelpers.getEntitiesFrom(HabitatJsonPayload.self, coreDateManager: coreDataManager, links: relationships?.habitats, includedMap: includedMap) {
                entity.habitats = NSSet(array: habitats)
            } else {
                entity.habitats = nil
            }
                        
            entity.polygonPoints = ZonePolygonPoint.deleteAndReAdd(attributes?.region, zoneEntityId: entityId, coreDataManager: coreDataManager)
            
            entity.helpContacts = ZoneContact.deleteAndReAdd(attributes?.helpContact, zoneEntityId: entityId, coreDataManager: coreDataManager)
            
            entity.zoneType = JsonHelpers.getEntityFrom(ZoneTypeJsonPayload.self, coreDateManager: coreDataManager, link: relationships?.zoneType, includedMap: includedMap)
        }
        
        return entity
    }
}
