//
//  MoreViewController.swift
//  NMSF
//
//  Created by Matt Stanford on 4/23/21.
//

import Combine
import UIKit

class MoreViewController: UIViewController, CollapsingToolbarVCType, ViewModelable {
    
    var viewModel: MoreViewModel!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: UIView!
      
    var toolbarHeightConstraint: NSLayoutConstraint?
    
    let dataFeedLoader = DataFeedLoader.shared
    var disposeBag = [AnyCancellable]()
    
    var scrollView: UIScrollView! {
        return tableView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initializeHeaderHeight()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        potentiallyAdjustToolbarHeight(scrollView)
    }

    func registerCells() {
        MoreMenuTableViewCell.registerWithTableView(tableView: tableView)
    }
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MoreMenuItems.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreMenuTableViewCell.cellIdentifier) as? MoreMenuTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(viewModel: viewModel.menuModel(for: indexPath.row))

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        
        case MoreMenuItems.refresh.rawValue:
            doRefreshData()
        case MoreMenuItems.notification.rawValue:
            showNotificationSettingsView()
        case MoreMenuItems.about.rawValue:
            showAboutView()
        case MoreMenuItems.privacy.rawValue:
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url)
            }
        default:
            return
        }
    }
    
    
    func showNotificationSettingsView(){
        let vm = NotificationSettingsViewModel()
        let vc = NotificationSettingsViewController(viewModel: vm, nibName: NotificationSettingsViewController.className, bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAboutView() {
        let vc = AboutAppViewController(nibName: AboutAppViewController.className, bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func doRefreshData() {
        dataFeedLoader.refreshData()
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    print("finished refreshing data!")
                case .failure(let error):
                    print("error refreshing data: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in })
            .store(in: &disposeBag)
    }
}
