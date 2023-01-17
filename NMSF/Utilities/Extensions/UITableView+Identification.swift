//
//  UITableView+Identification.swift
//  NMSF
//
//  Created by Matt Stanford on 4/23/21.
//

import UIKit

extension UITableViewCell {

    static var cellIdentifier: String {
        return String(describing: self)
    }

    static func registerWithTableView(tableView: UITableView) {
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
}
