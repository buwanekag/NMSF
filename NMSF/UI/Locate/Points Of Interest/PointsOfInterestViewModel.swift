//
//  LocateViewModel.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/2/21.
//

import CoreLocation
import UIKit

class PointsOfInterestViewModel: ViewModel {
    var sections: [PointOfInterestSection] = []
    var pointsOfInterestList: [PointsOfInterestListItemViewModel] = []
    var detailSelection: SelectedDetail
    var poi: POIType
    var userLocation: CLLocation?
    
    var coreDataManager = DataFeedLoader.shared.coreDataManager
   
    init(poi: POIType) {
        self.poi = poi
        self.detailSelection = .about
        if let sites = poi.containedSites {
            let siteViewModels = sites.map {PointsOfInterestListItemViewModel(poi: $0, userLocation: userLocation)}
            pointsOfInterestList.append(contentsOf: siteViewModels)
        }
    }
    
    func refreshData () {
        switch detailSelection {
        
        case .about:
            sections = [.pointOfInterestHeader, .storyListContainer, .detailSelection, .poiDescription, .areaAtGlance, .hoursOfOperation]
            
            if accessModes.count > 0 {
                sections.append(.accessibleBy)
            }
            
            sections.append(.totalBouys)
            
            if helpContactLabel != nil {
                sections.append(.helpContact)
            }

        case .whatsHere:
            sections = [.pointOfInterestHeader, .storyListContainer, .detailSelection, .whatsHere]
        case .guide:
            sections = [.pointOfInterestHeader, .storyListContainer, .detailSelection]
        }
    }
    
    var titleBarText: String {
        return zoneOrSiteText
    }
    
    private var zoneOrSiteText: String {
        if let _ = poi as? Site {
            return Constants.Locate.PointsOfInterest.site
        } else {
            return Constants.Locate.PointsOfInterest.zone
        }
    }
    
    var mainTitle: String? {
        return poi.name
    }
    
    var zoneOrSiteLabelText: String? {
        return zoneOrSiteText
    }
    
    var zoneTypeLabel: String? {
        guard let zoneTypeName = poi.zoneType?.name else {
            return nil
        }
        var label = zoneTypeName
        
        if let zoneAbbreviation = poi.zoneType?.abbreviation {
            label += " (\(zoneAbbreviation))"
        }
        
        return label
    }
    
    var coordinateLabel: String? {
        guard let poiCenter = poi.latLng else {
            return nil
        }
        return poiCenter.stringInDecimalDegrees(decimalPrecision: 4)
    }
    
    var distanceAwayLabel: String? {
        guard let userLocation = userLocation,
              let poiCenter = poi.latLng else {
            return nil
        }
        let distanceInMeters = userLocation.distance(from: poiCenter)
        let distanceInMiles = distanceInMeters * Constants.Measurement.metersInAMile
        let milesInt = Int(distanceInMiles)
        
        return Constants.Plan.distanceAway(milesAway: milesInt)
        
    }
    
    var poiDescription: String? {
        return poi.aboutDescription
    }
    
    var numSections: Int {
        return sections.count
    }
    
    var areaOrSiteTypeLabel: String? {
        if let site = poi as? Site {
            return site.siteType?.name
        } else if let zone = poi as? Zone {
            //TODO: get area from data, not in there as of this writing
            return "42 sq. miles"
        } else {
            return nil
        }
    }
    
    var areaAtaGlanceTags: [String] {
        var allTags: [String] = []
        
        let activityTags = poi.activitiesArray?.compactMap { $0.name } ?? []
        allTags.append(contentsOf: activityTags)
        
        poi.habitatsArray?.forEach { habitat in
            if let habitatTag = habitat.name {
                allTags.append(habitatTag)
            }
        }
        
        return allTags
    }
    
    var accessModes: [AccessMode] {
        return poi.accessibleBy ?? []
    }
    
    var helpContactLabel: String? {
        guard let contacts = poi.contacts,
              contacts.count > 0 else {
            return nil
        }
        //TODO: Maybe add support/design for multiple contacts?
        return contacts[0]
    }
    
    func numRows(section: Int) -> Int {
        if sections[section] == .whatsHere {
            return poi.containedSites?.count ?? 0
        } else {
            return 1
        }
    }
    
    var bookmarkIcon: UIImage {
        if poi.isBookmarked {
            return Constants.Image.bookmarkNavActive
        } else {
            return Constants.Image.bookmarkNavInactive
        }
    }
    
    func tappedBookmark() {
        let newBookmarkSetting = !poi.isBookmarked
        poi.setBookmark(isSet: newBookmarkSetting, coreDataManager: coreDataManager)
    }
    
}
