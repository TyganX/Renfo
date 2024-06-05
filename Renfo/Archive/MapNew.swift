//////Button(action: { }) {}
//////.padding()
//////.frame(width: 44, height: 1)
//////.background(Color.gray)
////
//import SwiftUI
//import MapKit
//
//struct FestivalAnnotation: Identifiable {
//    let id = UUID()
//    let coordinate: CLLocationCoordinate2D
//    let title: String
//}
//
//class MapViewModel: ObservableObject {
//    @Published var festivals: [FestivalModel] = []
//    @Published var selectedFestival: FestivalModel? = nil
//    @Published var isFestivalViewVisible: Bool = false
//
//    var annotations: [FestivalAnnotation] {
//        festivals.compactMap { festival -> FestivalAnnotation? in
//            guard let coordinates = festival.coordinates else { return nil }
//            return FestivalAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude), title: festival.name)
//        }
//    }
//
//    func selectFestival(with coordinate: CLLocationCoordinate2D) {
//        if let festival = festivals.first(where: { $0.coordinates?.latitude == coordinate.latitude && $0.coordinates?.longitude == coordinate.longitude }) {
//            selectedFestival = festival
//            isFestivalViewVisible = true
//        }
//    }
//}
//
//struct MapView: View {
//    @StateObject private var locationManager = SimpleLocationManager()
//    @StateObject private var viewModel = MapViewModel()
//    @State private var isSatelliteView = false
//
//    var body: some View {
//        ZStack {
//            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: viewModel.annotations) { annotation in
//                Marker(coordinate: annotation.coordinate) {
//                    VStack {
//                        Image(systemName: "mappin.circle.fill")
//                            .resizable()
//                            .frame(width: 30, height: 30)
//                            .foregroundColor(.red)
//                        Text(annotation.title)
//                            .font(.caption)
//                            .fixedSize()
//                    }
//                    .onTapGesture {
//                        viewModel.selectFestival(with: annotation.coordinate)
//                    }
//                }
//            }
//            .mapStyle(isSatelliteView ? .hybrid(elevation: .realistic) : .standard)
//            .edgesIgnoringSafeArea(.all)
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
//            HStack {
//                Spacer()
//                VStack {
//                    VStack(spacing: 0) {
//                        // Toggle Map Type Button
//                        Button(action: {
//                            isSatelliteView.toggle()
//                        }) {
//                            Image(systemName: isSatelliteView ? "globe.americas.fill" : "map.fill")
//                                .padding()
//                                .frame(width: 44, height: 44)
//                        }
//                       
//                        Button(action: { }) {
//                        }
//                        .padding()
//                        .frame(width: 44, height: 1)
//                        .background(Color.gray)
//                        
//                        // Move to User Location Button
//                        Button(action: {
//                            locationManager.requestLocationAccess()
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                if let userLocation = locationManager.userLocation {
//                                    locationManager.region = MKCoordinateRegion(
//                                        center: userLocation,
//                                        span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
//                                    )
//                                }
//                            }
//                        }) {
//                            Image(systemName: "location.fill")
//                                .padding()
//                                .frame(width: 44, height: 44)
//                        }
//                    }
//                    .background(.ultraThinMaterial)
//                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
//                    
//                    Spacer()
//                }
//                .padding([.top, .trailing], 16)
//            }
//        }
//        .sheet(isPresented: $viewModel.isFestivalViewVisible) {
//            if let selectedFestival = viewModel.selectedFestival {
//                NavigationStack {
//                    FestivalView(viewModel: FestivalViewModel(festival: selectedFestival, listViewModel: FestivalListViewModel()))
//                }
//                .presentationDetents([.height(295), .large])
//            }
//        }
//    }
//}
//
//class SimpleLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let locationManager = CLLocationManager()
//    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0))
//    @Published var userLocation: CLLocationCoordinate2D?
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//    }
//
//    func requestLocationAccess() {
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.first {
//            userLocation = location.coordinate
//            region = MKCoordinateRegion(
//                center: location.coordinate,
//                span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
//            )
//            locationManager.stopUpdatingLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.startUpdatingLocation()
//        }
//    }
//}
//
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
