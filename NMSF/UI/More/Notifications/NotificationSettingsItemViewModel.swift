//
//  NotificationSettingsItemViewModel.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/6/21.
//

import Foundation

struct NotificationSettingsItemViewModel {
    
    let menuOptions: NotificationSettingsItems
    
    var titleText: String {
        switch menuOptions {
        case .approachLocation:
            return "Notify me when I approach a location saved in my Plan"
        case .pushNotification:
            return "Receive important push notifications about the sanctuary"
        case .notificationSound:
            return "Notification Sounds"
        }
    }
    
    var isSelected: Bool {
        switch menuOptions {
        case let .approachLocation(isSelected: selection):
            return selection
        case let .pushNotification(isSelected: selection):
            return selection
        case let .notificationSound(isSelected: selection):
            return selection
        }
    }
}
