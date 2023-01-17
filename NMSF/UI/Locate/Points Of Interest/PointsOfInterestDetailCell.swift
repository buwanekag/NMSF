//
//  LocateDetailTableViewCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/1/21.
//

import UIKit

enum SelectedDetail {
    case about
    case whatsHere
    case guide
}

class PointsOfInterestDetailCell: UITableViewCell {
    
    @IBOutlet var aboutButton: DesignableButton!
    @IBOutlet var whatsHereButton: DesignableButton!
    @IBOutlet var guidlinesButton: DesignableButton!
    @IBOutlet var container: DesignableView!
    
    func configure(viewModel: PointsOfInterestViewModel) {
        contentView.addShadow()
        
        aboutButton.addBorder(side: .bottom, thickness: 2, color: .white)
        aboutButton.setTitleColor(Constants.Color.darkBlue, for: .normal)
        aboutButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        
        whatsHereButton.addBorder(side: .bottom, thickness: 2, color: .white)
        whatsHereButton.setTitleColor(Constants.Color.darkBlue, for: .normal)
        whatsHereButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        
        guidlinesButton.addBorder(side: .bottom, thickness: 2, color: .white)
        guidlinesButton.setTitleColor(Constants.Color.darkBlue, for: .normal)
        guidlinesButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)

        switch viewModel.detailSelection {
        case .about:
            aboutButton.setTitleColor(Constants.Color.primaryBlue, for: .normal)
            aboutButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body, weight: .bold)
            aboutButton.addBorder(side: .bottom, thickness: 2, color: Constants.Color.primaryBlue)
        case .whatsHere:
            whatsHereButton.setTitleColor(Constants.Color.primaryBlue, for: .normal)
            whatsHereButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body, weight: .bold)
            whatsHereButton.addBorder(side: .bottom, thickness: 2, color: Constants.Color.primaryBlue)
        case .guide:
            guidlinesButton.setTitleColor(Constants.Color.primaryBlue, for: .normal)
            guidlinesButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body, weight: .bold)
            guidlinesButton.addBorder(side: .bottom, thickness: 2, color: Constants.Color.primaryBlue)
        }
        
        if let _ = viewModel.poi as? Site {
            whatsHereButton.isHidden = true
        }
    }
}
