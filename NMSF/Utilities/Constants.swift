//
//  Constants.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 4/12/21.
//

import Foundation
import UIKit

struct Constants {
    struct Environment {
        static let baseUrl = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String
    }
    
    struct Measurement {
        static let metersInAMile: Double = 0.000621371
    }
    
    struct Service {
        static let badRequest = NSLocalizedString("Invalid request.",comment: "")
        static let unauthorized = NSLocalizedString("You are unauthorized to perform this action.",comment: "")
        static let forbidden = NSLocalizedString("You are unauthorized to perform this action.",comment: "")
        static let notFound = NSLocalizedString("Resource not found.",comment: "")
        static let internalServerError = NSLocalizedString("A server error occurred.",comment: "")
        static let notImplemented = NSLocalizedString("This functionality is not implemented.",comment: "")
        static let serviceUnavailable = NSLocalizedString("This service is unavailable.",comment: "")
        static let invalidData = NSLocalizedString("The JSON Data is invalid.",comment: "")
        static let unknownError = NSLocalizedString("An unknown error has occurred.",comment: "")
    }
    
    struct Common {
        static let ok = NSLocalizedString("OK", comment: "")
        static let error = NSLocalizedString("Error", comment: "")
        static let cancel = NSLocalizedString("Cancel", comment: "")
        static let tapToDelete = NSLocalizedString("Tap to delete", comment: "")
        static let category = NSLocalizedString("Category", comment: "")
        
        struct a11y {
            static let close = NSLocalizedString("Dismiss view", comment: "")
            static let previous = NSLocalizedString("Previous view", comment: "")
            static let next = NSLocalizedString("Next view", comment: "")
        }
        
    }
    
    struct Discover {
        static let searchPlaceholder = NSLocalizedString("Search Stories", comment: "")
        static let searchButtonA11yLabel = NSLocalizedString("Search", comment: "")
        static let searchClearA11yLabel = NSLocalizedString("Clear Search Field", comment: "")
        
        static func searchText(numItems: Int) -> String {
            return String(format: NSLocalizedString("%i results", comment: ""), numItems)
        }
    }
    struct Locate {
        struct PointsOfInterest {
            static let zone = NSLocalizedString("Zone", comment: "")
            static let site = NSLocalizedString("Site", comment: "")
            static let boat = NSLocalizedString("Boat", comment: "")
            static let trail = NSLocalizedString("Trail", comment: "")
            
            static let helpContact = NSLocalizedString("Help Contact", comment: "")
            static let mourningBouys = NSLocalizedString("Total mooring buoys here", comment: "")
            static let searchPlaceholder = NSLocalizedString("Search Points of Interest", comment: "")
            static let filtersApplied = NSLocalizedString("filters applied:", comment: "")
            static let filterApplied = NSLocalizedString("filter applied:", comment: "")
            
        }
        
        struct Filter{
            static let accessibleBy = NSLocalizedString("Accessible By", comment: "")
            static let interests = NSLocalizedString("Interests", comment: "")
            static let fishingHarvesting = NSLocalizedString("Fishing & Harvesting", comment: "")
            static let habitats = NSLocalizedString("Habitats", comment: "")
            static let siteType = NSLocalizedString("Site Type", comment: "")
            static let filterBy = NSLocalizedString("Filter By", comment: "")
            static let searchInterests = NSLocalizedString("Search Interests", comment: "")
            static let clearA11yText = NSLocalizedString("Clear, tap to clear selections", comment: "")
            static func filterText(count: Int, items: String) -> NSAttributedString {
                
                let filterText = count > 1 ? String(format: NSLocalizedString("%i filters applied: ", comment: ""), count) : "filter applied: "
                let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
                let normalAttr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]
                let text = "\(filterText) \(items)"
                let range = (text as NSString).range(of: filterText)
                let normalTextRange = (text as NSString).range(of: items)
                let attributedString = NSMutableAttributedString(string: "\(filterText) \(items)")
                
                attributedString.addAttributes(attrs, range: range)
                attributedString.addAttributes(normalAttr, range: normalTextRange)
                
                
                return attributedString
            }
        }
    }
    
    
    struct Plan {
        static let planSortBy = NSLocalizedString("Sort by:", comment: "")
        static let planSortName = NSLocalizedString("Name", comment: "")
        static let planSortDistance = NSLocalizedString("Distance", comment: "")
        static let planSortCategory = NSLocalizedString("Category", comment: "")
        static let deleteAlertTitle = NSLocalizedString("Do you want to remove this Site from your Plan? ", comment: "")
        static let deleteAlertOkButton = NSLocalizedString("Yep, remove it", comment: "")
        static let planEditPencilA11yText = NSLocalizedString("Edit, tap to toggle delete mode", comment: "")
        
        static func sortBy(string: String) -> String {
            return String(format: NSLocalizedString("Sort by: %@", comment: ""), string)
        }
        static func distanceAway(milesAway: Int) -> String {
            return String(format: NSLocalizedString("%i miles away", comment: ""), milesAway)
        }
        static func planItemA11yText(title: String, distance: Int, tags: [String]) -> String {
            let tagList = tags.joined(separator: ", ")
            return String(format: NSLocalizedString("%@, %i miles away, tags: %@", comment: ""), title, distance, tagList)
        }
        static func planItemA11yTextNoDistance(title: String, tags: [String]) -> String {
            let tagList = tags.joined(separator: ", ")
            return String(format: NSLocalizedString("%@, tags: %@", comment: ""), title, tagList)
        }
        static func planItemA11yTextInDeleteMode(title: String, distance: Int, tags: [String]) -> String {
            let tagList = tags.joined(separator: ", ")
            return String(format: NSLocalizedString("%@, double tap to delete, %i miles away, tags: %@", comment: ""), title, distance, tagList)
        }
        static func planItemA11yTextInDeleteModeNoDistance(title: String, tags: [String]) -> String {
            let tagList = tags.joined(separator: ", ")
            return String(format: NSLocalizedString("%@, double tap to delete, tags: %@", comment: ""), title, tagList)
        }
        static func guideItemA11yText(title: String,  address: String, distance: Int, description: String) -> String {
            return String(format: NSLocalizedString("%@, %@, %i miles away, %@", comment: ""), title, address, distance, description)
        }
    }
    
    struct Network {
        static let baseURL = URL(string: "https://api.dev.nmsf.mindgrb.io")!
    }
    
    struct Color {
        static let darkBlue = UIColor(named: "DarkBlue")!
        static let lightBlue = UIColor(named: "LightBlue")!
        static let primaryBlue = UIColor(named: "PrimaryBlue")!
        static let floridaKeysGreen = UIColor(named: "FloridaKeysGreen")!
        static let annotationBlue = UIColor(named: "AnnotationBlue")!
        static let mapDashYellow = UIColor(named: "MapDashYellow")!
    }
    
    struct Image {
        static let searchGlass = UIImage(named: "search_glass")!
        static let closeX = UIImage(named: "close_x")!
        static let editPencilInactive = UIImage(named: "edit_pencil")!
        static let editPencilActive = UIImage(named: "edit_pencil_filled")!
        static let waveBackground = UIImage(named: "wave_background")!
        static let currentLocationFilled = UIImage(named: "current_location_filled")!
        static let bookmarkNavInactive = UIImage(named: "bookmark_nav_inactive")!
        static let bookmarkNavActive = UIImage(named: "bookmark_nav_active")!
        static let arrowUp = UIImage(named: "arrow_up")!
        static let arrowDown = UIImage(named: "chevron_down")!
    }
    
}

