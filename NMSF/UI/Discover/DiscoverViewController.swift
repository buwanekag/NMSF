//
//  DiscoverViewController.swift
//  NMSF
//
//  Created by Matt Stanford on 4/23/21.
//

import UIKit

class DiscoverViewController: KeyboardAvoidingScrollViewController, CollapsingToolbarVCType {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    
    var toolbarHeightConstraint: NSLayoutConstraint?
    
    var viewModel = DiscoverViewModel()
    
    var scrollView: UIScrollView! {
        return tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        keyboardShouldDismissOnTap = true
        
        guard let discoverHeader = headerView as? DiscoverHeaderView else {
            fatalError("Header must be a DiscoverHeaderView!")
        }
        discoverHeader.delegate = self
        
        updateBottomContentInset()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initializeHeaderHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        potentiallyAdjustToolbarHeight(scrollView)
    }
    
    private func registerCells() {
        DiscoverTableViewCell.registerWithTableView(tableView: tableView)
        DiscoverSearchTableViewCell.registerWithTableView(tableView: tableView)
    }
    
    private func updateBottomContentInset() {
        //So we'll have 40 px between last cell and the tab bar (cell has 16 px space between bottom + container view)
        var modifiedInsets = tableView.contentInset
        modifiedInsets.bottom = 24
        tableView.contentInset = modifiedInsets
    }
}

extension DiscoverViewController: DiscoverHeaderDelegate {
    func searched(for string: String) {
        viewModel.searchedFor(string: string)
        tableView.reloadData()
    }
}

extension DiscoverViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section]
        switch section {
        case .items:
            print("selected discover cell!")
        case .searchHeader:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        switch section {
        case .searchHeader:
            return getSearchCell(indexPath: indexPath)
        case .items:
            return getRegularCell(indexPath: indexPath)
        }
    }
    
    private func getRegularCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiscoverTableViewCell.cellIdentifier, for: indexPath) as? DiscoverTableViewCell else {
            fatalError("Couldn't get cell!")
        }
        let itemViewModel = viewModel.item(at: indexPath)
        cell.configure(viewModel: itemViewModel, searchString: viewModel.currentSearchString)
        return cell
    }
    
    private func getSearchCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiscoverSearchTableViewCell.cellIdentifier, for: indexPath) as? DiscoverSearchTableViewCell else {
            fatalError("Couldn't get cell!")
        }
        cell.configure(numSearchItems: viewModel.numItemsInSearch)
        return cell
    }
}
