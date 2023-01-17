//
//  AccessibleByCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/4/21.
//

import UIKit

class AccessibleByCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconStackView: UIStackView!
    
    func configure(accessModes: [AccessMode]) {
        titleLabel.font =  UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        iconStackView.alignment = .leading
        iconStackView.subviews.forEach({ $0.removeFromSuperview() })
        
        accessModes.forEach { accessMode in
            let boatAccessibleByView = AccessibleByView()
            boatAccessibleByView.iconImageView.image = UIImage(named: "boat")
            boatAccessibleByView.typeLabel.text = accessMode.name
            iconStackView.addArrangedSubview(boatAccessibleByView)
        }

        let filler = AccessibleByView()
        filler.typeLabel.isHidden = true
        iconStackView.addArrangedSubview(filler)
        
    }
    
}
