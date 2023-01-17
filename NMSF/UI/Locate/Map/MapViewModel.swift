//
//  MapViewModel.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/14/21.
//

import Combine
import Foundation
import MapKit

class MapViewModel: ViewModel {

    var pointOfInterestList: [PointsOfInterestListItemViewModel] = []
    var sections: [BottomSheetSection] = [.filterCell, .filterItems, .pointsOfInterestCell]
    var POIFilterViewModel: PlanFilterViewModel = PlanFilterViewModel(sortSelections: [.name, .distance])
    var filteredItems: [POIFilterItemViewModel] = []
    var loader = DataFeedLoader.shared
    var sites: [Site] = []
    var zones: [Zone] = []
    
    private var userLocation: CLLocation?
    
    func loadData() -> AnyPublisher<Void, Error> {
        
        let sitesPublisher = loader.getSites()
            .map { [weak self] sites -> Void in
                self?.sites = sites
                return ()
            }
            .eraseToAnyPublisher()
        
        let zonesPublisher = loader.getZones()
            .map { [weak self] zones -> Void in
                self?.zones = zones
                return ()
            }
            .eraseToAnyPublisher()
        
        return Publishers.MergeMany([sitesPublisher, zonesPublisher])
            .collect()
            .map { [weak self] _ in
                self?.generateListViewModels()
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    private func generateListViewModels() {
        let siteViewModels = sites.map { PointsOfInterestListItemViewModel(poi: $0, userLocation: self.userLocation ) }
        let zoneViewModels = zones.map { PointsOfInterestListItemViewModel(poi: $0, userLocation: self.userLocation) }
        
        pointOfInterestList = []
        pointOfInterestList.append(contentsOf: siteViewModels)
        pointOfInterestList.append(contentsOf: zoneViewModels)
    }
    
    var siteAnnotations: [NMSFPointAnnotation] {
        
        return sites.compactMap { site in
            guard let coordinate = site.latLng?.coordinate else {
                return nil
            }
            let annotation = NMSFPointAnnotation()
            annotation.coordinate = coordinate
            annotation.site = site
            return annotation
        }
    }
    
    var zonePolygons: [NMSFMapPolygon] {
        return zones.compactMap { zone in
            guard let mapPoints = zone.mapPoints else {
                return nil
            }
            
            let polygon = NMSFMapPolygon(coordinates: mapPoints, count: mapPoints.count)
            polygon.drawStyle = .dashed
            return polygon
        }
    }
    
    func refresh(userLocation: CLLocation?) {
        self.userLocation = userLocation
        generateListViewModels()
    }
    
    var numSections: Int {
        return sections.count
    }
    
    func numRows(section: Int) -> Int {
        let section = sections[section]
        
        switch section {
        case .filterCell:
            return 1
        case .pointsOfInterestCell:
            return pointOfInterestList.count
        case .filterItems:
            return filteredItems.isEmpty ? 0 : 1
        }
    }
    
    private func sortPointsOfInterest() {
        switch POIFilterViewModel.currentSortType {
        case .name:
            pointOfInterestList.sort(by: {$0.title < $1.title})
        case .distance:
            pointOfInterestList.sort(by: {
                let leftVal = $0.distance ?? Int.max
                let rightVal = $1.distance ?? Int.max
                return leftVal < rightVal
            })
        default:
            pointOfInterestList.sort(by: {$0.title < $1.title})
        }
    }
    
    var filterItemText: NSAttributedString {
        let filters = filteredItems.map{$0.title}
        let items = filters.map {$0}.joined(separator: ", ")
        var filterText = ""
        
        if filters.count > 1 {
            filterText = Constants.Locate.PointsOfInterest.filtersApplied
        } else {
            filterText = Constants.Locate.PointsOfInterest.filterApplied
        }
        
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
        let attributedString = NSMutableAttributedString(string: filterText, attributes:attrs)
        let normalString = NSMutableAttributedString(string: items)
        attributedString.append(normalString)
        
        return attributedString
    }
    
    //MARK: Picker
    
    var numSortRows: Int {
        return POIFilterViewModel.sortSelections.count
    }
    
    
    func sortTitle(for row: Int) -> String {
        let sortSelection: PlanSortType
        sortSelection = POIFilterViewModel.sortSelections[row]
        switch sortSelection {
        case .name:
            return Constants.Plan.planSortName
        case .distance:
            return Constants.Plan.planSortDistance
        default:
            return Constants.Plan.planSortName
        }
    }
    
    func didSelectSort(row: Int) {
        POIFilterViewModel.selectedSortIndex = row
        sortPointsOfInterest()
    }
    
    
    
    func filterList() {
        if !filteredItems.isEmpty {
            let filters = filteredItems.map {$0.title.lowercased()}
            pointOfInterestList = pointOfInterestList.filter{$0.tags.contains(where: filters.contains)}
        } else {
            generateListViewModels()
        }
    }
    
    func didSelectDone() {
        POIFilterViewModel.showDownArrow = true
    }
}
