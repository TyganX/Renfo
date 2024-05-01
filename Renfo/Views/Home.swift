import SwiftUI

struct HomeView: View {
    // State variable to track sorting criterion
    @State private var sortingCriterion: SortingCriterion = .name
    // State dictionary to track collapsed sections
    @State private var collapsedSections: [String: Bool] = [:]

    // Enum for sorting criteria
    enum SortingCriterion: String, CaseIterable {
        case name = "Ascending"
        case nameDescending = "Descending"
        case comingSoon = "Coming Soon"
        case closest = "Closest"
    }

    // Array of festivals
    let festivals: [FestivalInfo] = [
        louisianaRenaissanceFestival,
        marylandRenaissanceFestival,
        renaissancePleasureFaire,
        scarboroughRenaissanceFestival,
        sherwoodForestFaire,
        texasRenaissanceFestival,
        // Add more festivals as needed
    ]
    
    // Group festivals by state without sorting them
    var groupedFestivals: [String: [FestivalInfo]] {
        Dictionary(grouping: festivals, by: { $0.state })
    }

    // Sorted states based on the current sorting criterion
    var sortedStates: [String] {
        switch sortingCriterion {
        case .name:
            return groupedFestivals.keys.sorted()
        case .nameDescending:
            return groupedFestivals.keys.sorted().reversed()
        case .comingSoon:
            // Sort logic for states with the soonest upcoming festivals
            return groupedFestivals.keys.sorted() // Replace with actual sorting logic
        case .closest:
            // Sort logic for states closest to the user's location
            return groupedFestivals.keys.sorted() // Replace with actual sorting logic
        }
    }

    var body: some View {
        NavigationView {
            List {
                // Create a section for each sorted state
                ForEach(sortedStates, id: \.self) { state in
                    Section(header:
                        HStack {
                            Text(state)
                            Spacer()
                        Button(action: {
                            withAnimation(.easeInOut) {
                                self.collapsedSections[state] = !(self.collapsedSections[state] ?? false)
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .rotationEffect(.degrees(self.collapsedSections[state] ?? false ? 0 : 90))
                        }
                    }
                    ) {
                        // Only show the content if the section is not collapsed
                        if !(self.collapsedSections[state] ?? false) {
                            ForEach(groupedFestivals[state] ?? [], id: \.name) { festival in
                                NavigationLink(destination: FestivalView(festival: festival)) {
                                    HStack {
                                        Image(festival.logoImageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                        Text(festival.name)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Renfo")
            .toolbar {
                // Sort button with dropdown menu and title
                Menu {
                    Text("Sort")
                    ForEach(SortingCriterion.allCases, id: \.self) { criterion in
                        Button(action: {
                            self.sortingCriterion = criterion
                        }) {
                            HStack {
                                // Checkmark to the left of the selected item
                                if sortingCriterion == criterion {
                                    Image(systemName: "checkmark")
                                }
                                Text(criterion.rawValue)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "arrow.up.arrow.down.circle")
                }
            }
        }
    }
}

struct FestivalView: View {
    var festival: FestivalInfo
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image(festival.logoImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding(.top)
            
                HStack {
                    Text("Active:")
                        .font(.headline)
                    ForEach(festival.activeMonths, id: \.self) { month in
                        Text(month)
                            .padding(5)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
            
            HStack {
                Spacer() // Add a spacer on the left side

                Button(action: {
                    // Action to call the festival's phone number
                    let telephone = "tel://"
                    let formattedNumber = festival.phoneNumber.replacingOccurrences(of: "-", with: "")
                    if let url = URL(string: "\(telephone)\(formattedNumber)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "phone.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 24)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity) // Make the button expand

                Spacer() // Add a spacer between buttons

                Button(action: {
                    // Action to send an email to the festival's email address
                    let email = "mailto:\(festival.email)"
                    if let url = URL(string: email) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "envelope.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 24)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity) // Make the button expand

                Spacer() // Add a spacer between buttons

                Button(action: {
                    // Action to open the festival's map link
                    if let url = URL(string: festival.mapLink) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "location.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 24)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity) // Make the button expand
                
                Spacer() // Add a spacer between buttons
                
                Button(action: {
                    // Action to open the festival's website
                    if let url = URL(string: festival.websiteURL) {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Image(systemName: "globe")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 24)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity) // Make the button expand
                
                Spacer() // Add a spacer on the right side
            }
            
            List {
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
        .navigationBarTitle(Text(festival.name), displayMode: .inline)
    }
}

// Preview provider for Home view
#Preview {
    HomeView()
}
