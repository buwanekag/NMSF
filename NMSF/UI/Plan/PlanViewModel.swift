//
//  PlanViewModel.swift
//  NMSF
//
//  Created by Matt Stanford on 4/28/21.
//

import Combine
import Foundation
import CoreLocation

class PlanViewModel {
    
    var planFilterViewModel: PlanFilterViewModel = PlanFilterViewModel(sortSelections: [.name, .distance])
    var guideFilterViewModel: PlanFilterViewModel = PlanFilterViewModel(sortSelections: [.name, .distance])
    var planItemViewModels: [PointsOfInterestListItemViewModel] = []
    var guideItemViewModels: [GuideItemViewModel] = []
    var selectedTab: PlanTab = .myPlan
    var sections: [PlanSection] = []
    
    var loader = DataFeedLoader.shared
    var sites: [Site] = []
    var zones: [Zone] = []
    private var userLocation: CLLocation?
    
    var inEditMode: Bool = false
    
    func loadData() -> AnyPublisher<Void, Error> {
        
        let predicate = NSPredicate(format: "isBookmarked == YES")
        
        let sitesPublisher = loader.getSites(predicate: predicate)
            .map { [weak self] sites -> Void in
                self?.sites = sites
                return ()
            }
            .eraseToAnyPublisher()
        
        let zonesPublisher = loader.getZones(predicate: predicate)
            .map { [weak self] zones -> Void in
                self?.zones = zones
                return ()
            }
            .eraseToAnyPublisher()
        
        return Publishers.MergeMany([sitesPublisher, zonesPublisher])
            .collect()
            .map { [weak self] _ in
                self?.generatePlanViewModels()
                self?.generateGuideViewModels()
                self?.sortPlanItems()
                self?.sortGuideItems()
                
                self?.updateSections()
                return ()
            }
            .eraseToAnyPublisher()
    }
    
    private func generatePlanViewModels() {
        planItemViewModels = []
        
        let siteViewModels = sites.map { PointsOfInterestListItemViewModel(poi: $0, userLocation: userLocation, inEditMode: self.inEditMode) }
        let zoneViewModels = zones.map { PointsOfInterestListItemViewModel(poi: $0, userLocation: userLocation, inEditMode: self.inEditMode) }
        self.planItemViewModels.append(contentsOf: siteViewModels)
        self.planItemViewModels.append(contentsOf: zoneViewModels)
    }
    
    private func generateGuideViewModels() {
        self.guideItemViewModels = [
            GuideItemViewModel(guideTitle: "A+ Charters, Inc", addressString: "456 Boat Path, Key West", distance: 16, descriptionText: "Semper libero senectus quis id urna, vulputate. Tellus odio congue enim tellus id..."),
            GuideItemViewModel(guideTitle: "Christine’s Boat Tour Co.", addressString: "45 Palm Tree Way, Key Largo", distance: 14, descriptionText: "Semper libero senectus quis id urna, vulputate. Tellus odio congue enim tellus id..."),
            GuideItemViewModel(guideTitle: "Florida Scuba Tours Inc.", addressString: "8910 Marshland St., Key West", distance: 3, descriptionText: "Semper libero senectus quis id urna, vulputate. Tellus odio congue enim tellus id..."),
        ]
    }
    
    func got(userLocation: CLLocation?) {
        self.userLocation = userLocation
        self.generatePlanViewModels()
    }
    
    private func updateSections() {
        switch selectedTab {
        case .myPlan:
            if planItemViewModels.count > 0 {
                sections = [.planFilterCell, .planCells]
            } else {
                sections = [.planEmptyStateCell]
            }
        case .findAGuide:
            sections = [.guideSortCell, .guideCells]
        }
    }
    
    var numSections: Int {
        return sections.count
    }
    
    func numRows(section: Int) -> Int {
        let section = sections[section]
        
        switch section {
        case .planFilterCell, .planEmptyStateCell, .guideSortCell:
            return 1
        case .planCells:
            return planItemViewModels.count
        case .guideCells:
            return guideItemViewModels.count
        }
    }
    
    func switchedTab(index: Int) {
        guard let tab = PlanTab(rawValue: index) else {
            return
        }
        selectedTab = tab
        updateSections()
    }
    
    func togglePlanEditMode() {
        self.inEditMode = !inEditMode
        planFilterViewModel.inEditMode = inEditMode
        for item in planItemViewModels {
            item.inEditMode = !item.inEditMode
        }
    }
    
    func delete(planItem: PointsOfInterestListItemViewModel) {
        planItem.poi.setBookmark(isSet: false, coreDataManager: loader.coreDataManager)
    }
    
    private func sortPlanItems() {
        switch planFilterViewModel.currentSortType {
        case .name:
            self.planItemViewModels.sort(by: { $0.title < $1.title})
        case .distance:
            self.planItemViewModels.sort(by: {
                let leftVal = $0.distance ?? Int.max
                let rightVal = $1.distance ?? Int.max
                return leftVal < rightVal
            })
        default:
            self.planItemViewModels.sort(by: { $0.title < $1.title})
        }
    }
    
    private func sortGuideItems() {
        switch guideFilterViewModel.currentSortType {
        case .name:
            self.guideItemViewModels.sort(by: { $0.guideTitle < $1.guideTitle})
        case .distance:
            self.guideItemViewModels.sort(by: { $0.distance < $1.distance })
        default:
            self.guideItemViewModels.sort(by: { $0.guideTitle < $1.guideTitle})
        }
    }
    
    //MARK: Picker
    
    var numSortRows: Int {
        switch selectedTab {
        case .myPlan:
            return planFilterViewModel.sortSelections.count
        case .findAGuide:
            return guideFilterViewModel.sortSelections.count
        }
    }
    
    func sortTitle(for row: Int) -> String {
        let sortSelection: PlanSortType
        switch selectedTab {
        case .myPlan:
            sortSelection = planFilterViewModel.sortSelections[row]
        case .findAGuide:
            sortSelection = guideFilterViewModel.sortSelections[row]
        }
        
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
        switch selectedTab {
        case .myPlan:
            planFilterViewModel.selectedSortIndex = row
            sortPlanItems()
        case .findAGuide:
            guideFilterViewModel.selectedSortIndex = row
            sortGuideItems()
        }
    }
}
