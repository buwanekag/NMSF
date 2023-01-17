//
//  MapViewController.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/1/21.
//

import UIKit
import MapKit
import CoreLocation
import Foundation
import Combine


class MapViewController: UIViewController, ViewModelable {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet var sortPickerContainerView: UIView!
    @IBOutlet var sortPickerTopConstraint: NSLayoutConstraint!
    @IBOutlet var sortPickerOverlayBackground: UIView!
    @IBOutlet var mapViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private(set) var tableView: UITableView!
    @IBOutlet weak private(set) var listViewHeight: NSLayoutConstraint!
    
    var viewModel: MapViewModel!
    var disposeBag = [AnyCancellable]()
    var locationManager = LocationManager.shared
    var regionHasBeenSet = false
    var shouldShiftDown = false
    
    var bottomSheetState: BottomSheetState = .half {
        didSet {
            guard oldValue != bottomSheetState else {
                return
            }
            if bottomSheetState == .peeking, shouldShiftDown {
                shouldShiftDown = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        registerMapAnnotations()
        registerCells()
        setInitialMapRegion()
        loadData()
        
        locationManager.startLocationServices()
        updateState(to: .peeking)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self
        viewModel.refresh(userLocation: locationManager.lastUserLocation)
        reloadList()
    }
    
    func loadData() {
        viewModel.loadData()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    self?.refreshUI()
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
            }, receiveValue: { _ in })
            .store(in: &disposeBag)
    }
    
    private func refreshUI() {
        self.reloadList()
        self.refreshMapAnnotations()
        self.refreshZonePolylines()
    }
    
    func registerCells() {
        
        tableView.roundCorners([.topLeft, .topRight], radius: 15)
        tableView.register(UINib(nibName: BottomSheetHeader.className, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: BottomSheetHeader.className)
        PointsOfInterestListCell.registerWithTableView(tableView: tableView)
        PlanFilterTableViewCell.registerWithTableView(tableView: tableView)
        DiscoverSearchTableViewCell.registerWithTableView(tableView: tableView)
    }
    
    func registerMapAnnotations() {
        mapView.register(SiteAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    func refreshMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        viewModel.siteAnnotations.forEach { mapView.addAnnotation($0)}
    }
    
    func refreshZonePolylines() {
        mapView.removeOverlays(mapView.overlays)
        viewModel.zonePolygons.forEach { mapView.addOverlay($0) }
    }
    
    func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.isUserInteractionEnabled = true
        mapView.isZoomEnabled = true
        currentLocationButton.setImage(Constants.Image.currentLocationFilled, for: .selected)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(triggerTouchAction(gestureRecognizer:)))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
}

extension MapViewController: LocationDelegate {
    func gotUpdated(userLocation: CLLocation) {
        viewModel.refresh(userLocation: userLocation)
        reloadList()
    }
    
    func setInitialMapRegion() {
        if !regionHasBeenSet {
            mapView.mapType = MKMapType.satellite
            let locValue:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 24.667088, longitude: -81.583142)
            let span = MKCoordinateSpan(latitudeDelta: 0.951, longitudeDelta: 2.951)
            let region = MKCoordinateRegion(center: locValue, span: span)
            mapView.setRegion(region, animated: true)
            regionHasBeenSet = true
        }
    }
    
    @IBAction func recenter(_: UIButton) {
        regionHasBeenSet = false
        mapView.reloadInputViews()
        updateState(to: .peeking)
        currentLocationButton.isSelected = true
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
    
    @objc func triggerTouchAction(gestureRecognizer: UITapGestureRecognizer) {
        updateState(to: .peeking)
        currentLocationButton.isSelected =  false
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        guard let mapPolygon = overlay as? NMSFMapPolygon else {
            fatalError("Only use the custom map polygon class!")
        }
        let renderer = MKPolygonRenderer(polygon: mapPolygon)
        renderer.strokeColor = mapPolygon.lineColor
        renderer.lineWidth = mapPolygon.lineWidth
        renderer.lineDashPattern = mapPolygon.lineDashPattern
        
        return renderer
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? NMSFPointAnnotation,
              let site = annotation.site else {
            return
        }
        let vm = PointsOfInterestViewModel(poi: site)
        let vc = PointsOfInterestViewController(viewModel: vm, nibName: PointsOfInterestViewController.className, bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        updateState(to: .peeking)
    }
}


extension MapViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
