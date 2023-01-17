//
//  MoreMenuTableViewCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/5/21.
//

import UIKit

class MoreMenuTableViewCell: UITableViewCell {

    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    func configure(viewModel: MoreMenuItemViewModel) {
        iconImageView.image = viewModel.icon

        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline, weight: .bold)
        titleLabel.text = viewModel.titleText

    }

}
