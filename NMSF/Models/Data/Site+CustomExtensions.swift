//
//  Site+CustomExtensions.swift
//  NMSF
//
//  Created by Matt Stanford on 5/20/21.
//

import MapKit
import Foundation

extension Site: POIType, EntityIdentifiable {
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
    
    var zoneType: ZoneType? {
        return containedIn?.zoneType
    }
    
    var latLng: CLLocation? {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var contacts: [String]? {
        guard let helpContacts = helpContacts?.allObjects as? [SiteContact],
              helpContacts.count > 0 else {
            return nil
        }
        return helpContacts.compactMap { $0.content }
    }
    var containedSites: [Site]? {
        return nil
    }
}
