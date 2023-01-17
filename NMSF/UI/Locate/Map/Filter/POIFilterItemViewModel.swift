//
//  POIFilterItemViewModel.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/25/21.
//

import Foundation

class POIFilterItemViewModel {
    
    let title: String
    let category: String
    var selected: Bool
    
    init(title: String, category: String, selected: Bool) {
        
        self.title = title
        self.category = category
        self.selected = selected
    }
}
