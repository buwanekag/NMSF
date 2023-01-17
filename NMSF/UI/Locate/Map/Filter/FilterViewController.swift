//
//  FilterViewController.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/25/21.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func dismissedFilter(items: [POIFilterItemViewModel])
}

class FilterViewController: KeyboardAvoidingScrollViewController, ViewModelable {
    
    var viewModel: FilterViewModel!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var sortPickerContainerView: UIView!
    @IBOutlet var sortPickerTopConstraint: NSLayoutConstraint!
    @IBOutlet var sortPickerOverlayBackground: UIView!
    
    weak var delegate: FilterViewControllerDelegate?
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
        searchHeader.setupUI(title: Constants.Locate.Filter.filterBy, placeholder: Constants.Locate.Filter.searchInterests)
        searchHeader.delegate = self
    }
    
    func registerCells() {
        FilterListTableViewCell.registerWithTableView(tableView: tableView)
        SortTableViewCell.registerWithTableView(tableView: tableView)
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
        
        viewModel.didSelectDone()
        tableView.reloadData()
    }
    
    
    @IBAction  func closeButtonTapped(_: UIButton) {
        self.dismiss(animated: true, completion: nil)
        delegate?.dismissedFilter(items: viewModel.selectedFilteredItems)
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        if viewModel.searchViewModels != nil && viewModel.showCategory == false{
            switch section {
            case .filterCell:
                return getPlanFilterCell(indexPath: indexPath)
            default:
                return getItemCell(indexPath: indexPath)
            }
            
        } else {
            switch section {
            case .filterCell:
                return getPlanFilterCell(indexPath: indexPath)
            case .accessibleBy, .fishingHarvesting, .habitats, .interests, .siteType:
                return getCategoryItemCell(indexPath: indexPath)
            case .items:
                return getItemCell(indexPath: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = viewModel.sections[section]
        let headerLabel = UILabel()
        var text = ""
        headerLabel.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .bold)
        headerLabel.backgroundColor = .white
        headerLabel.textColor = Constants.Color.darkBlue
        
        
        if viewModel.showCategory {
            switch section {
            case .accessibleBy:
                text = Constants.Locate.Filter.accessibleBy
            case .fishingHarvesting:
                text = Constants.Locate.Filter.fishingHarvesting
            case .interests:
                text = Constants.Locate.Filter.interests
            case .siteType:
                text = Constants.Locate.Filter.siteType
            case .habitats:
                text = Constants.Locate.Filter.habitats
            case .filterCell, .items:
                return headerLabel
            }
            headerLabel.text = text
            headerLabel.font = UIFont.preferredFont(forTextStyle: .callout, weight: .bold)
            return headerLabel
        } else {
            return headerLabel
        }
    }
    
    private func getItemCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterListTableViewCell.cellIdentifier) as? FilterListTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.selectionStyle = .none
        let items = viewModel.searchViewModels ?? viewModel.filterItems
        cell.configure(item: items[indexPath.row], clearAll: viewModel.clearAll)
        return cell
    }
    
    private func getCategoryItemCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterListTableViewCell.cellIdentifier) as? FilterListTableViewCell else {
            return UITableViewCell()
        }
        var items: [POIFilterItemViewModel] = []
        cell.delegate = self
        cell.selectionStyle = .none
        let section = viewModel.sections[indexPath.section]
        switch section {
        case .accessibleBy:
            items = viewModel.accessibleByItems
        case .fishingHarvesting:
            items = viewModel.fishingHarvestingItems
        case .habitats:
            items = viewModel.habitatItems
        case .interests:
            items = viewModel.interestsItems
        case .siteType:
            items = viewModel.siteTypeItems
        default:
            items = viewModel.filterItems
            
        }
        cell.configure(item: items[indexPath.row], clearAll: viewModel.clearAll)
        return cell
    }
    
    private func getPlanFilterCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SortTableViewCell.cellIdentifier) as? SortTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(planViewModel: viewModel.filterCellViewModel, delegate: self)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension FilterViewController: POISearchHeaderDelegate, SortCellDelegate, FilterListItemDelegate {
    func selected(item: POIFilterItemViewModel) {
        viewModel.didSelectItem(item: item)
    }
    
    func deSelected(item: POIFilterItemViewModel) {
        viewModel.didDeSelectItem(item: item)
    }
    
    func tappedSort() {
        viewModel.clearAll = false
        showPicker()
    }
    
    func tappedClear() {
        viewModel.clearAll = true
        viewModel.selectedFilteredItems.removeAll()
        tableView.reloadData()
    }
    
    
    func searched(for string: String) {
        viewModel.searchedFor(string: string)
        tableView.reloadData()
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

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
