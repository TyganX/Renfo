import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    @ObservedObject var viewModel: MapViewModel

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable

        init(parent: MapViewRepresentable) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "FestivalAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            if let annotation = annotation as? MKPointAnnotation,
               let festival = parent.viewModel.festivals.first(where: { $0.coordinates?.latitude == annotation.coordinate.latitude && $0.coordinates?.longitude == annotation.coordinate.longitude }) {
                
                let isActive = parent.viewModel.isFestivalActive(festival)
                
                annotationView?.markerTintColor = isActive ? .systemGreen : nil
                annotationView?.glyphTintColor = .black
                annotationView?.glyphText = nil // Remove text/icon for now to focus on color
            }
            
            return annotationView
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation as? MKPointAnnotation else { return }
            parent.viewModel.selectFestival(annotation: annotation)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if uiView.annotations.isEmpty {
            uiView.addAnnotations(viewModel.annotations)
        } else {
            let currentAnnotations = Set(uiView.annotations.compactMap { $0 as? MKPointAnnotation })
            let newAnnotations = Set(viewModel.annotations)
            
            if currentAnnotations != newAnnotations {
                uiView.removeAnnotations(uiView.annotations)
                uiView.addAnnotations(viewModel.annotations)
            }
        }

        if !viewModel.annotations.isEmpty {
            let coordinates = viewModel.annotations.map { $0.coordinate }
            let region = MKCoordinateRegion(coordinates: coordinates)
            uiView.setRegion(region, animated: true)
        }
    }
}

extension MKCoordinateRegion {
    init(coordinates: [CLLocationCoordinate2D]) {
        let minLat = coordinates.map { $0.latitude }.min() ?? 0.0
        let maxLat = coordinates.map { $0.latitude }.max() ?? 0.0
        let minLon = coordinates.map { $0.longitude }.min() ?? 0.0
        let maxLon = coordinates.map { $0.longitude }.max() ?? 0.0

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.2,
            longitudeDelta: (maxLon - minLon) * 1.2
        )
        self.init(center: center, span: span)
    }
}
