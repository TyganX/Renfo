import Foundation
import SwiftUI

// MARK: - Home View
struct HomeView: View {
    // MARK: - State Properties
    @State private var visibleStates: [String: Bool] {
        didSet {
            // Save the visibleStates to UserDefaults whenever it changes
            if let encoded = try? JSONEncoder().encode(visibleStates) {
                UserDefaults.standard.set(encoded, forKey: "visibleStates")
            }
        }
    }
    @State private var editMode: EditMode = .inactive
    @State private var tempVisibleStates: [String: Bool]
    @State private var searchText = "" // Added for search functionality
    @Environment(\.scenePhase) private var scenePhase

    // MARK: - Festival Data
    let festivals: [FestivalInfo] = [
               louisianaRenaissanceFestival,
               marylandRenaissanceFestival,
               northernCaliforniaRenaissanceFaire,
               renaissancePleasureFaire,
               scarboroughRenaissanceFestival,
               sherwoodForestFaire,
               texasRenaissanceFestival,
               // Add more festivals as needed
           ]

    // MARK: - Grouped Festivals by State
    var groupedFestivals: [String: [FestivalInfo]] {
        Dictionary(grouping: festivals, by: { $0.state })
    }

    init() {
            // Load the visibleStates from UserDefaults or default to all true
            if let savedStates = UserDefaults.standard.data(forKey: "visibleStates"),
               let decodedStates = try? JSONDecoder().decode([String: Bool].self, from: savedStates) {
                _visibleStates = State(initialValue: decodedStates)
            } else {
                let initialStates = Dictionary(grouping: festivals, by: { $0.state }).keys
                _visibleStates = State(initialValue: initialStates.reduce(into: [:]) { $0[$1] = true })
            }
            _tempVisibleStates = State(initialValue: _visibleStates.wrappedValue)
        }

    // MARK: - View Body
    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedFestivals.keys.sorted(), id: \.self) { state in
                    if (editMode == .active || visibleStates[state] ?? true) && (searchText.isEmpty || (groupedFestivals[state]?.contains(where: { $0.name.localizedCaseInsensitiveContains(searchText) }) ?? false)) {
                        Section(header: EditableSectionHeader(state: state, tempVisibleStates: $tempVisibleStates, editMode: $editMode)) {
                            ForEach(groupedFestivals[state]?.filter { searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) } ?? [], id: \.name) { festival in
                                NavigationLink(destination: FestivalView(festival: festival)) {
                                    HStack {
                                        Image(festival.logoImageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                        Text(festival.name)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search") // Search bar added here
            .navigationTitle("Renfo")
            .environment(\.editMode, $editMode)
            .toolbar {
                EditButton(editMode: $editMode, visibleStates: $visibleStates, tempVisibleStates: $tempVisibleStates)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            // Save the visibleStates when the app goes to the background
            saveVisibleStates()
        }
    }

    func saveVisibleStates() {
        if let encoded = try? JSONEncoder().encode(visibleStates) {
            UserDefaults.standard.set(encoded, forKey: "visibleStates")
        }
    }
}

// MARK: - Editable Section Header
struct EditableSectionHeader: View {
    let state: String
    @Binding var tempVisibleStates: [String: Bool]
    @Binding var editMode: EditMode

    var body: some View {
        Button(action: {
            // Only toggle the state if in edit mode
            if editMode == .active {
                tempVisibleStates[state]?.toggle()
            }
        }) {
            HStack {
                if editMode == .active {
                    Image(systemName: tempVisibleStates[state] ?? true ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(tempVisibleStates[state] ?? true ? nil : .gray)
                }
                Text(state)
                    .font(.footnote)
                    .fontWeight(.bold)
//                    .fontDesign(.rounded)
                    .foregroundColor(.primary)
                Spacer()
            }
        }
        .disabled(editMode == .inactive) // Disable the button when not in edit mode
    }
}

// MARK: - Edit Button
struct EditButton: View {
    @Binding var editMode: EditMode
    @Binding var visibleStates: [String: Bool]
    @Binding var tempVisibleStates: [String: Bool]

    var body: some View {
        Button(action: {
            withAnimation {
                if editMode == .active {
                    // Save the temporary states to the actual visible states when exiting edit mode
                    visibleStates = tempVisibleStates
                } else {
                    // Copy the visible states to the temporary states when entering edit mode
                    tempVisibleStates = visibleStates
                }
                editMode = editMode == .active ? .inactive : .active
            }
        }) {
            Image(systemName: editMode == .active ? "checkmark.circle" : "ellipsis.circle")
        }
    }
}

// MARK: - Festival View
struct FestivalView: View {
    @AppStorage("appColor") var appColor: AppColor = .default
    var festival: FestivalInfo
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .center, spacing: 20) {
                        Image(festival.logoImageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                        
                        Text(festival.name)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        HStack {
                            Button(action: {
                                // Action to call the festival's phone number
                                let telephone = "tel://"
                                let formattedNumber = festival.phoneNumber.replacingOccurrences(of: "-", with: "")
                                if let url = URL(string: "\(telephone)\(formattedNumber)") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                VStack {
                                    Image(systemName: "phone.fill")
                                    Text("call")
                                        .font(.caption)
                                }
                                .frame(width: 54, height: 44)
                            }
                            .buttonStyle(.bordered)
                            
                            Spacer() // Add a spacer between buttons

                            Button(action: {
                                // Action to send an email to the festival's email address
                                let email = "mailto:\(festival.email)"
                                if let url = URL(string: email) {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                VStack {
                                    Image(systemName: "envelope.fill")
                                    Text("mail")
                                        .font(.caption)
                                }
                                .frame(width: 54, height: 44)
                            }
                            .buttonStyle(.bordered)
                            
                            Spacer() // Add a spacer between buttons

                            Button(action: {
                                // Action to open the festival's map link
                                if let url = URL(string: festival.mapLink) {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                VStack {
                                    Image(systemName: "location.fill")
                                    Text("maps")
                                        .font(.caption)
                                }
                                .frame(width: 54, height: 44)
                            }
                            .buttonStyle(.bordered)
                            
                            Spacer() // Add a spacer between buttons
                            
                            Button(action: {
                                // Action to open the festival's website
                                if let url = URL(string: festival.websiteURL) {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                VStack {
                                    Image(systemName: "globe")
                                    Text("website")
                                        .font(.caption)
                                }
                                .frame(width: 54, height: 44)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
                
                Section(header: Text("Resources")) {
                    NavigationLink(destination: ImageView(imageName: festival.festivalMapImageName)) {
                        Label("Festival Map", systemImage: "map.fill")
                    }
                    
                    NavigationLink(destination: ImageView(imageName: festival.campgroundMapImageName)) {
                        Label("Campground Map", systemImage: "map.circle.fill")
                    }
                    
                    URLButtonInApp(label: "Tickets", systemImage: "ticket.fill", urlString: festival.ticketsURL)
                    
                    URLButtonInApp(label: "Lost & Found", systemImage: "questionmark.app.fill", urlString: festival.lostAndFoundURL)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack {
            ForEach(festival.activeMonths, id: \.self) { month in
                Button(action: {
                    // This space intentionally left blank to disable the button action.
                }) {
                    VStack {
                        Text(month)
                            .font(.caption)
//                            .fontWeight(.bold)
//                            .foregroundColor(appColor.color)
                    }
                }
                .buttonStyle(.bordered)
//                .disabled(true) // This disables the button
//                .foregroundColor(appColor.color)
            }
        })
    }
}

// MARK: - Preview Provider
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
