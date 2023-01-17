//
//  FilterViewModel.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/25/21.
//

import Foundation

class FilterViewModel: ViewModel {
    var filterItems: [POIFilterItemViewModel] = []
    var accessibleByItems: [POIFilterItemViewModel] = []
    var fishingHarvestingItems: [POIFilterItemViewModel] = []
    var interestsItems: [POIFilterItemViewModel] = []
    var habitatItems: [POIFilterItemViewModel] = []
    var searchViewModels: [POIFilterItemViewModel]?
    var siteTypeItems: [POIFilterItemViewModel] = []
    var selectedFilteredItems: [POIFilterItemViewModel] = []
    var poiList: [POIType] = []
    var sections: [FilterSection] = []
    var currentSearchString: String = ""
    var showCategory: Bool = false
    var clearAll:Bool = false
    var filterCellViewModel: PlanFilterViewModel = PlanFilterViewModel(sortSelections: [.name, .category])
    
    init(selection: [POIFilterItemViewModel], list: [PointsOfInterestListItemViewModel]) {
     //   self.poiList = list.map {$0.poi}
        sections = [.filterCell, .accessibleBy, .fishingHarvesting, .interests, .habitats]
//
//        poiList.forEach {item in
//            let accessibleList = item.accessibleBy
//            let activityList = item.activitiesArray
//            if let list = accessibleList {
//                accessibleByItems = list.map {POIFilterItemViewModel(title: $0.name ?? "", category: $0.className, selected: false)}
//                filterItems.append(contentsOf: accessibleByItems)
//            }
//
//            if let activities = activityList {
//                interestsItems =  activities.map {POIFilterItemViewModel(title: $0.name ?? "", category: $0.className, selected: false)}
//                filterItems.append(contentsOf: interestsItems)
//            }
//        }
//
//        habitatItems = poiList.map {POIFilterItemViewModel(title: $0.habitat?.name ?? "", category: $0.habitat?.className ?? "", selected: false)}
//        filterItems.append(contentsOf: habitatItems)
       
        
        accessibleByItems = [POIFilterItemViewModel(title: "Boat", category: "AccesibleBy", selected: false), POIFilterItemViewModel(title: "Trail", category: "AccesibleBy", selected: false)]
        filterItems.append(contentsOf: accessibleByItems)
        fishingHarvestingItems = [POIFilterItemViewModel(title: "Trout", category: "Fishing", selected: false), POIFilterItemViewModel(title: "Salmon", category: "Fishing", selected: false)]
        filterItems.append(contentsOf: fishingHarvestingItems)
        interestsItems = [POIFilterItemViewModel(title: "Diving", category: "Interests", selected: false), POIFilterItemViewModel(title: "Snorkeling", category: "Interests", selected: false)]
        filterItems.append(contentsOf: interestsItems)
        habitatItems = [POIFilterItemViewModel(title: "Coral Reefs", category: "Habitat", selected: false), POIFilterItemViewModel(title: "Pinnacles", category: "Habitat", selected: false)]
        filterItems.append(contentsOf: habitatItems)
        siteTypeItems = [POIFilterItemViewModel(title: "Shipwreck", category: "SiteType", selected: false), POIFilterItemViewModel(title: "Cave", category: "SiteType", selected: false)]
        filterItems.append(contentsOf: siteTypeItems)
        selectedFilteredItems = selection
        selectedFilteredItems.forEach { (item) in
            if let row = filterItems.firstIndex(where:{$0.title == item.title}) {
                filterItems[row] = item
            }
        }
    }
    
    var numSections: Int {
        if searchViewModels != nil || showCategory == false {
            sections = [.filterCell, .items]
            
            return 2
        } else {
            sections = [.filterCell, .accessibleBy, .fishingHarvesting, .interests, .habitats]
            return sections.count
        }
        
    }
    
    func numRows(section: Int) -> Int {
        let section = sections[section]
        if  showCategory == false {
            
            switch section {
            case .filterCell:
                return 1
            default:
                return searchViewModels?.count ?? filterItems.count
            }
        } else {
            switch section {
            case .accessibleBy:
                return searchViewModels?.count ?? accessibleByItems.count
            case .fishingHarvesting:
                return searchViewModels?.count ?? fishingHarvestingItems.count
            case .interests:
                return interestsItems.count
            case .habitats:
                return habitatItems.count
            case .siteType:
                return siteTypeItems.count
            case .filterCell:
                return 1
            case.items:
                return searchViewModels?.count ?? filterItems.count
            }
        }
        
    }
    
    
    //MARK: Search
    
    
    func searchedFor(string searchString: String) {
        currentSearchString = searchString
        
        if searchString.isEmpty {
            sections = [.filterCell, .accessibleBy, .fishingHarvesting, .interests, .habitats]
            self.searchViewModels = nil
        } else {
            sections = [.filterCell, .accessibleBy, .fishingHarvesting, .interests, .habitats]
            self.searchViewModels = filterItems.filter { $0.title.lowercased().contains(searchString.lowercased())}
            
        }
    }
    var numItemsInSearch: Int {
        return searchViewModels?.count ?? 0
    }
    
    func item(at indexPath: IndexPath) -> POIFilterItemViewModel {
        if let searchViewModels = searchViewModels {
            return searchViewModels[indexPath.row]
        } else {
            return filterItems[indexPath.row]
        }
    }
    
    //MARK: Picker
    
    var numSortRows: Int {
        return filterCellViewModel.sortSelections.count
    }
    
    
    func sortTitle(for row: Int) -> String {
        let sortSelection: PlanSortType
        sortSelection = filterCellViewModel.sortSelections[row]
        switch sortSelection {
        case .name:
            return Constants.Plan.planSortName
        case .distance:
            return Constants.Plan.planSortDistance
        case .category:
            return Constants.Plan.planSortCategory
        }
    }
    
    func didSelectSort(row: Int) {
        filterCellViewModel.selectedSortIndex = row
        sortPointsOfInterest()
    }
    
    private func sortPointsOfInterest() {
        
        var sortList: [POIFilterItemViewModel] = []
        sortList = searchViewModels ?? filterItems
        switch filterCellViewModel.currentSortType {
        case .name:
            showCategory = false
            if searchViewModels != nil {
                sortList.sort(by: {$0.title < $1.title})
            }
            filterItems.sort(by: {$0.title < $1.title})
        case .category:
            showCategory = true
            if searchViewModels != nil {
                sortList.sort(by: {$0.title < $1.title})
                searchViewModels = sortList
            }
            filterItems.sort(by: {$0.category < $1.category})
        default:
            sortList.sort(by: {$0.title < $1.title})
        }
    }
    
    func didSelectItem(item:POIFilterItemViewModel ) {
        item.selected = true
        selectedFilteredItems.append(item)
    }
    func didDeSelectItem(item:POIFilterItemViewModel ) {
        selectedFilteredItems =  selectedFilteredItems.filter {$0.title != item.title }
    }
    func didSelectDone() {
        filterCellViewModel.showDownArrow = true
    }
    
}
