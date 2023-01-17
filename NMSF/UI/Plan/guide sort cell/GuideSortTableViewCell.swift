//
//  GuideSortTableViewCell.swift
//  NMSF
//
//  Created by Matt Stanford on 4/30/21.
//

import UIKit

protocol GuideSortDelegate: AnyObject {
    func tappedGuideSort()
}

class GuideSortTableViewCell: UITableViewCell {

    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var sortContainerView: UIView!
    @IBOutlet var sortShadowView: UIView!
    @IBOutlet var sortLabel: UILabel!
    
    weak var delegate: GuideSortDelegate?
    
    func configure(filterViewModel: PlanFilterViewModel, delegate: GuideSortDelegate) {
        self.delegate = delegate
        
        detailsLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        detailsLabel.isAccessibilityElement = true
        sortLabel.attributedText = filterViewModel.sortString
        sortContainerView.isAccessibilityElement = true
        sortContainerView.accessibilityLabel = filterViewModel.a11yText
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tappedSort))
        sortContainerView.addGestureRecognizer(tapGR)
        sortShadowView.addShadow()
    }
    
    @objc func tappedSort() {
        delegate?.tappedGuideSort()
    }
}
