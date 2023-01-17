//
//  JsonPayloadType.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/12/21.
//

import Foundation

typealias DecodableJsonPayloadType = JsonPayloadType & Decodable

protocol JsonPayloadType {
    associatedtype AttributeType: Codable
    associatedtype RelationshipType: Codable
    associatedtype EntityType

    var id: String? { get }
    var attributes: AttributeType? { get }
    var relationships: RelationshipType? { get }
    
    func createEntity(coreDataManager: CoreDataManager, includedMap: [String: JSON]?) -> EntityType?
}
