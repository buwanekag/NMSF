//
//  PlanItemViewModel.swift
//  NMSF
//
//  Created by Matt Stanford on 4/28/21.
//

import CoreLocation
import Foundation

class PointsOfInterestListItemViewModel {
    let poi: POIType
    let userLocation: CLLocation?
    var inEditMode: Bool = false
    
    private let numTagsToShow = 2
    
    init(poi: POIType, userLocation: CLLocation?, inEditMode: Bool = false) {
        self.poi = poi
        self.userLocation = userLocation
        self.inEditMode = inEditMode
    }
    
    var title: String {
        return poi.name ?? ""
    }
    
    var distance: Int? {
        guard let userLocation = userLocation,
              let poiCenter = poi.latLng else {
            return nil
        }
        let distanceInMeters = userLocation.distance(from: poiCenter)
        let distanceInMiles = distanceInMeters * Constants.Measurement.metersInAMile
        return Int(distanceInMiles)
    }
    
    var tags: [String] {
        var tags: [String] = []
        
        if let activities = poi.activitiesArray {
            let activityNames = activities.compactMap { $0.name }
            tags.append(contentsOf: activityNames)
        }
        
        poi.habitatsArray?.forEach { habitat in
            if let habitatName = habitat.name {
                tags.append(habitatName)
            }
        }
        
        return tags
    }
    
    var locationText: String? {
        if let distance = distance {
            return Constants.Plan.distanceAway(milesAway: distance)
        } else if let poiCenter = poi.latLng {
            return poiCenter.stringInDecimalDegrees(decimalPrecision: 2)
        } else {
            return nil
        }
    }
    
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
    
    var hideBookmark: Bool {
        
        return !poi.isBookmarked
    }
    
    var hideDeleteButton: Bool {
        return !inEditMode
    }
    
    var a11yText: String {
        if inEditMode {
            if let distance = distance {
                return Constants.Plan.planItemA11yTextInDeleteMode(title: title, distance: distance, tags: tags)
            } else {
                return Constants.Plan.planItemA11yTextInDeleteModeNoDistance(title: title, tags: tags)
            }
        } else {
            if let distance = distance {
                return Constants.Plan.planItemA11yText(title: title, distance: distance, tags: tags)
            } else {
                return Constants.Plan.planItemA11yTextNoDistance(title: title, tags: tags)
            }
        }
    }
}
