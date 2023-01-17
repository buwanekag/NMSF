//
//  HoursOfOperationCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/4/21.
//

import UIKit

class HoursOfOperationCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure() {
        titleLabel.font =  UIFont.preferredFont(forTextStyle: .subheadline, weight: .bold)
        dayLabel.font =  UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        timeLabel.font =  UIFont.preferredFont(forTextStyle: .body, weight: .regular)
    }
    
}
