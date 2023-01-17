//
//  PlanFilterViewModel.swift
//  NMSF
//
//  Created by Matt Stanford on 4/29/21.
//

import UIKit

class PlanFilterViewModel {
    
    var sortSelections: [PlanSortType]
    var selectedSortIndex: Int
    var inEditMode: Bool = false
    var showDownArrow: Bool = true
    
    
    init(sortSelections: [PlanSortType]) {
        self.sortSelections = sortSelections
        self.selectedSortIndex = 0
    }
    
    var currentSortType: PlanSortType {
        let selection = sortSelections[selectedSortIndex]
        return selection
    }
    
    var sortString: NSAttributedString {
        
        let valueText: String
        switch currentSortType {
        case .name:
            valueText = Constants.Plan.planSortName
        case .distance:
            valueText = Constants.Plan.planSortDistance
        case .category:
            valueText = Constants.Common.category
        }
        let rawString = Constants.Plan.sortBy(string: valueText)
        
        let attribText = NSMutableAttributedString(string: rawString)
        
        let sortByRange: NSRange = attribText.mutableString.range(of: Constants.Plan.planSortBy)
        
        var sortByAttributes: [NSAttributedString.Key: Any] = [:]
        sortByAttributes[.font] =  UIFont.preferredFont(forTextStyle: .body, weight: .bold)
        sortByAttributes[.foregroundColor] = Constants.Color.primaryBlue
        attribText.addAttributes(sortByAttributes, range: sortByRange)
        
        let valueRange: NSRange = attribText.mutableString.range(of: valueText)
        var valueAttributes: [NSAttributedString.Key: Any] = [:]
        valueAttributes[.font] =  UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        valueAttributes[.foregroundColor] = Constants.Color.darkBlue
        attribText.addAttributes(valueAttributes, range: valueRange)
        
        return attribText
        
    }
    
    var editPencilImage: UIImage {
        return inEditMode ? Constants.Image.editPencilActive : Constants.Image.editPencilInactive
    }
    
    var a11yText: String {
        return sortString.string
    }
}
