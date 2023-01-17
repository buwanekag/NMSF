//
//  LocateViewController.swift
//  NMSF
//
//  Created by Matt Stanford on 4/23/21.
//

import UIKit

class PointsOfInterestViewController: UIViewController, ViewModelable {
    
    @IBOutlet var tableView: UITableView!
    
    var viewModel: PointsOfInterestViewModel!
    var locationManager = LocationManager.shared
    let storyListCollection = StoryListCollectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        viewModel.refreshData()
        viewModel.userLocation = locationManager.lastUserLocation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]

        navigationItem.title = viewModel.titleBarText
        navigationItem.titleView?.tintColor = .white
        
        setBookmarkButton()
    }
    
    private func registerCells() {
        PointsOfInterestHeaderCell.registerWithTableView(tableView: tableView)
        StoryListCollectionContainerCell.registerWithTableView(tableView: tableView)
        PointsOfInterestDetailCell.registerWithTableView(tableView: tableView)
        PointsOfInterestListCell.registerWithTableView(tableView: tableView)
        DescriptionTableViewCell.registerWithTableView(tableView: tableView)
        TagListTableViewCell.registerWithTableView(tableView: tableView)
        HoursOfOperationCell.registerWithTableView(tableView: tableView)
        ContactTableViewCell.registerWithTableView(tableView: tableView)
        AccessibleByCell.registerWithTableView(tableView: tableView)
    }
    
    func setBookmarkButton() {
        let icon = viewModel.bookmarkIcon
        let bookmarkButton = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(handleBookmark(_:)))
        navigationItem.rightBarButtonItem = bookmarkButton
    }
}

extension PointsOfInterestViewController {
    // MARK: - Tab Navigation
    
    @objc func handleAbout(_: UIButton){
        viewModel.detailSelection = .about
        viewModel.refreshData()
        tableView.reloadData()
    }
    
    @objc func handleWhatsHere(_: UIButton){
        viewModel.detailSelection = .whatsHere
        viewModel.refreshData()
        tableView.reloadData()
    }
    
    @objc func handleBookmark(_: UIBarButtonItem){
        viewModel.tappedBookmark()
        setBookmarkButton()
    }
}

extension PointsOfInterestViewController: PointOfInterestListItemDelegate {
    // MARK: - POI List Item Delegate
    
    func tappedDelete(itemViewModel: PointsOfInterestListItemViewModel) {
        
    }
}

extension PointsOfInterestViewController: StorySelectionDelegate {
    // MARK: - Story Selection
    
    func selectedStory(index: Int) {
        print("selected story at index: \(index)")
        
        let storyCollection = StoryCollectionViewController()
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.present(storyCollection, animated: true)
    }
}

extension PointsOfInterestViewController: UITableViewDataSource {
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        
        switch section {
        case .pointOfInterestHeader:
            return headerCell()
        case .storyListContainer:
            return storyListCell()
        case .detailSelection:
            return selectionCell()
        case .whatsHere:
            return whatsHereCell(row: indexPath.row)
        case .poiDescription:
            return descriptionCell()
        case .areaAtGlance:
            return areaAtAGlanceCell()
        case.accessibleBy:
            return accessibleByCell()
        case .totalBouys:
            return bouyCell()
        case .helpContact:
            return contactCell()
        case .hoursOfOperation:
            return hoursOfOperationCell()
        }
    }
}

extension PointsOfInterestViewController {
    // MARK: - Cell Configuration
    
    func headerCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PointsOfInterestHeaderCell.className) as? PointsOfInterestHeaderCell else {
            return UITableViewCell()
        }
        
        cell.setupUI(viewModel: viewModel)
        
        return cell
    }
    
    func storyListCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryListCollectionContainerCell.className) as? StoryListCollectionContainerCell else {
            return UITableViewCell()
        }
        
        storyListCollection.delegate = self
        cell.embedView(storyListCollection.view)
        
        return cell
    }
    
    func selectionCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PointsOfInterestDetailCell.className) as? PointsOfInterestDetailCell else {
            return UITableViewCell()
        }
        cell.aboutButton.addTarget(self, action: #selector(handleAbout(_:)), for: .touchUpInside)
        cell.whatsHereButton.addTarget(self, action: #selector(handleWhatsHere(_:)), for: .touchUpInside)
        
        cell.configure(viewModel: viewModel)
        
        return cell
    }
    
    func whatsHereCell(row: Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PointsOfInterestListCell.className) as? PointsOfInterestListCell  else {
            return UITableViewCell()
        }
        
        cell.configure(itemViewModel: viewModel.pointsOfInterestList[row])
        return cell
    }
    
    func descriptionCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.className) as? DescriptionTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(viewModel: viewModel)
        return cell
    }
    
    func areaAtAGlanceCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TagListTableViewCell.className) as? TagListTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(viewModel: viewModel, cellWidth: tableView.bounds.width)
        
        return cell
    }
    
    func hoursOfOperationCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HoursOfOperationCell.className) as? HoursOfOperationCell else {
            return UITableViewCell()
        }
        
        cell.configure()
        return cell
    }
    
    func accessibleByCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccessibleByCell.className) as? AccessibleByCell else {
            return UITableViewCell()
        }
        cell.configure(accessModes: viewModel.accessModes)
        return cell
    }
    
    func contactCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.className) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(cellType: .contact, viewModel: viewModel)
        return cell
    }
    
    func bouyCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.className) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(cellType: .bouy, viewModel: viewModel)
        return cell
    }
}
