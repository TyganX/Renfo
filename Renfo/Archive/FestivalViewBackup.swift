import Foundation
import SwiftUI

// MARK: - Festival View
struct FestivalViewBackup: View {
    @AppStorage("appColor") var appColor: AppColor = .default
    @State private var showingPopover = false
    var festival: FestivalData
    
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
//                    .background(
//                                            VisualEffectBlur(style: .systemMaterial)
//                                                .edgesIgnoringSafeArea(.top)
//                                        )
                }
                
                let resourceLinks: [(key: String, value: (label: String, systemImage: String, view: () -> AnyView))] = [
                    
                    ("festivalMapImageName", ("Festival Map", "map.fill", {
                        if !festival.festivalMapImageName.isEmpty {
                            return AnyView(NavigationLink(destination: ImageView(imageName: festival.festivalMapImageName)) {
                                Label("Festival Map", systemImage: "map.fill")
                            })
                        } else {
                            return AnyView(EmptyView())
                        }
                    })),
                    ("campgroundMapImageName", ("Campground Map", "map.circle.fill", {
                        if !festival.campgroundMapImageName.isEmpty {
                            return AnyView(NavigationLink(destination: ImageView(imageName: festival.campgroundMapImageName)) {
                                Label("Campground Map", systemImage: "map.circle.fill")
                            })
                        } else {
                            return AnyView(EmptyView())
                        }
                    })),
                    ("ticketsURL", ("Tickets", "ticket.fill", {
                        if !festival.ticketsURL.isEmpty {
                            return AnyView(URLButtonInApp(label: "Tickets", systemImage: "ticket.fill", urlString: festival.ticketsURL))
                        } else {
                            return AnyView(EmptyView())
                        }
                    })),
                    ("lostAndFoundURL", ("Lost & Found", "questionmark.app.fill", {
                        if !festival.lostAndFoundURL.isEmpty {
                            return AnyView(URLButtonInApp(label: "Lost & Found", systemImage: "questionmark.app.fill", urlString: festival.lostAndFoundURL))
                        } else {
                            return AnyView(EmptyView())
                        }
                    })),
                ]

                let nonEmptyResourceLinks = resourceLinks.filter { _ in true }

                if !nonEmptyResourceLinks.isEmpty {
                    Section(header: Text("Resources")) {
                        ForEach(nonEmptyResourceLinks, id: \.key) { link in
                            link.value.view()
                        }
                    }
                }
                
                let socialLinks: [String: (label: String, systemImage: String, url: String)] = [
                    "facebook": ("Facebook", "facebook", festival.facebook),
                    "instagram": ("Instagram", "instagram", festival.instagram),
                    "x": ("𝕏", "x", festival.x),
                    "youTube": ("YouTube", "youtube.fill", festival.youTube),
                ]

                let nonEmptySocialLinks = socialLinks.filter { !$1.url.isEmpty }

                if !nonEmptySocialLinks.isEmpty {
                    Section(header: Text("Social")) {
                        ForEach(nonEmptySocialLinks.keys.sorted(), id: \.self) { key in
                            let link = nonEmptySocialLinks[key]!
                            URLButtonCustom(label: link.label, image: Image(link.systemImage), urlString: "https://www.\(key).com/\(link.url)")
                        }
                    }
                }
            }
        }
        .navigationTitle(festival.established.isEmpty ? "" : "Est. \(festival.established)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack {
            // Active Indicator Button
            let startDate = convertStringToDate(dateString: festival.startDate)
            let endDate = convertStringToDate(dateString: festival.endDate)
            let currentDate = Date()
            let isCurrentDateWithinFestival = startDate != nil && endDate != nil && (startDate!...endDate!).contains(currentDate)

            Menu {
                Button(action: {}) {
                    Label("\(festival.startDate)-\(festival.endDate)", systemImage: "calendar.badge.checkmark")
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
struct FestivalViewBackup_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FestivalViewBackup(festival: texasRenaissanceFestival)
        }
    }
}
