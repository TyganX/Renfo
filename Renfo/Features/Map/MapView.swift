import SwiftUI
import MapKit

// MARK: - Map View
struct MapView: View {
    @StateObject private var firestoreService = FirestoreService()
    @StateObject private var locationManager = LocationManager()
    @State private var position = MapCameraPosition.automatic
    @State private var isHybridStyle = false
    @State private var selectedFestival: FestivalModel?
    @State private var logoImage: UIImage? = nil
    @State private var isSheetPresented: Bool = false
    @State private var showFestivalPreview = false
    @State private var showSearchBar = true
    @State private var showSearchList: Bool = false
    @State private var searchText = ""
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    @EnvironmentObject var festivalListViewModel: FestivalListViewModel

    // MARK: - View Body
    var body: some View {
        map
        .safeAreaInset(edge: .top) {
            Color.clear
                .frame(height: 0)
                .background(.ultraThinMaterial)
        }
        .sheet(isPresented: $isSheetPresented) {
            if let festival = selectedFestival {
                NavigationStack {
                    FestivalView(viewModel: FestivalViewModel(festival: festival)) // Pass the selected festival to the sheet
                }
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.99)])
            }
        }
        .onChange(of: selectedFestival) { oldFestival, newFestival in
            withAnimation {
                showSearchBar = newFestival == nil
                showFestivalPreview = newFestival != nil // Present the sheet when a marker is selected
            }
            if let festival = newFestival {
                loadImage(for: festival)
            }
            
            if newFestival == nil {
                withAnimation {
                    position = MapCameraPosition.automatic
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            buttons
        }
        .overlay(
            Group {
                if let festival = selectedFestival, showFestivalPreview {
                    festivalPreview(festival: festival, showFestivalPreview: $showFestivalPreview)
                        .transition(.move(edge: .bottom))
                        .animation(.spring(), value: showFestivalPreview)
                }
                
                if showSearchBar {
                    searchSheet
                }
            }
        )
    }
    
    // MARK: - Map Components
    private var map: some View {
        Map(position: $position, selection: $selectedFestival) {
            ForEach(firestoreService.festivals) { festival in
                if let coordinates = festival.coordinates {
                    Marker(festival.name, systemImage: "crown.fill", coordinate: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude))
                        .tag(festival)
                        .tint(isFestivalActive(festival) ? .green : .red)
                }
            }
            UserAnnotation()
                .mapItemDetailSelectionAccessory(.callout)
        }
        .safeAreaInset(edge: .top) {
            Color.clear
                .frame(height: 160)
        }
        .mapFeatureSelectionAccessory(.callout)
        .mapStyle(isHybridStyle ? .hybrid(elevation: .realistic) : .standard)
        .ignoresSafeArea(edges: .all)
        .onAppear {
            firestoreService.fetchAllFestivals { festivals in
                firestoreService.festivals = festivals
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
                isHybridStyle.toggle()
            }) {
                Image(systemName: isHybridStyle ? "globe.americas.fill" : "map.fill")
                    .frame(width: 44, height: 44)
            }

            Divider()

            Button(action: {
                centerOnUserLocation()
            }) {
                Image(systemName: "location.fill")
                    .frame(width: 44, height: 44)
            }
        }
        .frame(width: 44)
        .foregroundColor(.blue)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.top, 15)
        .padding(.trailing, 5)
    }
    
    // MARK: - Search Sheet
    private var searchSheet: some View {
        VStack {
            Spacer()
            VStack {
                searchBar
                
                if showSearchList {
                    searchList
                }
            }
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.ultraThinMaterial, lineWidth: 1)
            )
            .padding()
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search", text: $searchText, onEditingChanged: { (editingChanged) in
                if editingChanged {
//                    print("TextField focused")
//                    withAnimation {
                        showSearchList = true
//                    }
                } else {
//                    print("TextField focus removed")
                }
            })
            .focused($isFocused)
            .foregroundColor(.primary)
            .autocorrectionDisabled()
            
            if searchText != "" {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
            
            if showSearchList {
                Button(action: {
                    withAnimation {
                        isFocused = false
                        showSearchList = false
                        searchText = ""
                    }
                }) {
                    Text("Cancel")
                }
            }
        }
        .padding(10)
//        .overlay(
//            RoundedRectangle(cornerRadius: 10, style: .continuous)
//                .stroke(.ultraThinMaterial, lineWidth: 2)
//        )
    }
    
    private var searchList: some View {
        List {
            ForEach(firestoreService.festivals.filter { $0.name.contains(searchText) || searchText.isEmpty }.sorted(by: { $0.name < $1.name })) { festival in
                FestivalRow(festival: festival)
                    .onTapGesture {
                        withAnimation {
                            isFocused = false
                            showSearchList = false
                        }
                        selectFestival(festival)
                    }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(PlainListStyle())
    }
    
    // MARK: - Festival Preview Sheet
    private func festivalPreview(festival: FestivalModel, showFestivalPreview: Binding<Bool>) -> some View {
        VStack {
            Spacer()
            VStack {
                Image(uiImage: logoImage ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .frame(height: 150)
                    .clipShape(Circle())
                    .redacted(reason: logoImage == nil ? .placeholder : [])
                
                Text(festival.name)
                    .foregroundColor(.white)
                    .fontDesign(.rounded)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .minimumScaleFactor(0.5)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.ultraThinMaterial, lineWidth: 1)
            )
            .overlay(alignment: .topTrailing) {
                // Close Button
                ColoredButton(systemImage: "xmark", tint: .secondary) {
                    withAnimation {
                        selectedFestival = nil
                    }
                }
                .padding(10)
            }
            .overlay(alignment: .topLeading) {
                // Learn More Button
                ColoredButton(systemImage: "info", tint: .blue) {
                    withAnimation {
                        isSheetPresented = true
                    }
                }
                .padding(10)
            }
        }
        .padding()
    }

    // MARK: - Load Festival Image
    private func loadImage(for festival: FestivalModel) {
        firestoreService.downloadImage(imageName: festival.logoImage) { image in
            logoImage = image
        }
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
    
    // MARK: - Center on Selected Festival
    private func selectFestival(_ festival: FestivalModel) {
        selectedFestival = festival
        if let coordinates = festival.coordinates {
            withAnimation {
                position = .region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ))
            }
        }
    }
}

// MARK: - Preview Provider
#Preview {
    NavigationStack {
        MapView()
            .environmentObject(FestivalListViewModel())
    }
}
