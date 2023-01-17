//
//  GuideTableViewCell.swift
//  NMSF
//
//  Created by Matt Stanford on 4/28/21.
//

import UIKit

class GuideTableViewCell: UITableViewCell {
    
    @IBOutlet var shadowContainerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var detailsLabel: UILabel!

    func configure(itemViewModel: GuideItemViewModel) {
        self.titleLabel.font = UIFont.preferredFont(forTextStyle: .title2, weight: .bold)
        self.addressLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        self.distanceLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        self.detailsLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .regular)
        
        self.titleLabel.text = itemViewModel.guideTitle
        self.addressLabel.text = itemViewModel.addressString
        self.distanceLabel.text = itemViewModel.distanceString
        self.detailsLabel.text = itemViewModel.descriptionText
        
        shadowContainerView.addShadow(opacity: 0.15, offset: CGSize(width: 4, height: 4), radius: 8)
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = itemViewModel.a11yText
    }
    
}
