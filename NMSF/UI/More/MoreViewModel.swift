//
//  MoreViewModel.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/5/21.
//

import Foundation

enum MoreMenuItems: Int, CaseIterable {
    
    case refresh = 0
    case notification
    case about
    case privacy
}


class MoreViewModel: ViewModel {
    let menuOptions: [MoreMenuItems]
    
    init() {
        self.menuOptions = MoreMenuItems.allCases
    }
    
    func menuModel(for index: Int) -> MoreMenuItemViewModel {
        return MoreMenuItemViewModel(menuOptions: menuOptions[index])
    }
}
