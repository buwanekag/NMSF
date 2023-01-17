//
//  POISearchEmptyStateCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/20/21.
//

import UIKit

class POISearchEmptyStateCell: UITableViewCell {

    @IBOutlet var emptyStateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure() {
        self.emptyStateLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
    }
}
