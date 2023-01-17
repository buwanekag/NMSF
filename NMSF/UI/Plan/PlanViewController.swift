//
//  PlanViewController.swift
//  NMSF
//
//  Created by Matt Stanford on 4/23/21.
//

import Combine
import CoreLocation
import UIKit

class PlanViewController: UIViewController, CollapsingToolbarVCType {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var sortPickerContainerView: UIView!
    @IBOutlet var sortPickerTopConstraint: NSLayoutConstraint!
    @IBOutlet var sortPickerOverlayBackground: UIView!

    var viewModel = PlanViewModel()
    var disposeBag = [AnyCancellable]()
    var locationManager = LocationManager.shared
    
    var toolbarHeightConstraint: NSLayoutConstraint?
    
    var scrollView: UIScrollView! {
        return tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        
        guard let header = headerView as? PlanHeaderView else {
            fatalError("Header must be a DiscoverHeaderView!")
        }
        
        header.delegate = self
        
        updateBottomContentInset()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self
        
        refreshData(animated: false)
        viewModel.got(userLocation: locationManager.lastUserLocation)
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initializeHeaderHeight()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        potentiallyAdjustToolbarHeight(scrollView)
    }
    
    func registerCells() {
        GuideSortTableViewCell.registerWithTableView(tableView: tableView)
        PlanEmptyStateTableViewCell.registerWithTableView(tableView: tableView)
        PlanFilterTableViewCell.registerWithTableView(tableView: tableView)
        PointsOfInterestListCell.registerWithTableView(tableView: tableView)
        GuideTableViewCell.registerWithTableView(tableView: tableView)
    }
    
    private func updateBottomContentInset() {
        //So we'll have 40 px between last cell and the tab bar (plan cell has 16 px space between bottom + container view)
        var modifiedInsets = tableView.contentInset
        modifiedInsets.bottom = 24
        tableView.contentInset = modifiedInsets
    }
    
    func refreshData(animated: Bool) {

        viewModel.loadData()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    self?.switchTabs(animated: animated)
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in })
            .store(in: &disposeBag)
    }
}

extension PlanViewController: LocationDelegate {
    func gotUpdated(userLocation: CLLocation) {
        viewModel.got(userLocation: userLocation)
        tableView.reloadData()
    }
}

extension PlanViewController: PlanHeaderDelegate {
    
    func switchTabs(animated: Bool) {
        if animated {
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            })
        } else {
            tableView.reloadData()
        }
     
    }
    
    func selectedSegment(index: Int) {
        viewModel.switchedTab(index: index)
        switchTabs(animated: true)
    }
}

extension PlanViewController: PlanFilterDelegate, PointOfInterestListItemDelegate, GuideSortDelegate {
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
    
    func tappedSort() {
        showPicker()
    }
    
    func tappedGuideSort() {
        showPicker()
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
    
    func tappedEdit() {
        viewModel.togglePlanEditMode()
        tableView.reloadData()
    }
    
    func tappedDelete(itemViewModel: PointsOfInterestListItemViewModel) {
        showConfirmationAlert(title: Constants.Plan.deleteAlertTitle,
                              confirmButtonText: Constants.Plan.deleteAlertOkButton, confirmAction: {_ in
                                self.doDeleteItem(itemViewModel: itemViewModel)
                              })
    }
    
    private func doDeleteItem(itemViewModel: PointsOfInterestListItemViewModel) {
        viewModel.delete(planItem: itemViewModel)
        refreshData(animated: true)
    }
}

extension PlanViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension PlanViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = viewModel.sections[indexPath.section]
        switch section {
        case .guideCells:
            showVendorProfile(index: indexPath.row)
        case .planCells:
            tappedPlanCell(index: indexPath.row)
        default:
            break
        }
    }
    
    private func tappedPlanCell(index: Int) {
        let itemViewModel = viewModel.planItemViewModels[index]
        let poiViewModel = PointsOfInterestViewModel(poi: itemViewModel.poi)
        let vc = PointsOfInterestViewController(viewModel: poiViewModel, nibName: PointsOfInterestViewController.className, bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        switch section {
        case .guideSortCell:
            return getGuideSortCell(indexPath: indexPath)
        case .planEmptyStateCell:
            return getPlanEmptyStateCell(indexPath: indexPath)
        case .planFilterCell:
            return getPlanFilterCell(indexPath: indexPath)
        case .planCells:
            return getPlanCell(indexPath: indexPath)
        case .guideCells:
            return getGuideCell(indexPath: indexPath)
        }
    }
    
    private func getPlanCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PointsOfInterestListCell.cellIdentifier) as? PointsOfInterestListCell else {
            fatalError("Couldn't get cell!")
        }
        let itemViewModel = viewModel.planItemViewModels[indexPath.row]
        cell.configurePlanView(itemViewModel: itemViewModel, delegate: self)
        return cell
    }
    
    private func getGuideCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GuideTableViewCell.cellIdentifier) as? GuideTableViewCell else {
            fatalError("Couldn't get cell!")
        }
        let itemViewModel = viewModel.guideItemViewModels[indexPath.row]
        cell.configure(itemViewModel: itemViewModel)
        return cell
    }
    
    private func getPlanFilterCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanFilterTableViewCell.cellIdentifier) as? PlanFilterTableViewCell else {
            fatalError("Couldn't get cell!")
        }
        
        cell.configure(planViewModel: viewModel.planFilterViewModel, delegate: self)
        cell.selectionStyle = .none
        
        return cell
    }
    
    private func getPlanEmptyStateCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanEmptyStateTableViewCell.cellIdentifier) as? PlanEmptyStateTableViewCell else {
            fatalError("Couldn't get cell!")
        }
        cell.configure()
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    private func getGuideSortCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GuideSortTableViewCell.cellIdentifier) as? GuideSortTableViewCell else {
            fatalError("Couldn't get cell!")
        }
        cell.configure(filterViewModel: viewModel.guideFilterViewModel, delegate: self)
        cell.selectionStyle = .none
        return cell
    }
    private func showVendorProfile(index: Int) {
        let guide = viewModel.guideItemViewModels[index]
        let profile = VendorProfile(rating: "Blue Star Operator", name: guide.guideTitle, address: guide.addressString,distance: guide.distanceString, description: guide.descriptionText, phone: "234-234-3443", website: "https://google.com")
        
        let vm = VendorProfileViewModel(profile: profile)
        let vc = VendorProfileViewController(viewModel: vm, nibName: VendorProfileViewController.className, bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension PlanViewController: PlanEmptyCellDelegate {
    func didSelectLocateSanctuary() {
        let vc = NMSFTabBarViewController(nibName: NMSFTabBarViewController.className, bundle: Bundle.main)
        vc.select(tab:.locate)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
