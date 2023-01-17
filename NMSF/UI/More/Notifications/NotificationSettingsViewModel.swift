//
//  NotificationSettingsViewModel.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/5/21.
//

import Foundation

enum NotificationSettingsItems: Hashable {
    case approachLocation(isSelected: Bool)
    case pushNotification(isSelected: Bool)
    case notificationSound(isSelected: Bool)
}

class NotificationSettingsViewModel: ViewModel {
    
    var enableLocation = true
    var enablePushNotification = true
    var enableNotificationSound = true
    
    var sections: [NotificationSettingSection] = [.header, .options]
    
    var menuOptions: [NotificationSettingsItems] = []
    
    init() {
        // Set saved notification prefs
        self.menuOptions = [.approachLocation(isSelected: enableLocation),.pushNotification(isSelected: enablePushNotification),.notificationSound(isSelected: enableNotificationSound)]
    }
    
    func numRows(section: Int) -> Int {
        let section = sections[section]
        
        switch section {
        case .header:
            return 1
        case .options:
            return menuOptions.count
        }
    }
    
    var numSections: Int {
        return sections.count
    }
    
    func menuModel(for index: Int) -> NotificationSettingsItemViewModel {
        return NotificationSettingsItemViewModel(menuOptions: menuOptions[index])
    }
}
