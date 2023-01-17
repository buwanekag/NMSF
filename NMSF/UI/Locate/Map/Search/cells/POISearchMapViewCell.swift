//
//  POISearchMapViewCell.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/20/21.
//

import UIKit
import MapKit
class POISearchMapViewCell: UITableViewCell {

    @IBOutlet var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure() {
        mapView.roundCorners(.allCorners, radius: 15)
        mapView.mapType = .satellite
    }
}
