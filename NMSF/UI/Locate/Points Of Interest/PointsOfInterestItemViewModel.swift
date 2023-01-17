//
//  PointsOfInterestItemViewModel.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/3/21.
//

import Foundation
enum PointOfInterest {
    case zone
    case site
}
struct PointsOfInterestItemViewModel {
    
    let type: PointOfInterest
    let stories: [Story]
    let tags: [String]
    
    private let numTagsToShow = 2
    
    var truncatedTagsList: [String] {
        var adjustedTagList = Array(tags.prefix(numTagsToShow))
        let numRemaining = tags.count - numTagsToShow
        
        if numRemaining == 1 {
            adjustedTagList.append(tags[numTagsToShow])
        } else if numRemaining > 1 {
            adjustedTagList.append("+\(numRemaining)")
        }
        
        return adjustedTagList
    }
    
    var title: String {
    
        if type == .site {
            return Constants.Locate.PointsOfInterest.site
        } else {
            return Constants.Locate.PointsOfInterest.zone
        }
    }
}
