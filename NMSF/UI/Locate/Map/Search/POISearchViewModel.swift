//
//  POISearchViewModel.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/19/21.
//

import Foundation

class POISearchViewModel: ViewModel {
    var itemViewModels: [PointsOfInterestListItemViewModel] = []
    var searchViewModels: [PointsOfInterestListItemViewModel]?
    var sections: [POISearchSection] = []
    var currentSearchString: String = ""
    var searchFilterViewModel: PlanFilterViewModel = PlanFilterViewModel(sortSelections: [.name, .distance])
    
    init(viewModels:[PointsOfInterestListItemViewModel]){
        self.itemViewModels = viewModels
        
        sections = [.emptyStateCell]
    }
    
    var numSections: Int {
        return sections.count
    }
    
    func numRows(section: Int) -> Int {
        let section = sections[section]
        
        switch section {
        case .searchHeader:
            return 1
        case .pointOfInterestCell:
            return searchViewModels?.count ?? itemViewModels.count
        default:
            return 1
        }
    }
    
    func searchedFor(string searchString: String) {
        currentSearchString = searchString
        
        if searchString.isEmpty {
            sections = [.emptyStateCell]
            self.searchViewModels = nil
        } else {
            
            self.searchViewModels = itemViewModels.filter { $0.title.lowercased().contains(searchString.lowercased())}
            if let searchResults = searchViewModels?.isEmpty, searchResults {
                sections = [.emptyStateCell]
            } else {
                sections = [.mapView, .filter, .searchHeader, .pointOfInterestCell]
                
            }
        }
    }
    var numItemsInSearch: Int {
        return searchViewModels?.count ?? 0
    }
    
    func item(at indexPath: IndexPath) -> PointsOfInterestListItemViewModel {
        if let searchViewModels = searchViewModels {
            return searchViewModels[indexPath.row]
        } else {
            return itemViewModels[indexPath.row]
        }
    }
    
    //MARK: Picker
    
    var numSortRows: Int {
        return searchFilterViewModel.sortSelections.count
    }
    
    
    func sortTitle(for row: Int) -> String {
        let sortSelection: PlanSortType
        sortSelection = searchFilterViewModel.sortSelections[row]
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
        searchFilterViewModel.selectedSortIndex = row
        sortPointsOfInterest()
    }
    
    private func sortPointsOfInterest() {
        var sortList: [PointsOfInterestListItemViewModel] = []
        sortList = searchViewModels ?? itemViewModels
        switch searchFilterViewModel.currentSortType {
        case .name:
            sortList.sort(by: {$0.title < $1.title})
            
        case .distance:
                sortList.sort(by: {
                    let leftVal = $0.distance ?? Int.max
                    let rightVal = $1.distance ?? Int.max
                    return leftVal < rightVal
                })
            
            searchViewModels = sortList
        default:
            sortList.sort(by: {$0.title < $1.title})
        }
    }
}
