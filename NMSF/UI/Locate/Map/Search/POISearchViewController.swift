//
//  POISearchViewController.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/19/21.
//

import UIKit

class POISearchViewController:  KeyboardAvoidingScrollViewController, ViewModelable {
    
    var viewModel: POISearchViewModel!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var sortPickerContainerView: UIView!
    @IBOutlet var sortPickerTopConstraint: NSLayoutConstraint!
    @IBOutlet var sortPickerOverlayBackground: UIView!
    
    
    var scrollView: UIScrollView! {
        return tableView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        keyboardShouldDismissOnTap = true
        guard let searchHeader = headerView as? POISearchHeader else {
            fatalError("Header must be a POIHeaderView!")
        }
        searchHeader.setupUI(title: "Search", placeholder: Constants.Locate.PointsOfInterest.searchPlaceholder)
        searchHeader.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    

    func registerCells() {
        tableView.register(UINib(nibName: POISearchHeader.className, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: POISearchHeader.className)
        PointsOfInterestListCell.registerWithTableView(tableView: tableView)
        PlanFilterTableViewCell.registerWithTableView(tableView: tableView)
        POISearchEmptyStateCell.registerWithTableView(tableView: tableView)
        DiscoverSearchTableViewCell.registerWithTableView(tableView: tableView)
        POISearchMapViewCell.registerWithTableView(tableView: tableView)
    }
    
    @IBAction func onDoneButtonTapped() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.sortPickerOverlayBackground.alpha = 0
            self.sortPickerTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.sortPickerOverlayBackground.isHidden = true
        })
    }
    
    @IBAction  func closeButtonTapped(_: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension POISearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.numRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        switch section {
        case .emptyStateCell:
            return getEmptyStateCell()
        case .searchHeader:
            return getSearchCell(indexPath: indexPath)
        case .pointOfInterestCell:
            return getPointOfInterestCell(indexPath: indexPath)
        case .filter:
            return getFilterCell()
        case .mapView:
            return getMapViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let poiList = viewModel.searchViewModels ?? viewModel.itemViewModels
        let poi = poiList[indexPath.row].poi
        let vm = PointsOfInterestViewModel(poi: poi)
        let vc = PointsOfInterestViewController(viewModel: vm, nibName: PointsOfInterestViewController.className, bundle: nil)
//        let navVC = UINavigationController(rootViewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func getSearchCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiscoverSearchTableViewCell.cellIdentifier, for: indexPath) as? DiscoverSearchTableViewCell else {
            fatalError("Couldn't get cell!")
        }
        cell.configure(numSearchItems: viewModel.numItemsInSearch)
        return cell
    }
    
    private func getPointOfInterestCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PointsOfInterestListCell.cellIdentifier) as? PointsOfInterestListCell else {
            return UITableViewCell()
        }
        let itemViewModel = viewModel.item(at: indexPath)
        cell.configure(itemViewModel: itemViewModel,searchString: viewModel.currentSearchString)
        return cell
    }
    
    private func getEmptyStateCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: POISearchEmptyStateCell.cellIdentifier) as? POISearchEmptyStateCell else {
            fatalError("Couldn't get cell!")
        }
        cell.configure()
        cell.selectionStyle = .none
        return cell
    }
    
    private func getFilterCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanFilterTableViewCell.cellIdentifier) as? PlanFilterTableViewCell else {
            fatalError("Couldn't get cell!")
        }
        
        cell.configureForBottomSheet(planViewModel: viewModel.searchFilterViewModel, delegate: self)
        cell.selectionStyle = .none
        
        return cell
    }
    
    private func getMapViewCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: POISearchMapViewCell.cellIdentifier) as? POISearchMapViewCell else {
            fatalError("Couldn't get cell!")
        }
        cell.configure()
        cell.selectionStyle = .none
        return cell
    }
}
extension POISearchViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numSortRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.sortTitle(for: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.didSelectSort(row: row)
        tableView.reloadData()
    }
}
extension POISearchViewController: POISearchHeaderDelegate {
    
    func searched(for string: String) {
        viewModel.searchedFor(string: string)
        tableView.reloadData()
    }
    
    
}

extension POISearchViewController: PlanFilterDelegate {
    func tappedSort() {
        showPicker()
    }
    
    func tappedEdit() {
        print("TAPPED out")
    }
    
    
    private func showPicker() {
        let height = self.view.safeAreaInsets.bottom + self.sortPickerContainerView.frame.height
        
        self.sortPickerOverlayBackground.isHidden = false
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.sortPickerTopConstraint.constant = -1 * height
            self.sortPickerOverlayBackground.alpha = 1
            self.view.layoutIfNeeded()
        })
    }
    
}
