//
//  AppDelegate.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 3/29/21.
//

import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let splashViewController = SplashViewController(nibName: SplashViewController().className, bundle: nil)
        let navigationController = UINavigationController(rootViewController: splashViewController)
        
        navigationController.setNavigationBarHidden(true, animated: false)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
}
//
//extension AppDelegate: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        if region is CLCircularRegion {
//            handleEvent(for: region)
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        if region is CLCircularRegion {
//            handleEvent(for: region)
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        let settingsAlert = UIAlertController(
//            title: "Change location settings",
//            message: "Please set to ‘Always’ to let us send you notifications for learning more about the area of the Keys you are in.",
//            preferredStyle: .alert)
//
//        let noThanksAction = UIAlertAction(title: "No Thanks", style: .default)
//        
//        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
//            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
//                UIApplication.shared.open(appSettings)
//            }
//        }
//        
//        settingsAlert.addAction(noThanksAction)
//        settingsAlert.addAction(settingsAction)
//        
//        if let rootViewController = window?.rootViewController {
//            rootViewController.present(settingsAlert, animated: true)
//        }
//    }
//    
//    func handleEvent(for region: CLRegion) {
//        print("IN RANGE")
//        
//        if UIApplication.shared.applicationState == .active {
//            guard let message = getSiteNote(from: region.identifier) else { return }
//            
//            window?.rootViewController?.showAlert(title: nil, message: message, onDismiss: nil)
//        } else {
//            guard let body = getSiteNote(from: region.identifier) else { return }
//            
//            let notificationContent = UNMutableNotificationContent()
//            notificationContent.body = body
//            notificationContent.sound = .default
//            notificationContent.badge = UIApplication.shared
//                .applicationIconBadgeNumber + 1 as NSNumber
//            
//            let trigger = UNTimeIntervalNotificationTrigger(
//                timeInterval: 1,
//                repeats: false)
//            
//            let request = UNNotificationRequest(
//                identifier: "location_change",
//                content: notificationContent,
//                trigger: trigger)
//            
//            userNotificationCenter.add(request) { error in
//                if let error = error {
//                    print("Error: \(error)")
//                }
//            }
//        }
//    }
//    
//    func getSiteNote(from identifier: String) -> String? {
//        let siteNotifications = SiteNotification.allSiteNotifications()
//        let matched = siteNotifications.first { $0.identifier == identifier }
//        return matched?.note
//    }
//}
//
