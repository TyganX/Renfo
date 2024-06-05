//import SwiftUI
//import MapKit
//
//struct MapViewContainer: UIViewRepresentable {
//    @ObservedObject var locationManager: SimpleLocationManager
//    @ObservedObject var viewModel: MapViewModel
//    @State private var mapView = MKMapView()
//    @State private var isSatelliteView = false
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: MapViewContainer
//
//        init(parent: MapViewContainer) {
//            self.parent = parent
//        }
//
//        @objc func moveToUserLocation() {
//            parent.locationManager.requestLocationAccess()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in // Wait for location update
//                guard let self = self else { return }
//                guard let userLocation = self.parent.locationManager.userLocation else { return }
//                let region = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0))
//                self.parent.mapView.setRegion(region, animated: true)
//            }
//        }
//
//        @objc func toggleMapType() {
//            parent.isSatelliteView.toggle()
//            parent.mapView.mapType = parent.isSatelliteView ? .hybrid : .standard
//            let mapTypeButtonImage = UIImage(systemName: parent.isSatelliteView ? "globe.americas.fill" : "map.fill")?.withRenderingMode(.alwaysTemplate)
//            parent.mapTypeButton.setImage(mapTypeButtonImage, for: .normal)
//        }
//
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            if let clusterAnnotation = annotation as? MKClusterAnnotation {
//                let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: clusterAnnotation)
//                return annotationView
//            }
//
//            guard let annotation = annotation as? LandmarkAnnotation else { return nil }
//            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationView.ReuseID, for: annotation) as! MKMarkerAnnotationView
//            annotationView.canShowCallout = true
//            return annotationView
//        }
//
//        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//            guard let annotation = view.annotation else { return }
//            parent.viewModel.selectFestival(with: annotation.coordinate)
//        }
//    }
//
//    var mapTypeButton = UIButton()
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//
//    func makeUIView(context: Context) -> MKMapView {
//        mapView.delegate = context.coordinator
//        mapView.showsUserLocation = true
//        mapView.userTrackingMode = .none
//        mapView.isPitchEnabled = true // Enable 3D gestures
//        mapView.isRotateEnabled = true
//        mapView.register(AnnotationView.self, forAnnotationViewWithReuseIdentifier: AnnotationView.ReuseID)
//        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
//
//        // Adjust compass position
//        mapView.layoutMargins = UIEdgeInsets(top: 95, left: 0, bottom: 0, right: 3)
//
//        // Add user location and map type buttons with a single blur effect view
//        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
//        blurEffectView.layer.cornerRadius = 8
//        blurEffectView.clipsToBounds = true // Ensure corners are clipped
//
//        // Map type button
//        let mapTypeButtonImage = UIImage(systemName: "map.fill")?.withRenderingMode(.alwaysTemplate)
//        mapTypeButton.setImage(mapTypeButtonImage, for: .normal)
//        mapTypeButton.tintColor = .systemBlue
//        mapTypeButton.backgroundColor = .clear
//        mapTypeButton.addTarget(context.coordinator, action: #selector(Coordinator.toggleMapType), for: .touchUpInside)
//        mapTypeButton.translatesAutoresizingMaskIntoConstraints = false
//
//        // Location button
//        let locationButton = UIButton(type: .system)
//        let locationButtonImage = UIImage(systemName: "location.fill")?.withRenderingMode(.alwaysTemplate)
//        locationButton.setImage(locationButtonImage, for: .normal)
//        locationButton.tintColor = .systemBlue
//        locationButton.backgroundColor = .clear
//        locationButton.addTarget(context.coordinator, action: #selector(Coordinator.moveToUserLocation), for: .touchUpInside)
//        locationButton.translatesAutoresizingMaskIntoConstraints = false
//
//        // Adding both buttons to the blur effect view
//        blurEffectView.contentView.addSubview(mapTypeButton)
//        blurEffectView.contentView.addSubview(locationButton)
//        mapView.addSubview(blurEffectView)
//
//        NSLayoutConstraint.activate([
//            // Blur effect view constraints
//            blurEffectView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10),
//            blurEffectView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 70),
//            blurEffectView.widthAnchor.constraint(equalToConstant: 40),
//            blurEffectView.heightAnchor.constraint(equalToConstant: 80),
//
//            // Map type button constraints
//            mapTypeButton.topAnchor.constraint(equalTo: blurEffectView.contentView.topAnchor),
//            mapTypeButton.centerXAnchor.constraint(equalTo: blurEffectView.contentView.centerXAnchor),
//            mapTypeButton.widthAnchor.constraint(equalTo: blurEffectView.contentView.widthAnchor),
//            mapTypeButton.heightAnchor.constraint(equalTo: blurEffectView.contentView.heightAnchor, multiplier: 0.5),
//
//            // Location button constraints
//            locationButton.bottomAnchor.constraint(equalTo: blurEffectView.contentView.bottomAnchor),
//            locationButton.centerXAnchor.constraint(equalTo: blurEffectView.contentView.centerXAnchor),
//            locationButton.widthAnchor.constraint(equalTo: blurEffectView.contentView.widthAnchor),
//            locationButton.heightAnchor.constraint(equalTo: blurEffectView.contentView.heightAnchor, multiplier: 0.5)
//        ])
//
//        // Adding the separator line
//        let separatorLine = UIView()
//        separatorLine.backgroundColor = .opaqueSeparator
//        separatorLine.translatesAutoresizingMaskIntoConstraints = false
//        blurEffectView.contentView.addSubview(separatorLine)
//
//        NSLayoutConstraint.activate([
//            separatorLine.leadingAnchor.constraint(equalTo: blurEffectView.contentView.leadingAnchor),
//            separatorLine.trailingAnchor.constraint(equalTo: blurEffectView.contentView.trailingAnchor),
//            separatorLine.centerYAnchor.constraint(equalTo: blurEffectView.contentView.centerYAnchor),
//            separatorLine.heightAnchor.constraint(equalToConstant: 1)
//        ])
//
//        return mapView
//    }
//
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        let newAnnotations = viewModel.festivals.compactMap { festival -> LandmarkAnnotation? in
//            guard let coordinates = festival.coordinates else { return nil }
//            let annotation = LandmarkAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude), title: festival.name)
//            return annotation
//        }
//        let currentAnnotations = uiView.annotations.compactMap { $0 as? LandmarkAnnotation }
//
//        let annotationsToAdd = newAnnotations.filter { newAnnotation in
//            !currentAnnotations.contains { $0.coordinate.latitude == newAnnotation.coordinate.latitude && $0.coordinate.longitude == newAnnotation.coordinate.longitude }
//        }
//
//        let annotationsToRemove = currentAnnotations.filter { currentAnnotation in
//            !newAnnotations.contains { $0.coordinate.latitude == currentAnnotation.coordinate.latitude && $0.coordinate.longitude == currentAnnotation.coordinate.longitude }
//        }
//
//        uiView.removeAnnotations(annotationsToRemove)
//        uiView.addAnnotations(annotationsToAdd)
//    }
//}
//
//struct MapView: View {
//    @StateObject private var locationManager = SimpleLocationManager()
//    @StateObject private var viewModel = MapViewModel()
//
//    var body: some View {
//        MapViewContainer(locationManager: locationManager, viewModel: viewModel)
//            .edgesIgnoringSafeArea(.all)
//            .sheet(isPresented: $viewModel.isFestivalViewVisible) {
//                if let selectedFestival = viewModel.selectedFestival {
//                    NavigationStack {
//                        FestivalView(viewModel: FestivalViewModel(festival: selectedFestival, listViewModel: FestivalListViewModel()))
//                    }
//                    .presentationDetents([.height(295), .large])
//                }
//            }
//            .safeAreaInset(edge: .bottom) {
//                Color.clear
//                    .frame(height: 0)
//                    .background(.ultraThinMaterial)
//            }
//            .safeAreaInset(edge: .top) {
//                Color.clear
//                    .frame(height: 0)
//                    .background(.ultraThinMaterial)
//            }
//    }
//}
//
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
