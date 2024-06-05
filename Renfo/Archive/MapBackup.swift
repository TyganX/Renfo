//import SwiftUI
//import MapKit
//
//// MARK: - Map View
//struct MapView: View {
//    @StateObject private var firestoreService = FirestoreService() // Manages data fetching from Firestore
//    @StateObject private var locationManager = LocationManager() // Manages user location updates
//    @State private var position = MapCameraPosition.automatic // Using automatic position to let the map decide the best view
//    @State private var isHybridStyle = false // State to toggle between map styles (standard and hybrid)
//    @Namespace var mapScope
//
//    // MARK: - View Body
//    var body: some View {
//        ZStack {
//            map // Map view with festival markers
//        }
//        .mapScope(mapScope)
//        .safeAreaInset(edge: .bottom) {
//            Color.clear
//                .frame(height: 0)
//                .background(.ultraThinMaterial)
//        }
//        .safeAreaInset(edge: .top) {
//            Color.clear
//                .frame(height: 0)
//                .background(.ultraThinMaterial)
//        }
//        .mapControls {
//            MapScaleView()
//            MapCompass()
//            MapPitchToggle()
//            MapUserLocationButton()
//        }
//        .overlay(alignment: .topTrailing) {
//            VStack {
//                Button(action: {
//                    isHybridStyle.toggle() // Toggle map style
//                }) {
//                    Image(systemName: isHybridStyle ? "globe.americas.fill" : "map.fill")
//                        .padding()
//                        .frame(width: 44, height: 44)
//                }
//                .background(.ultraThickMaterial)
//                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
//            }
//            .padding([.top, .trailing], 5)
//        }
//    }
//    
//    // MARK: - Map Components
//    private var map: some View {
//        Map(position: $position, scope: mapScope) {
//            ForEach(firestoreService.festivals) { festival in
//                if let coordinates = festival.coordinates {
//                    Marker(festival.name, coordinate: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude))
//                }
//            }
//        }
//        .onAppear {
//            firestoreService.fetchAllFestivals { festivals in
//                firestoreService.festivals = festivals // Fetch festivals and update the list
//            }
//        }
//        .mapStyle(isHybridStyle ? .hybrid : .standard) // Toggle between hybrid and standard map styles
//        
//        .safeAreaInset(edge: .top) {
//            Color.clear
//                .frame(height: 38)
//        }
//    }
//}
//
//// MARK: - Preview Provider
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
