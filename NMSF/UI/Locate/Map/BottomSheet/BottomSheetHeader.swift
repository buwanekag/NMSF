//
//  BottomSheetHeader.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/18/21.
//

import Foundation
import UIKit

class BottomSheetHeader: UITableViewHeaderFooterView {
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var titleLabel: UILabel!

    static let headerHeight: CGFloat = 60.0
    
    func configure() {
        
    }
}
