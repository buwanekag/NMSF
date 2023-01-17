//
//  JsonHelpers.swift
//  NMSF
//
//  Created by Matt Stanford on 5/21/21.
//

import Combine
import Foundation

class JsonHelpers {
    static func getEntityFrom<T: Decodable & JsonPayloadType>(_ payloadType: T.Type,
                                                              coreDateManager: CoreDataManager,
                                                              link: JsonResourceLink?,
                                                              includedMap: [String: JSON]?) -> T.EntityType? {
        
        guard let link = link else {
            return nil
        }
        
        var payload: T?
        if let entityId = link.data?.id,
           let entityJson = includedMap?[entityId] {
            payload = try? Coder.decode(T.self, from: entityJson)
        }
        
        return payload?.createEntity(coreDataManager: coreDateManager, includedMap: includedMap)
      }
    
    static func getEntitiesFrom<T: Decodable & JsonPayloadType>(_ payloadType: T.Type,
                                                                coreDateManager: CoreDataManager,
                                                                links: JsonResourceLinkArray?,
                                                                includedMap: [String: JSON]?) -> [T.EntityType]? {
        guard let links = links else {
            return nil
        }
        
        let entityIds = links.data.compactMap { $0.id }
        let payloads: [T] = entityIds.compactMap { entityId in
            guard let entityJson = includedMap?[entityId] else {
                return nil
            }
            return try? Coder.decode(T.self, from: entityJson)
        }
        
        let items = payloads.compactMap { $0.createEntity(coreDataManager: coreDateManager, includedMap: includedMap)}
        return items
    }
}
