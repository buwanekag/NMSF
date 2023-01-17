//
//  SiteAnnotationView.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/12/21.
//

import Foundation
import MapKit

class SiteAnnotationView: MKAnnotationView {
    static let ReuseID = "siteAnnotation"
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        image = UIImage(named:"site_annotation")
        clusteringIdentifier = String(describing: SiteAnnotationView.self)
        self.addShadow()
    }
}
