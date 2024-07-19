//import SwiftUI
//import MapKit
//
//// MARK: - Map View
//@available(iOS 18.0, *)
//struct MapView: View {
//    @StateObject private var firestoreService = FirestoreService() // Manages data fetching from Firestore
//    @StateObject private var locationManager = LocationManager() // Manages user location updates
//    @State private var position = MapCameraPosition.automatic // Using automatic position to let the map decide the best view
//    @State private var isHybridStyle = false // State to toggle between map styles (standard and hybrid)
//    @State private var selectedFestival: FestivalModel? // State for selected marker
//    @State private var isSheetPresented: Bool = true // State to present sheet
//    @State private var searchText = ""
//    @Binding var show: Bool
//
//    // MARK: - View Body
//    var body: some View {
//        map
//        .safeAreaInset(edge: .top) {
//            Color.clear
//                .frame(height: 0)
//                .background(.ultraThinMaterial)
////                .blur(radius: 15)
//        }
//        .sheet(isPresented: $isSheetPresented) {
////            if let festival = selectedFestival {
////                SheetView(festival: festival) // Pass the selected festival to the sheet
////            }
//            searchSheet
//        }
//        .onChange(of: selectedFestival) {
//            isSheetPresented = selectedFestival != nil // Present the sheet when a marker is selected
//        }
//        .overlay(alignment: .topLeading) {
//            listButton
//        }
//        .overlay(alignment: .topTrailing) {
//            buttons
//        }
//    }
//
//    // MARK: - Map Components
//    private var map: some View {
//        Map(position: $position, selection: $selectedFestival) {
//            ForEach(firestoreService.festivals) { festival in
//                if let coordinates = festival.coordinates {
//                    Marker(festival.name, systemImage: "crown.fill", coordinate: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude))
//                        .tag(festival)
//                        .tint(isFestivalActive(festival) ? .green : .red)
//                }
//            }
//            UserAnnotation()
//            .mapItemDetailSelectionAccessory(.callout)
//        }
//        .mapFeatureSelectionAccessory(.callout)
//        .safeAreaInset(edge: .top) {
//            Color.clear
//                .frame(height: 160)
//        }
//        .mapStyle(isHybridStyle ? .hybrid(elevation: .realistic) : .standard) // Toggle between hybrid and standard map styles
//        .ignoresSafeArea(edges: .all) // Extend the map to the edges of the screen
//        .onAppear {
//            firestoreService.fetchAllFestivals { festivals in
//                firestoreService.festivals = festivals // Fetch festivals and update the list
//            }
//        }
//        .mapControls {
//            MapCompass()
//            MapPitchToggle()
//        }
//    }
//
//    // MARK: - Search Sheet
//    private var searchSheet: some View {
//        VStack(spacing: 0) {
//            HStack {
//                Image(systemName: "magnifyingglass")
//                    .foregroundColor(.secondary)
//                TextField("Search Festivals", text: $searchText)
//                    .foregroundColor(.primary)
//                    .autocorrectionDisabled()
//            }
//            .padding(8)
//            .background(Color.gray.opacity(0.1))
//            .cornerRadius(8)
//            .padding(.horizontal)
//
//
//            ScrollView {
//                VStack(spacing: 25) {
//                    ForEach(firestoreService.festivals) { festival in
//                        HStack(spacing: 12) {
//                            Text(festival.name)
//                                .fontWeight(.semibold)
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                }
//                .padding()
//            }
//        }
//        .padding(.top)
//        .interactiveDismissDisabled()
//        .presentationDetents([.height(86), .medium, .fraction(0.99)])
//        .presentationBackground(.regularMaterial)
//        .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.99)))
//    }
//
//
//    // MARK: - Festival List Button
//    private var listButton: some View {
//        Button(action: {
//            show.toggle()
//        }) {
//            Image(systemName: "list.bullet")
//        }
//        .frame(width: 44, height: 44)
//        .foregroundColor(.blue)
//        .background(.ultraThinMaterial) // Background with ultra thin material effect
//        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous)) // Rounded rectangle with continuous style for smooth corners
//        .padding(.top, 15) // Padding to position the button group
//        .padding(.leading, 5) // Padding to position the button group
//    }
//
//    // MARK: - Map Style & Location Buttons
//    private var buttons: some View {
//        VStack(spacing: 0) {
//            Button(action: {
//                isHybridStyle.toggle() // Toggle map style
//            }) {
//                Image(systemName: isHybridStyle ? "globe.americas.fill" : "map.fill")
//                    .frame(width: 44, height: 44)
//            }
//
//            Divider()
//
//            Button(action: {
//                centerOnUserLocation() // Center on user's location
//            }) {
//                Image(systemName: "location.fill")
//                    .frame(width: 44, height: 44)
//            }
//        }
//        .frame(width: 44)
//        .foregroundColor(.blue)
//        .background(.ultraThinMaterial) // Background with ultra thin material effect
//        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous)) // Rounded rectangle with continuous style for smooth corners
//        .padding(.top, 15) // Padding to position the button group
//        .padding(.trailing, 5) // Padding to position the button group
//    }
//
//    // MARK: - Center on User Location
//    private func centerOnUserLocation() {
//        if let userLocation = locationManager.userLocation {
//            withAnimation {
//                position = .region(MKCoordinateRegion(
//                    center: userLocation,
//                    span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
//                ))
//            }
//        }
//    }
//}
//
//// MARK: - Sheet View
////@available(iOS 18.0, *)
//struct SheetView: View {
//    var festival: FestivalModel // Take the festival as an input
//
//    var body: some View {
//        NavigationStack {
//            FestivalView(viewModel: FestivalViewModel(festival: festival))
//        }
////        .presentationDetents([.height(295), .large])
//        .presentationDetents([.height(375), .fraction(0.99)])
//        .presentationBackground(.regularMaterial)
//        .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.99)))
////        .presentationBackgroundInteraction(.enabled(upThrough: .large))
//    }
//}
//
//// MARK: - Preview Provider
////@available(iOS 18.0, *)
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            MapView(show: .constant(false))
//        }
//    }
//}
