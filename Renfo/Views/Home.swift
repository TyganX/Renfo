import SwiftUI

struct HomeView: View {
    @State private var visibleStates: [String: Bool]
    @State private var editMode: EditMode = .inactive
    @State private var tempVisibleStates: [String: Bool]

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

    var groupedFestivals: [String: [FestivalInfo]] {
        Dictionary(grouping: festivals, by: { $0.state })
    }

    init() {
        let initialStates = Dictionary(grouping: festivals, by: { $0.state }).keys
        _visibleStates = State(initialValue: initialStates.reduce(into: [:]) { $0[$1] = true })
        _tempVisibleStates = State(initialValue: initialStates.reduce(into: [:]) { $0[$1] = true })
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedFestivals.keys.sorted().filter { editMode == .active || visibleStates[$0] ?? true }, id: \.self) { state in
                    Section(header: EditableSectionHeader(state: state, tempVisibleStates: $tempVisibleStates, editMode: $editMode)) {
                        ForEach(groupedFestivals[state] ?? [], id: \.name) { festival in
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
            .navigationTitle("Renfo")
            .environment(\.editMode, $editMode)
            .toolbar {
                EditButton(editMode: $editMode, visibleStates: $visibleStates, tempVisibleStates: $tempVisibleStates)
            }
        }
    }
}

struct EditableSectionHeader: View {
    let state: String
    @Binding var tempVisibleStates: [String: Bool]
    @Binding var editMode: EditMode

    var body: some View {
        HStack {
            if editMode == .active {
                Button(action: {
                    tempVisibleStates[state]?.toggle()
                }) {
                    Image(systemName: tempVisibleStates[state] ?? true ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(tempVisibleStates[state] ?? true ? nil : .gray)
                }
            }
            Text(state)
            Spacer()
        }
    }
}

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
//            Text(editMode == .active ? "Done" : "Edit")
            Image(systemName: editMode == .active ? "checkmark.circle" : "ellipsis.circle")
        }
    }
}

struct FestivalView: View {
    @AppStorage("appColor") var appColor: AppColor = .default // Retrieve the selected app color
    
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

// Preview provider
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
