//
//  MapClusterView.swift
//  NMSF
//
//  Created by Buwaneka Galpoththawela on 5/12/21.
//

import Foundation
import MapKit


/// - Tag: ClusterAnnotationView
class ClusterAnnotationView: MKAnnotationView {
    let clusterImageWidth: CGFloat = 20
    let clusterImageHeight: CGFloat = 20
   
    // MARK: Initialization
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        displayPriority = .defaultHigh
        collisionMode = .circle
        
        frame = CGRect(x: 0, y: 0, width: clusterImageWidth, height: clusterImageHeight)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        setupUI()
    }
    // MARK: Setup
    private func setupUI() {
        
        image = drawClusterImage(for: count(), wholeColor: Constants.Color.annotationBlue)
        self.addShadow()
    }
    
    
    private func drawClusterImage(for count: Int,wholeColor: UIColor?) -> UIImage {
        
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: clusterImageWidth, height: clusterImageHeight))
        return renderer.image { _ in
            wholeColor?.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: clusterImageWidth, height: clusterImageHeight)).fill()
            
            let attributes = [ NSAttributedString.Key.foregroundColor: Constants.Color.darkBlue,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10)]
            let text = "\(count)"
            let size = text.size(withAttributes: attributes)
            
            let rect = CGRect(x: clusterImageWidth / 2 - size.width / 2, y: clusterImageHeight / 2 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
    
    func count() -> Int {
        guard let cluster = annotation as? MKClusterAnnotation else {
            return 0
        }
        return cluster.memberAnnotations.count
    }
}


