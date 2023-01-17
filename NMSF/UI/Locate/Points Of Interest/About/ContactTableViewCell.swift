//
//  ContactTableViewCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/4/21.
//

import UIKit

enum contactCellType {
    case contact
    case bouy
}

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(cellType: contactCellType, viewModel: PointsOfInterestViewModel) {
        titleLabel.font =  UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        detailLabel.font =  UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        
        switch cellType {
        case .contact:
            titleLabel.text = Constants.Locate.PointsOfInterest.helpContact
            iconImageView.image = UIImage(named: "phone")
            detailLabel.text = viewModel.helpContactLabel
        case .bouy:
        
            titleLabel.text = Constants.Locate.PointsOfInterest.mourningBouys
        iconImageView.image = UIImage(named: "bouy")
        detailLabel.text = "8 may be available"
        }
    }
    
    
}
