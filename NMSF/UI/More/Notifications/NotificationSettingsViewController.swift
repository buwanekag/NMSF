//
//  NotificationSettingsViewController.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/5/21.
//

import UIKit

class NotificationSettingsViewController: UIViewController, ViewModelable {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: SecondaryHeaderView!
    
    var viewModel: NotificationSettingsViewModel!
    var toolbarHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableView.contentInset = headerView.recommendedContentInset
    }
    
    func registerCells() {
        NotificationSettingsTableViewCell.registerWithTableView(tableView: tableView)
        NotificationHeaderCell.registerWithTableView(tableView: tableView)
    }
    
    @IBAction func tappedBack() {
        navigationController?.popViewController(animated: true)
    }
}

extension NotificationSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let section = viewModel.sections[indexPath.section]
        
        let cell: UITableViewCell
        switch  section {
        case .header:
            cell = headerCell(indexPath: indexPath)
        case .options:
            cell = optionCell(indexPath: indexPath)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func optionCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSettingsTableViewCell.cellIdentifier) as? NotificationSettingsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(viewModel: viewModel.menuModel(for: indexPath.row))
        
        cell.callback = { newVal in
            if newVal == true {
                print("Option Selected")
                cell.selectionSwitch.tintColor = UIColor(cgColor: Constants.Color.primaryBlue.cgColor)
                cell.selectionSwitch.thumbTintColor = UIColor.white
            } else {
                print("Opted out")
                cell.selectionSwitch.backgroundColor = UIColor.white
                cell.selectionSwitch.thumbTintColor = UIColor(cgColor: Constants.Color.primaryBlue.cgColor)
                cell.selectionSwitch.layer.cornerRadius = 18.0;
                cell.selectionSwitch.layer.borderColor = Constants.Color.primaryBlue.cgColor
                cell.selectionSwitch.layer.borderWidth = 2.0;
            }
        }
        return cell
    }
    
    func headerCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationHeaderCell.cellIdentifier) as? NotificationHeaderCell else {
            return UITableViewCell()
        }
        cell.configure()
        return cell
    }
}
