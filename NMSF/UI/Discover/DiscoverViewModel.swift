//
//  DiscoverViewModel.swift
//  NMSF
//
//  Created by Matt Stanford on 4/23/21.
//

import Foundation

class DiscoverViewModel {
    
    private var itemViewModels: [DiscoverItemViewModel] = []
    private var searchViewModels: [DiscoverItemViewModel]?
    var sections: [DiscoverSection] = []
    var currentSearchString: String = ""
    
    func refreshData() {
        itemViewModels = [DiscoverItemViewModel(storyTitle: "My Test Story", isNew: true),
                          DiscoverItemViewModel(storyTitle: "New Story with really really really really really really really really really really really really really really really really really really really long name", isNew: true),
                          DiscoverItemViewModel(storyTitle: "Test 2 With really really really really really really really really really really really really really really really really really really really long name", isNew: false),
                          DiscoverItemViewModel(storyTitle: "Test 3", isNew: false)]
        sections = [.items]
    }
    
    var numSections: Int {
        return sections.count
    }
    
    func numRows(section: Int) -> Int {
        let section = sections[section]
        
        switch section {
        case .searchHeader:
            return 1
        case .items:
            return searchViewModels?.count ?? itemViewModels.count
        }
    }
    
    func searchedFor(string searchString: String) {
        currentSearchString = searchString
        
        if searchString.isEmpty {
            sections = [.items]
            self.searchViewModels = nil
        } else {
            sections = [.searchHeader, .items]
            self.searchViewModels = itemViewModels.filter {
                $0.storyTitle.lowercased().contains(searchString.lowercased())}
        }
    }
    
    var numItemsInSearch: Int {
        return searchViewModels?.count ?? 0
    }
    
    func item(at indexPath: IndexPath) -> DiscoverItemViewModel {
        if let searchViewModels = searchViewModels {
            return searchViewModels[indexPath.row]
        } else {
            return itemViewModels[indexPath.row]
        }
    }
}
