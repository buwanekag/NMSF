//
//  DescriptionTableViewCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/4/21.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    func configure(viewModel: PointsOfInterestViewModel) {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        descriptionLabel.text = viewModel.poiDescription
    }
    
}
