import SwiftUI
import MapKit

// MARK: - Map View
struct MapView: View {
    @StateObject private var firestoreService = FirestoreService() // Manages data fetching from Firestore
    @StateObject private var locationManager = LocationManager() // Manages user location updates
    @State private var position = MapCameraPosition.automatic // Using automatic position to let the map decide the best view
    @State private var isHybridStyle = false // State to toggle between map styles (standard and hybrid)
    @State private var selectedFestival: FestivalModel? // State for selected marker
    @State private var isSheetPresented: Bool = false // State to present sheet

    // MARK: - View Body
    var body: some View {
        ZStack {
            map
        }
        .safeAreaInset(edge: .top) {
            Color.clear
                .frame(height: 0)
                .background(.ultraThinMaterial)
        }
        .sheet(isPresented: $isSheetPresented) {
            if let festival = selectedFestival {
                SheetView(festival: festival) // Pass the selected festival to the sheet
            }
        }
        .onChange(of: selectedFestival) {
            isSheetPresented = selectedFestival != nil // Present the sheet when a marker is selected
        }
        .overlay(alignment: .topTrailing) {
            buttons
        }
    }
    
    // MARK: - Map Components
    private var map: some View {
        Map(position: $position, selection: $selectedFestival) {
            ForEach(firestoreService.festivals) { festival in
                if let coordinates = festival.coordinates {
                    Marker(festival.name, coordinate: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude))
                        .tag(festival)
                }
            }
            UserAnnotation()
        }
        .safeAreaInset(edge: .top) {
            Color.clear
                .frame(height: 150)
        }
        .mapStyle(isHybridStyle ? .hybrid(elevation: .realistic) : .standard) // Toggle between hybrid and standard map styles
        .ignoresSafeArea(edges: .all) // Extend the map to the edges of the screen
        .onAppear {
            firestoreService.fetchAllFestivals { festivals in
                firestoreService.festivals = festivals // Fetch festivals and update the list
            }
        }
        .mapControls {
            MapCompass()
            MapPitchToggle()
        }
    }

    // MARK: - Map Style & Location Buttons
    private var buttons: some View {
        VStack(spacing: 0) {
            Button(action: {
                isHybridStyle.toggle() // Toggle map style
            }) {
                Image(systemName: isHybridStyle ? "globe.americas.fill" : "map.fill")
                    .frame(width: 44, height: 44)
            }
            
            Divider()
            
            Button(action: {
                centerOnUserLocation() // Center on user's location
            }) {
                Image(systemName: "location.fill")
                    .frame(width: 44, height: 44)
            }
        }
        .frame(width: 44)
        .foregroundColor(.blue)
        .background(.ultraThinMaterial) // Background with ultra thin material effect
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous)) // Rounded rectangle with continuous style for smooth corners
        .padding([.top, .trailing], 5) // Padding to position the button group
    }
    
    // MARK: - Center on User Location
    private func centerOnUserLocation() {
        if let userLocation = locationManager.userLocation {
            withAnimation {
                position = .region(MKCoordinateRegion(
                    center: userLocation,
                    span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)
                ))
            }
        }
    }
}

// MARK: - Sheet View
struct SheetView: View {
    var festival: FestivalModel // Take the festival as an input
    
    var body: some View {
        NavigationStack {
            FestivalView(viewModel: FestivalViewModel(festival: festival, listViewModel: FestivalListViewModel()))
        }
        .presentationDetents([.height(295), .large])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }
}

// MARK: - Preview Provider
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
