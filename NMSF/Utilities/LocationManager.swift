//
//  LocationManager.swift
//  NMSF
//
//  Created by Matt Stanford on 5/25/21.
//

import CoreLocation
import Foundation
import UIKit

protocol LocationDelegate: UIViewController {
    func gotUpdated(userLocation: CLLocation)
}

class LocationManager: NSObject {
    static var shared = LocationManager()
    
    weak var delegate: LocationDelegate?
    
    var lastUserLocation: CLLocation?
    
    private var locationManager = CLLocationManager()
    
    private var hasRequestedToChangeSettings = false

    func startLocationServices() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            let lastLocation = locations[locations.count - 1]
            lastUserLocation = lastLocation
            delegate?.gotUpdated(userLocation: lastLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(for: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            handleEvent(for: region)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if !hasRequestedToChangeSettings {
            hasRequestedToChangeSettings = true
            requestToChangeSettings()
        }
    }
}

extension LocationManager {
    // MARK: - Helper Methods
    
    func requestToChangeSettings() {
        let settingsAlert = UIAlertController(
            title: "Change location settings",
            message: "Please set to ‘Always’ to let us send you notifications for learning more about the area of the Keys you are in.",
            preferredStyle: .alert)

        let noThanksAction = UIAlertAction(title: "No Thanks", style: .default)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            settingsAlert.dismiss(animated: true)
            
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }
        
        settingsAlert.addAction(noThanksAction)
        settingsAlert.addAction(settingsAction)
        
        delegate?.present(settingsAlert, animated: true)
    }
    
    func handleEvent(for region: CLRegion) {
        print("IN RANGE")
        
        if UIApplication.shared.applicationState == .active {
            guard let message = getSiteNote(from: region.identifier) else { return }
            
            delegate?.showAlert(title: nil, message: message, onDismiss: nil)
        } else {
            guard let body = getSiteNote(from: region.identifier) else { return }
            
            let notificationContent = UNMutableNotificationContent()
            notificationContent.body = body
            notificationContent.sound = .default
            notificationContent.badge = UIApplication.shared
                .applicationIconBadgeNumber + 1 as NSNumber
            
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: 1,
                repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "location_change",
                content: notificationContent,
                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func getSiteNote(from identifier: String) -> String? {
        let siteNotifications = SiteNotification.allSiteNotifications()
        let matched = siteNotifications.first { $0.identifier == identifier }
        return matched?.note
    }
}
