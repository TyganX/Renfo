//import SwiftUI
//import MapKit
//import CoreLocation
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private var locationManager = CLLocationManager()
//    @Published var userLocation: CLLocationCoordinate2D?
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            DispatchQueue.main.async {
//                self.userLocation = location.coordinate
//            }
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Error while requesting location: \(error.localizedDescription)")
//    }
//}
//
//struct MapViewContainer: UIViewRepresentable {
//    @ObservedObject var viewModel: MapViewModel
//    @ObservedObject var locationManager = LocationManager()
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: MapViewContainer
//
//        init(parent: MapViewContainer) {
//            self.parent = parent
//        }
//
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            let identifier = "FestivalAnnotation"
//            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
//            if annotationView == nil {
//                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                annotationView?.canShowCallout = true
//            } else {
//                annotationView?.annotation = annotation
//            }
//
//            if let annotation = annotation as? MKPointAnnotation,
//               let festival = parent.viewModel.festivals.first(where: { $0.coordinates?.latitude == annotation.coordinate.latitude && $0.coordinates?.longitude == annotation.coordinate.longitude }) {
//
//                let isActive = parent.viewModel.isFestivalActive(festival)
//
//                annotationView?.markerTintColor = isActive ? .systemGreen : nil
//                annotationView?.glyphTintColor = .black
//                annotationView?.glyphImage = UIImage(named: "RenfoLogo")?.resized(to: CGSize(width: 30, height: 30))
//            }
//
//            return annotationView
//        }
//
//        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//            guard let annotation = view.annotation as? MKPointAnnotation else { return }
//            parent.viewModel.selectFestival(with: annotation.coordinate)
//        }
//
//        @objc func moveToUserLocation() {
//            guard let mapView = parent.mapView else { return }
//            if let userLocation = parent.locationManager.userLocation {
//                let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//                mapView.setRegion(region, animated: true)
//            }
//        }
//    }
//
//    @State private var mapView: MKMapView?
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(parent: self)
//    }
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//        mapView.showsUserLocation = true
//        mapView.isZoomEnabled = true
//        mapView.isScrollEnabled = true
//
//        // Add user location button
//        let button = UIButton(type: .system)
//        let buttonImage = UIImage(systemName: "location.fill")?.withRenderingMode(.alwaysTemplate)
//        button.setImage(buttonImage, for: .normal)
//        button.tintColor = .systemBlue
//        button.backgroundColor = .systemGray4
//        button.layer.cornerRadius = 9
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOpacity = 0.25
//        button.layer.shadowOffset = CGSize(width: 0, height: 2)
//        button.layer.shadowRadius = 2
//        button.addTarget(context.coordinator, action: #selector(Coordinator.moveToUserLocation), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        mapView.addSubview(button)
//
//        NSLayoutConstraint.activate([
//            button.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
//            button.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
//            button.widthAnchor.constraint(equalToConstant: 40),
//            button.heightAnchor.constraint(equalToConstant: 40)
//        ])
//
//        self.mapView = mapView
//        return mapView
//    }
//
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        let newAnnotations = Set(viewModel.annotations)
//        let currentAnnotations = Set(uiView.annotations.compactMap { $0 as? MKPointAnnotation })
//
//        if currentAnnotations != newAnnotations {
//            uiView.removeAnnotations(uiView.annotations)
//            uiView.addAnnotations(viewModel.annotations)
//
//            if !viewModel.annotations.isEmpty {
//                let coordinates = viewModel.annotations.map { $0.coordinate }
//                let region = calculateRegion(coordinates: coordinates)
//                uiView.setRegion(region, animated: true)
//            }
//        }
//    }
//
//    private func calculateRegion(coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
//        let minLat = coordinates.map { $0.latitude }.min() ?? 0.0
//        let maxLat = coordinates.map { $0.latitude }.max() ?? 0.0
//        let minLon = coordinates.map { $0.longitude }.min() ?? 0.0
//        let maxLon = coordinates.map { $0.longitude }.max() ?? 0.0
//
//        let center = CLLocationCoordinate2D(
//            latitude: (minLat + maxLat) / 2,
//            longitude: (minLon + maxLon) / 2
//        )
//        let span = MKCoordinateSpan(
//            latitudeDelta: (maxLat - minLat) * 1.2,
//            longitudeDelta: (maxLon - minLon) * 1.2
//        )
//        return MKCoordinateRegion(center: center, span: span)
//    }
//}
//
//extension UIImage {
//    func resized(to targetSize: CGSize) -> UIImage? {
//        let size = self.size
//        let widthRatio  = targetSize.width  / size.width
//        let heightRatio = targetSize.height / size.height
//        let newSize = widthRatio > heightRatio
//            ? CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//            : CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
//        let rect = CGRect(origin: .zero, size: newSize)
//
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
//        self.draw(in: rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage
//    }
//}
//
//
//extension MKCoordinateRegion {
//    init(coordinates: [CLLocationCoordinate2D]) {
//        let minLat = coordinates.map { $0.latitude }.min() ?? 0.0
//        let maxLat = coordinates.map { $0.latitude }.max() ?? 0.0
//        let minLon = coordinates.map { $0.longitude }.min() ?? 0.0
//        let maxLon = coordinates.map { $0.longitude }.max() ?? 0.0
//
//        let center = CLLocationCoordinate2D(
//            latitude: (minLat + maxLat) / 2,
//            longitude: (minLon + maxLon) / 2
//        )
//        let span = MKCoordinateSpan(
//            latitudeDelta: (maxLat - minLat) * 1.2,
//            longitudeDelta: (maxLon - minLon) * 1.2
//        )
//        self.init(center: center, span: span)
//    }
//}
//
//struct MapView: View {
//    @StateObject private var viewModel = MapViewModel()
//
//    var body: some View {
//        MapViewContainer(viewModel: viewModel)
//            .edgesIgnoringSafeArea(.all)
//            .sheet(isPresented: $viewModel.isFestivalViewVisible) {
//                if let selectedFestival = viewModel.selectedFestival {
//                    NavigationStack {
//                        FestivalView(viewModel: FestivalViewModel(festival: selectedFestival, listViewModel: FestivalListViewModel()))
//                    }
////                    .presentationDetents([.medium, .large])
//                    .presentationDetents([.height(295), .large])
//                }
//            }
//            .safeAreaInset(edge: .bottom) {
//                Color.clear
//                    .frame(height: 0)
//                    .background(.thinMaterial)
//            }
//    }
//}
//
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
