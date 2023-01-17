//
//  Zone+CustomExtensions.swift
//  NMSF
//
//  Created by Matt Stanford on 5/24/21.
//

import MapKit
import Foundation

extension Zone: POIType, EntityIdentifiable {
    var habitatsArray: [Habitat]? {
        return habitats?.allObjects as? [Habitat]
    }
    
    var activitiesArray: [Activity]? {
        return activities?.allObjects as? [Activity]
    }
    
    var accessibleBy: [AccessMode]? {
        return accessModes?.allObjects as? [AccessMode]
    }
    
    var mooringBuoyCount: Int? {
        return Int(numMooringBuoys)
    }
    
    var latLng: CLLocation? {
        guard let points = polygonPoints?.array as? [ZonePolygonPoint],
              points.count > 0 else {
            return nil
        }
        var latSum: Double = 0
        var lonSum: Double = 0
        
        points.forEach { point in
            latSum += point.latitude
            lonSum += point.longitude
        }
        
        let averageLat: Double = latSum / Double(points.count)
        let averageLon: Double = lonSum / Double(points.count)
        
        return CLLocation(latitude: averageLat, longitude: averageLon)
    }
    
    var mapPoints: [CLLocationCoordinate2D]? {
        guard let points = polygonPoints?.array as? [ZonePolygonPoint],
              points.count > 0 else {
            return nil
        }
        return points.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)}
    }
    
    var contacts: [String]? {
        guard let helpContacts = helpContacts?.allObjects as? [ZoneContact],
              helpContacts.count > 0 else {
            return nil
        }
        return helpContacts.compactMap { $0.content }
    }
    
    var containedSites: [Site]? {
        guard let siteArray = sites?.allObjects as? [Site] else {
            return []
        }
        return siteArray
    }
}
