//
//  MapViewController+FloatingList.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/18/21.
//

import UIKit

private var isAnimatingList: Bool = false
private var lastSwipeDirection: UISwipeGestureRecognizer.Direction?

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    
    private var cellHeight: CGFloat {
        return 200
    }
    
    private var peekingHeight: CGFloat {
        return  150
    }
    
    private var topMapConstraint: CGFloat {
        return 65
    }
    
    private var sectionHeaderHeight: CGFloat {
        return 60
    }
    
    private var fullHeight: CGFloat {
        let frameHeight = tableView.superview?.frame.size.height ?? UIScreen.main.bounds.height
        let topConstraint = topMapConstraint
        return frameHeight - topConstraint
    }
    
    private var halfHeight: CGFloat {
        return fullHeight / 2
    }
    
    private var pointOfInterestList: [PointsOfInterestListItemViewModel] {
        var poiList: [PointsOfInterestListItemViewModel] = []
        poiList = viewModel.pointOfInterestList
        return poiList
    }
    
    func reloadList() {
        let hasPoiList = !pointOfInterestList.isEmpty
        let alpha: CGFloat = hasPoiList ? 1.0 : 0.0
        
        UIView.animate(withDuration: 0.25) {
            self.tableView.alpha = alpha
        }
        
        tableView.reloadData()
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
        case .filterCell:
            return getPlanFilterCell(indexPath:indexPath)
        case .pointsOfInterestCell:
            return getPointOfInterestCell(indexPath: indexPath)
        case .filterItems:
            return getFilterCountCell(indexPath: indexPath)
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if viewModel.sections[section] == .filterCell {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: BottomSheetHeader.className) as? BottomSheetHeader else {
                return nil
            }
            
            header.filterButton.addTarget(self, action: #selector(showFilter(sender:)), for: .allEvents)
            header.searchButton.addTarget(self, action: #selector(showSearch(sender:)), for: .allEvents)
            return header
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModel.sections[section] == .filterCell {
            return sectionHeaderHeight
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let poi = viewModel.pointOfInterestList[indexPath.row].poi
   
        let vm = PointsOfInterestViewModel(poi: poi)
        let vc = PointsOfInterestViewController(viewModel: vm, nibName: PointsOfInterestViewController.className, bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func getPlanFilterCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanFilterTableViewCell.cellIdentifier) as? PlanFilterTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureForBottomSheet(planViewModel: viewModel.POIFilterViewModel, delegate: self)
        cell.selectionStyle = .none
        
        return cell
    }
    
    private func getPointOfInterestCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PointsOfInterestListCell.cellIdentifier) as? PointsOfInterestListCell else {
            return UITableViewCell()
        }
        let itemViewModel = viewModel.pointOfInterestList[indexPath.row]
        cell.configure(itemViewModel: itemViewModel)
        return cell
    }
    
    private func getFilterCountCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiscoverSearchTableViewCell.cellIdentifier, for: indexPath) as? DiscoverSearchTableViewCell else {
            fatalError("Couldn't get cell!")
        }
        let filters = viewModel.filteredItems.map{$0.title}
        let items = filters.map {$0}.joined(separator: ", ")
        cell.configureFilterCount(count: filters.count, items: items)
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func showSearch(sender: UIButton) {
        let vm = POISearchViewModel(viewModels: viewModel.pointOfInterestList)
        let vc = POISearchViewController(viewModel: vm, nibName: POISearchViewController.className, bundle: nil)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
    
    @objc func showFilter(sender: UIButton) {
        let vm = FilterViewModel(selection: viewModel.filteredItems, list: viewModel.pointOfInterestList)
        let vc = FilterViewController(viewModel: vm, nibName: FilterViewController.className, bundle: nil)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

extension MapViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapThatListView()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isAnimatingList else {
            scrollView.contentOffset = CGPoint.zero
            return
        }
        let vertOffset = scrollView.contentOffset.y
        if vertOffset > 0 {
            lastSwipeDirection = .up
        } else if vertOffset < 0 {
            lastSwipeDirection = .down
        }
        
        let shouldShiftUp = (tableView.frame.origin.y >= 0) && (lastSwipeDirection == .up)
        let shouldShiftDown = (tableView.frame.origin.y <= fullHeight - peekingHeight) && (lastSwipeDirection == .down)
        
        if shouldShiftUp || shouldShiftDown {
            listViewHeight.constant += vertOffset
            scrollView.contentOffset = CGPoint.zero
            view.setNeedsLayout()
        }
    }
    
    private func snapThatListView() {
        let needsToSnap = peekingHeight + 1 ..< fullHeight ~= listViewHeight.constant
        let isScrollingListView = tableView.contentOffset != CGPoint.zero
        guard needsToSnap, !isScrollingListView, !isAnimatingList, let direction = lastSwipeDirection else {
            return
        }
        let isDownLow = listViewHeight.constant < halfHeight
        let isUpHigh = listViewHeight.constant > halfHeight
        
        switch direction {
        case .up where !isDownLow:
            updateState(to: .full)
        case .down where !isUpHigh:
            updateState(to: .peeking)
        default:
            updateState(to: .half)
        }
    }
    
    func updateState(to state: BottomSheetState) {
        view.layoutIfNeeded()
        isAnimatingList = true
        
        self.bottomSheetState = state
        
        switch state {
        case .peeking:
            mapViewTopConstraint.constant = topMapConstraint
            listViewHeight.constant = peekingHeight
        case .half:
            mapViewTopConstraint.constant = topMapConstraint
            listViewHeight.constant = halfHeight
        case .full:
            let topSafeInset = view.superview?.safeAreaInsets.top ?? 0
            mapViewTopConstraint.constant = UIScreen.main.bounds.minY - topSafeInset
            listViewHeight.constant = fullHeight
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            isAnimatingList = false
        })
    }
}

extension MapViewController {
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

extension MapViewController: PointOfInterestListItemDelegate {
    func tappedDelete(itemViewModel: PointsOfInterestListItemViewModel) {
        
    }
}

extension MapViewController: PlanFilterDelegate, FilterViewControllerDelegate {
    func dismissedFilter(items: [POIFilterItemViewModel]) {
        viewModel.filteredItems = items
    
        viewModel.filterList()
        tableView.reloadData()
    }
    
    func tappedSort() {
        showPicker()
    }
    
    func tappedEdit() {
        print("EDIT")
    }
}
