//
//  ZonePolygonPoint+CustomExtensions.swift
//  NMSF
//
//  Created by Matt Stanford on 5/24/21.
//

import CoreData
import Foundation

extension ZonePolygonPoint {
    static func deleteAndReAdd(_ rawPoints: [[[Double]]]?, zoneEntityId: String, coreDataManager: CoreDataManager) -> NSOrderedSet? {
        
        deletePoints(for: zoneEntityId, coreDataManager: coreDataManager)
        return addPoints(rawPoints, zoneEntityId: zoneEntityId, coreDataManager: coreDataManager)
    }
    
    private static func deletePoints(for zoneEntityId: String, coreDataManager: CoreDataManager) {
        let predicate = NSPredicate(format: "relevantZone.entityId == %@", zoneEntityId)
        return coreDataManager.deleteObjects(ofType: ZonePolygonPoint.self, predicate: predicate)
    }
    
    private static func addPoints(_ rawPoints: [[[Double]]]?, zoneEntityId: String, coreDataManager: CoreDataManager) -> NSOrderedSet? {
        guard let rawPoints = rawPoints else {
            return nil
        }
        
        let points = rawPoints.compactMap { polygon in
            ZonePolygonPointPayload(coordinateArray: polygon.flatMap { $0 })
        }
        
        let managedPoints = points.compactMap { point -> ZonePolygonPoint? in
            if let managedObject = NSEntityDescription.insertNewObject(forEntityName: ZonePolygonPoint.entityName, into: coreDataManager.managedContext) as? ZonePolygonPoint {
                
                managedObject.latitude = point.latitude
                managedObject.longitude = point.longitude
                return managedObject
            } else {
                return nil
            }
        }
        
        return NSOrderedSet(array: managedPoints)
        
    }
}
