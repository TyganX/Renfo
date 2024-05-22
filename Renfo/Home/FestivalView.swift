import Foundation
import SwiftUI

// MARK: - Festival View
struct FestivalView: View {
    @AppStorage("appColor") var appColor: AppColor = .default
    @State private var showingPopover = false
    var festival: FestivalModel

    var body: some View {
        VStack {
            headerSection
                .padding(.horizontal)
            Form {
                if !detailsLinks.isEmpty {
                    Section(header: Text("Details")) {
                        ForEach(detailsLinks, id: \.key) { link in
                            Label {
                                Text(link.value.text)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: link.value.systemImage)
                                    .foregroundColor(nil)
                            }
                        }
                    }
                }

                if !resourceLinks.isEmpty {
                    Section(header: Text("Resources")) {
                        ForEach(resourceLinks, id: \.key) { link in
                            link.value.view()
                        }
                    }
                }

                if !socialLinks.isEmpty {
                    Section(header: Text("Social")) {
                        ForEach(socialLinks.keys.sorted(), id: \.self) { key in
                            let link = socialLinks[key]!
                            URLButtonCustom(label: link.label, image: Image(link.systemImage), urlString: "https://www.\(key).com/\(link.url)")
                        }
                    }
                }
            }
            .navigationTitle(festival.id?.isEmpty == false ? "\(festival.id!)" : "")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: activeIndicator)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(festival.established.isEmpty ? "" : "Est. \(festival.established)")
                }
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        Section {
            ZStack {
                ParticleView()
                VStack(alignment: .center, spacing: 0) {
                    if !festival.logoImage.isEmpty {
                        Image(festival.logoImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    
                    Text(festival.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 9)
                    
                    headerButtons
                }
            }
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .listRowInsets(EdgeInsets())
        }
    }


    // MARK: - Header Buttons
    private var headerButtons: some View {
        HStack {
            callButton
            mailButton
            directionsButton
            websiteButton
        }
    }

    // MARK: - Call Button
    private var callButton: some View {
        Button(action: {
            let phoneNumber = festival.contactPhone
            let telephone = "tel://"
            let formattedNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
            if let url = URL(string: "\(telephone)\(formattedNumber)") {
                UIApplication.shared.open(url)
            }
        }) {
            VStack {
                Image(systemName: "phone.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical, 2)
                Text("Call")
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .foregroundColor(.primary)
        }
        .buttonStyle(.bordered)
    }

    // MARK: - Mail Button
    private var mailButton: some View {
        Button(action: {
            let email = festival.contactEmail
            let mailto = "mailto:\(email)"
            if let url = URL(string: mailto) {
                UIApplication.shared.open(url)
            }
        }) {
            VStack {
                Image(systemName: "envelope.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical, 3)
                Text("Mail")
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .foregroundColor(.primary)
        }
        .buttonStyle(.bordered)
    }

    // MARK: - Directions Button
    private var directionsButton: some View {
        Button(action: {
            let mapLink = festival.locationMapLink
            if let url = URL(string: mapLink) {
                UIApplication.shared.open(url)
            }
        }) {
            VStack {
                Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical, 1)
                Text("Directions")
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .foregroundColor(.primary)
        }
        .buttonStyle(.bordered)
    }

    // MARK: - Website Button
    private var websiteButton: some View {
        Button(action: {
            let website = festival.website
            if let url = URL(string: website) {
                UIApplication.shared.open(url)
            }
        }) {
            VStack {
                Image(systemName: "safari.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical, 1)
                Text("Website")
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .foregroundColor(.primary)
        }
        .buttonStyle(.bordered)
    }

    // MARK: - Details Section
    private var detailsLinks: [(key: String, value: (systemImage: String, text: String))] {
        let formattedStartDate = convertStringToDate(dateString: festival.dateStart)?.formattedDateString() ?? festival.dateStart
        let formattedEndDate = convertStringToDate(dateString: festival.dateEnd)?.formattedDateString() ?? festival.dateEnd
        let formattedStartTime = convertTimeString(timeString: festival.timeStart) ?? festival.timeStart
        let formattedEndTime = convertTimeString(timeString: festival.timeEnd) ?? festival.timeEnd

        let links: [(key: String, value: (systemImage: String, text: String))] = [
            ("dates", ("calendar", "\(formattedStartDate) - \(formattedEndDate)")),
            ("hours", ("clock", "\(formattedStartTime) - \(formattedEndTime)"))
        ]
        return links.filter { !$0.value.text.isEmpty }
    }

    // MARK: - Resources Section
    private var resourceLinks: [(key: String, value: (label: String, systemImage: String, view: () -> AnyView))] {
        let links: [(key: String, value: (label: String, systemImage: String, view: () -> AnyView))] = [
            ("vendors", ("Vendors", "cart", {
                AnyView(NavigationLink(destination: VendorListView(festivalID: festival.id ?? "")) {
                    Label("Vendors", systemImage: "cart")
                })
            })),
            ("festivalMapImage", ("Festival Map", "map.fill", {
                if !festival.festivalMapImage.isEmpty {
                    return AnyView(NavigationLink(destination: ImageView(imageName: festival.festivalMapImage)) {
                        Label("Festival Map", systemImage: "map")
                    })
                } else {
                    return AnyView(EmptyView())
                }
            })),
            ("campgroundMapImage", ("Campground Map", "map.circle.fill", {
                if !festival.campgroundMapImage.isEmpty {
                    return AnyView(NavigationLink(destination: ImageView(imageName: festival.campgroundMapImage)) {
                        Label("Campground Map", systemImage: "map.circle")
                    })
                } else {
                    return AnyView(EmptyView())
                }
            })),
            ("tickets", ("Tickets", "ticket.fill", {
                if !festival.tickets.isEmpty {
                    return AnyView(URLButtonInApp(label: "Tickets", systemImage: "ticket", urlString: festival.tickets))
                } else {
                    return AnyView(EmptyView())
                }
            })),
            ("lostAndFound", ("Lost & Found", "questionmark.app.fill", {
                if !festival.lostAndFound.isEmpty {
                    return AnyView(URLButtonInApp(label: "Lost & Found", systemImage: "questionmark.app", urlString: festival.lostAndFound))
                } else {
                    return AnyView(EmptyView())
                }
            })),
        ]
        return links.filter { !$0.value.0.isEmpty }
    }

    // MARK: - Social Section
    private var socialLinks: [String: (label: String, systemImage: String, url: String)] {
        let socialLinks: [String: (label: String, systemImage: String, url: String)] = [
            "facebook": ("Facebook", "facebook", festival.facebookPage),
            "instagram": ("Instagram", "instagram", festival.instagramHandle),
            "x": ("𝕏", "x", festival.xHandle),
            "youTube": ("YouTube", "youtube", festival.youTubeChannel)
        ]
        return socialLinks.filter { !$1.url.isEmpty }
    }

    // MARK: - Active Indicator
    private var activeIndicator: some View {
        let startDate = convertStringToDate(dateString: festival.dateStart)
        let endDate = convertStringToDate(dateString: festival.dateEnd)
        let currentDate = Date()
        let isCurrentDateWithinFestival = startDate != nil && endDate != nil && (startDate!...endDate!).contains(currentDate)

        return AnyView(HStack {
            Menu {
                Button(action: {}) {
                    Label("\(festival.dateStart)-\(festival.dateEnd)", systemImage: "calendar.badge.checkmark")
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
        NavigationStack {
            var festival = FestivalModel()
            festival.id = "trf"
            festival.address = "21778 FM 1774"
            festival.campgroundMapImage = "TRFCampgroundMap"
            festival.city = "Todd Mission"
            festival.contactEmail = "info@texrenfest.com"
            festival.contactPhone = "1234567890"
            festival.dateEnd = "12/17/2024"
            festival.dateStart = "10/10/2024"
            festival.established = "1974"
            festival.facebookPage = "texrenfest"
            festival.festivalDescription = "The Texas Renaissance Festival is an annual Renaissance fair located in Todd Mission, Texas."
            festival.festivalMapImage = "TRFFestivalMap"
            festival.instagramHandle = "texrenfest"
            festival.locationMapLink = "https://maps.google.com"
            festival.logoImage = "TRFLogo"
            festival.lostAndFound = "https://www.texrenfest.com/lost-and-found"
            festival.name = "Texas Renaissance Festival"
            festival.postalCode = "77363"
            festival.state = "Texas"
            festival.tickets = "https://www.texrenfest.com/tickets"
            festival.timeEnd = "2000"
            festival.timeStart = "0900"
            festival.website = "https://www.texrenfest.com"
            festival.xHandle = "texrenfest"
            festival.youTubeChannel = "texrenfest"

            return FestivalView(festival: festival)
        }
    }
}




