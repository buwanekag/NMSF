//
//  NotificationSettingsTableViewCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/6/21.
//

import UIKit

class NotificationSettingsTableViewCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet  var selectionSwitch: UISwitch!
    
    var callback: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(viewModel: NotificationSettingsItemViewModel) {
        titleLabel.text = viewModel.titleText
        selectionSwitch.isOn = viewModel.isSelected
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline, weight: .regular)
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        callback?(sender.isOn)
    }
    func turnOffSwitch() {
        print("turn off switch")
        selectionSwitch.isOn = false
        selectionSwitch.backgroundColor = UIColor(cgColor: Constants.Color.primaryBlue.cgColor)
        selectionSwitch.thumbTintColor = UIColor.white
    }
}
