//
//  DiscoverSearchTableViewCell.swift
//  NMSF
//
//  Created by Matt Stanford on 4/27/21.
//

import UIKit

class DiscoverSearchTableViewCell: UITableViewCell {

    @IBOutlet var searchLabel: UILabel!
    
    func configure(numSearchItems: Int) {
        searchLabel.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .regular)
        searchLabel.text = Constants.Discover.searchText(numItems: numSearchItems)
    }
    
    func configureFilterCount(count:Int, items: String) {
        searchLabel.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .regular)
        searchLabel.attributedText = Constants.Locate.Filter.filterText(count:count, items:items)
    }
    
}
