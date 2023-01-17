//
//  POIType.swift
//  NMSF
//
//  Created by Matt Stanford on 5/25/21.
//

import CoreData
import MapKit
import Foundation

protocol POIType: NSManagedObject {
    var entityId: String? { get }
    var name: String? { get }
    var zoneType: ZoneType? { get }
    var latLng: CLLocation? { get }
    var aboutDescription: String? { get }
    var activitiesArray: [Activity]? { get }
    var habitatsArray: [Habitat]? { get }
    var accessibleBy: [AccessMode]? { get }
    var mooringBuoyCount: Int? { get }
    var contacts: [String]? { get }
    var isBookmarked: Bool { get set }
    var containedSites: [Site]? {get}
}

extension POIType {
    func setBookmark(isSet: Bool, coreDataManager: CoreDataManager) {
        coreDataManager.managedContext.performAndWait {
            self.isBookmarked = isSet
        }

        coreDataManager.managedContext.perform {
            do {
                try coreDataManager.managedContext.save()
            } catch {
                print("Error saving bookmark: \(error.localizedDescription)")
            }
        }
    }
}
