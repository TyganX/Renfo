import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MapViewRepresentable: UIViewRepresentable {
    @StateObject private var viewModel = MapAnnotationsViewModel()
    @Binding var selectedFestival: FestivalModel?
    @Binding var showingFestivalView: Bool

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
            return annotationView
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation as? MKPointAnnotation,
                  let festival = parent.viewModel.festivals.first(where: { $0.coordinates?.latitude == annotation.coordinate.latitude && $0.coordinates?.longitude == annotation.coordinate.longitude }) else {
                return
            }
            parent.selectedFestival = festival
            parent.showingFestivalView = true
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
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(viewModel.annotations)

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

class MapAnnotationsViewModel: ObservableObject {
    @Published var annotations: [MKPointAnnotation] = []
    @Published var festivals: [FestivalModel] = []
    private let firestoreService = FirestoreService()

    init() {
        fetchFestivals()
    }

    func fetchFestivals() {
        firestoreService.fetchAllFestivals { fetchedFestivals in
            var fetchedAnnotations: [MKPointAnnotation] = []
            for festival in fetchedFestivals {
                if let coordinates = festival.coordinates {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    annotation.title = festival.name
                    fetchedAnnotations.append(annotation)
                }
            }
            DispatchQueue.main.async {
                self.annotations = fetchedAnnotations
                self.festivals = fetchedFestivals
            }
        }
    }
}
