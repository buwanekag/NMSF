//
//  FilterListTableViewCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/25/21.
//

import UIKit
protocol FilterListItemDelegate: AnyObject {
    func selected(item: POIFilterItemViewModel)
    func deSelected(item: POIFilterItemViewModel)
}
class FilterListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkmarkButton: UIButton!
    var item: POIFilterItemViewModel?
    
    weak var delegate: FilterListItemDelegate?
    var clearAll: Bool =  false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(item: POIFilterItemViewModel, clearAll: Bool) {
        self.item = item
        titleLabel.text = item.title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body, weight: .regular)
        self.clearAll = clearAll
        checkmarkButton.isSelected = item.selected
        
        if clearAll {
            checkmarkButton.isSelected = false
        }
    }
    
    
    @IBAction func checkmarkButtonTapped(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            if let itemViewModel = item {
                delegate?.deSelected(item: itemViewModel)
            }
            
        } else {
            sender.isSelected = true
            if let itemViewModel = item {
                delegate?.selected(item: itemViewModel)
            }
            
        }
    }
}
