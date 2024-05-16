import Foundation
import SwiftUI

// MARK: - Festival View
struct FestivalView: View {
    @AppStorage("appColor") var appColor: AppColor = .default
    @State private var showingPopover = false
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
                                        .frame(maxHeight: .infinity)
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
                                        .frame(maxHeight: .infinity)
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
                                        .frame(maxHeight: .infinity)
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
                                        .frame(maxHeight: .infinity)
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
                    if !festival.festivalMapImageName.isEmpty {
                        NavigationLink(destination: ImageView(imageName: festival.festivalMapImageName)) {
                            Label("Festival Map", systemImage: "map.fill")
                        }
                    }
                    
                    if !festival.campgroundMapImageName.isEmpty {
                        NavigationLink(destination: ImageView(imageName: festival.campgroundMapImageName)) {
                            Label("Campground Map", systemImage: "map.circle.fill")
                        }
                    }
                    
                    if !festival.ticketsURL.isEmpty {
                        URLButtonInApp(label: "Tickets", systemImage: "ticket.fill", urlString: festival.ticketsURL)
                    }
                    
                    if !festival.lostAndFoundURL.isEmpty {
                        URLButtonInApp(label: "Lost & Found", systemImage: "questionmark.app.fill", urlString: festival.lostAndFoundURL)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack {
            // Active Indicator Button
            let startDate = convertStringToDate(dateString: festival.startDate)
            let endDate = convertStringToDate(dateString: festival.endDate)
            let currentDate = Date()
            let isCurrentDateWithinFestival = startDate != nil && endDate != nil && (startDate!...endDate!).contains(currentDate)

            Menu {
                Button(action: {}) {
                    Text("    \(festival.startDate) - \(festival.endDate)")
                }
            } label: {
                PulsingView()
                    .foregroundColor(isCurrentDateWithinFestival ? .green : .red)
                    .frame(width: 10, height: 10)
            }
        })
    }
}

// MARK: - Preview Provider
struct FestivalView_Previews: PreviewProvider {
    static var previews: some View {
        FestivalView(festival: texasRenaissanceFestival)
    }
}
