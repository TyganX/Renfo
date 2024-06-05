//import MapKit
//
//class AnnotationView: MKMarkerAnnotationView {
//    static let ReuseID = "cultureAnnotation"
//    let clusterID = "clustering"
//
//    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
//        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
//        clusteringIdentifier = clusterID
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func prepareForDisplay() {
//        super.prepareForDisplay()
//        displayPriority = .defaultLow
//    }
//}
//
//class ClusterAnnotationView: MKMarkerAnnotationView {
//    override var annotation: MKAnnotation? {
//        willSet {
//            guard let cluster = newValue as? MKClusterAnnotation else { return }
//            canShowCallout = true
//
//            let total = cluster.memberAnnotations.count
//            let text = "\(total)"
//            let color: UIColor = .systemRed
//
//            let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
//            let image = renderer.image { _ in
//                color.setFill()
//                UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width: 40, height: 40))).fill()
//                let attributes: [NSAttributedString.Key: Any] = [
//                    .foregroundColor: UIColor.white,
//                    .font: UIFont.boldSystemFont(ofSize: 20)
//                ]
//                let textSize = text.size(withAttributes: attributes)
//                let textRect = CGRect(x: (40 - textSize.width) / 2, y: (40 - textSize.height) / 2, width: textSize.width, height: textSize.height)
//                text.draw(in: textRect, withAttributes: attributes)
//            }
//
//            markerTintColor = nil
//            glyphImage = image
//        }
//    }
//}
