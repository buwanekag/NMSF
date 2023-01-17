//
//  MoreMenuItemViewModel.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/5/21.
//

import Foundation
import UIKit
struct MoreMenuItemViewModel {
    
    let menuOptions: MoreMenuItems
    
    var titleText: String {
        switch menuOptions {
        case .refresh:
            return NSLocalizedString("Refresh offline content", comment: "")
        case .notification:
            return NSLocalizedString("Notification settings", comment: "")
        case .about:
            return NSLocalizedString("About this app", comment: "")
        case .privacy:
            return NSLocalizedString("Privacy statement", comment: "")
        }
    }
    
    var icon: UIImage {
        switch menuOptions {
        case .refresh:
            return UIImage(named: "refresh")!
        case .notification:
            return UIImage(named: "chevron_right_sm")!
        case .about:
            return UIImage(named: "chevron_right_sm")!
        case .privacy:
            return UIImage(named: "external_link")!
        }
    }
}
