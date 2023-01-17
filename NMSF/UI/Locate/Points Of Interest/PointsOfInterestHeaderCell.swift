//
//  PointsOfInterestHeaderCell.swift
//  NMSF
//
//  Created by Clay Suttner on 10/3/21.
//

import UIKit

class PointsOfInterestHeaderCell: UITableViewCell {

    @IBOutlet weak var topContainerView: DesignableView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var locationCoordinates: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    func setupUI(viewModel: PointsOfInterestViewModel) {
        typeLabel.text = viewModel.mainTitle
        typeLabel.text = viewModel.zoneOrSiteLabelText
        titleLabel.text = viewModel.mainTitle
        descriptionLabel.text = viewModel.zoneTypeLabel
        locationCoordinates.text = viewModel.coordinateLabel
        distanceLabel.text = viewModel.distanceAwayLabel
        sizeLabel.text = viewModel.areaOrSiteTypeLabel
        
        typeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .regular)
        sizeLabel.font = UIFont.preferredFont(forTextStyle: .footnote  , weight: .bold)
        locationCoordinates.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .regular)
        distanceLabel.font = UIFont.preferredFont(forTextStyle: .footnote  , weight: .bold)
    }
    
}
