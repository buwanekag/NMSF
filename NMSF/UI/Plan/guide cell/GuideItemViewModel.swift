//
//  GuideItemViewModel.swift
//  NMSF
//
//  Created by Matt Stanford on 4/28/21.
//

import Foundation

struct GuideItemViewModel {
    
    let guideTitle: String
    let addressString: String
    let distance: Int
    let descriptionText: String
    
    var distanceString: String {
        return Constants.Plan.distanceAway(milesAway: distance)
    }
    
    var a11yText: String {
        return Constants.Plan.guideItemA11yText(title: guideTitle, address: addressString, distance: distance, description: descriptionText)
    }
}
