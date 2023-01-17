//
//  NMSFUserDefaults.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/14/21.
//

import Foundation
import CoreLocation

enum PreferencesKeys: String {
    case savedSites
    case addedGeoFences
    case firstLogin
}

class NMSFUserDefaults {
    
    static let shared: NMSFUserDefaults = NMSFUserDefaults()
    
    let userDefaults = UserDefaults.standard
    
}

extension NMSFUserDefaults {
    
     func saveSiteNotifications(sites: [SiteNotification]) {
        let encoder = JSONEncoder()
         
        do {
            let data = try encoder.encode(sites)
            UserDefaults.standard.set(data, forKey: PreferencesKeys.savedSites.rawValue)
            startMonitoring(sites: sites)
        } catch {
            print("error encoding geotifications")
        }
    }
    
    private func startMonitoring(sites: [SiteNotification]) {
        let locationManager = CLLocationManager()
        
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            return
        }
        
        sites.forEach { locationManager.startMonitoring(for: $0.region) }
    }
    
    func addGeoFences() {
        self.userDefaults.set(true, forKey: PreferencesKeys.addedGeoFences.rawValue)
    }
    
    var geoFencesStatus: Bool {
        let status = userDefaults.bool(forKey: PreferencesKeys.addedGeoFences.rawValue)
        return status
    }
}
