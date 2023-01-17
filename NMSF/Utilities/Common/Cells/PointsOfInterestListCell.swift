//
//  PlanTableViewCell.swift
//  NMSF
//
//  Created by Matt Stanford on 4/28/21.
//

import UIKit
import TagListView

protocol PointOfInterestListItemDelegate: AnyObject {
    func tappedDelete(itemViewModel: PointsOfInterestListItemViewModel)
}

class PointsOfInterestListCell: UITableViewCell {
    
    @IBOutlet var containerShadowView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var tagContainerView: UIView!
    @IBOutlet var tagView: TagListView!
    @IBOutlet var bookmarkImage: UIImageView!
    @IBOutlet var deleteButton: UIButton!
    
    weak var delegate: PointOfInterestListItemDelegate?
    private var itemViewModel: PointsOfInterestListItemViewModel?
    
    func configure(itemViewModel: PointsOfInterestListItemViewModel, searchString: String? = nil) {
        doConfigure(itemViewModel: itemViewModel)
    
        if let searchString = searchString {
            addHighlight(currentString: itemViewModel.title, highlightString: searchString)
        }
    }
    
    func configurePlanView(itemViewModel: PointsOfInterestListItemViewModel, delegate: PointOfInterestListItemDelegate) {
        doConfigure(itemViewModel: itemViewModel)
        self.delegate = delegate
    }
    
    private func doConfigure(itemViewModel: PointsOfInterestListItemViewModel) {
        self.itemViewModel = itemViewModel

        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
        distanceLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        
        titleLabel.text = itemViewModel.title
        distanceLabel.text = itemViewModel.locationText
        
        let tagList = itemViewModel.truncatedTagsList
        if tagList.count > 0 {
            tagContainerView.isHidden = false
            tagView.textFont = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
            tagView.removeAllTags()
            tagView.addTags(itemViewModel.truncatedTagsList)
        } else {
            tagContainerView.isHidden = true
        }
        
        bookmarkImage.isHidden = itemViewModel.hideBookmark
        deleteButton.isHidden = itemViewModel.hideDeleteButton
        
        containerShadowView.addShadow(opacity: 0.15, offset: CGSize(width: 4, height: 4), radius: 8)
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = itemViewModel.a11yText
    }
    
    @IBAction func tappedDeleteButton() {
        guard let itemViewModel = self.itemViewModel else {
            return
        }
        delegate?.tappedDelete(itemViewModel: itemViewModel)
    }
    
    override func accessibilityActivate() -> Bool {
        guard let itemViewModel = itemViewModel else {
            return false
        }
        if itemViewModel.inEditMode {
            tappedDeleteButton()
            return true
        } else {
            return false
        }
    }
    
    private func addHighlight(currentString: String, highlightString: String) {
        
        let attribText = NSMutableAttributedString(string: currentString)
        let range: NSRange = attribText.mutableString.range(of: highlightString, options: .caseInsensitive)
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        
        attributes[.backgroundColor] = Constants.Color.floridaKeysGreen
        
        attribText.addAttributes(attributes, range: range)
        titleLabel.attributedText = attribText
    }
}
