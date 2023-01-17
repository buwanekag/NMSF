//
//  NotificationHeaderCell.swift
//  NMSF
//
//  Created by Matt Stanford on 5/14/21.
//

import UIKit

class NotificationHeaderCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!

    func configure() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
    }
    
}
