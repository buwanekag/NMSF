//
//  SiteJsonPayload.swift
//  NMSF
//
//  Created by Matt Stanford on 5/21/21.
//

import Combine
import Foundation

struct SiteJsonPayload: Codable, JsonPayloadType {
    let id: String?
    let attributes: Attributes?
    let relationships: Relationships?
    
    struct Attributes: Codable {
        let label: String?
        let aboutDescription: String?
        let latitude: Double?
        let longitude: Double?
        let helpContact: [String]?
        
        private enum CodingKeys: String, CodingKey {
            case label, latitude, longitude, helpContact
            case aboutDescription = "description"
        }
    }
    
    struct Relationships: Codable {
        let supportsActivity: JsonResourceLinkArray?
        let siteType: JsonResourceLink?
        let habitats: JsonResourceLinkArray?
        let containedIn: JsonResourceLink?
    }
    
    func createEntity(coreDataManager: CoreDataManager, includedMap: [String: JSON]?) -> Site? {
        guard let entityId = id,
              //Putting this here to filter out bad ViaPlace data for now
              attributes?.latitude != nil && attributes?.longitude != nil,
            let entity = coreDataManager.getExistingOrAddNew(ofType: Site.self, entityId: entityId) else {
            return nil
        }
       
        coreDataManager.managedContext.performAndWait {
            entity.name = attributes?.label
            entity.aboutDescription = attributes?.aboutDescription
            if let latitude = attributes?.latitude {
                entity.latitude = latitude
            }
            if let longitude = attributes?.longitude {
                entity.longitude = longitude
            }
            
            if let activities: [Activity] = JsonHelpers.getEntitiesFrom(ActivityJsonPayload.self, coreDateManager: coreDataManager, links: relationships?.supportsActivity, includedMap: includedMap) {
                entity.activities = NSSet(array: activities)
            } else {
                entity.activities = nil
            }
            
            if let habitats: [Habitat] = JsonHelpers.getEntitiesFrom(HabitatJsonPayload.self, coreDateManager: coreDataManager, links: relationships?.supportsActivity, includedMap: includedMap) {
                entity.habitats = NSSet(array: habitats)
            } else {
                entity.habitats = nil
            }
            
            entity.siteType = JsonHelpers.getEntityFrom(SiteTypeJsonPayload.self, coreDateManager: coreDataManager, link: relationships?.siteType, includedMap: includedMap)
            
            entity.helpContacts = SiteContact.deleteAndReAdd(attributes?.helpContact, siteEntityId: entityId, coreDataManager: coreDataManager)
            
            /*
                Only retrieving an existing or adding a "shell" object,
                if we create a "shell", the zone should eventually be filled
                in via the /zone endpoint.
            */
            if let containedInZoneId = relationships?.containedIn?.data?.id {
                entity.containedIn = coreDataManager.getExistingOrAddNew(ofType: Zone.self, entityId: containedInZoneId)
            }
            
        }
        
        return entity
    }
}
