import Foundation
import SwiftUI

class FestivalViewModel: ObservableObject {
    @Published var festival: FestivalModel
    
    init(festival: FestivalModel) {
        self.festival = festival
    }
    
    var detailsLinks: [(key: String, value: (systemImage: String, text: String))] {
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

    var resourceLinks: [(key: String, value: (label: String, systemImage: String, view: () -> AnyView))] {
        let links: [(key: String, value: (label: String, systemImage: String, view: () -> AnyView))] = [
            ("vendors", ("Vendors", "cart", {
                AnyView(NavigationLink(destination: VendorListView(festivalID: self.festival.id ?? "")) {
                    Label("Vendors", systemImage: "cart")
                })
            })),
            ("festivalMapImage", ("Festival Map", "map.fill", {
                if !self.festival.festivalMapImage.isEmpty {
                    return AnyView(NavigationLink(destination: ImageView(imageName: self.festival.festivalMapImage)) {
                        Label("Festival Map", systemImage: "map")
                    })
                } else {
                    return AnyView(EmptyView())
                }
            })),
            ("campgroundMapImage", ("Campground Map", "map.circle.fill", {
                if !self.festival.campgroundMapImage.isEmpty {
                    return AnyView(NavigationLink(destination: ImageView(imageName: self.festival.campgroundMapImage)) {
                        Label("Campground Map", systemImage: "map.circle")
                    })
                } else {
                    return AnyView(EmptyView())
                }
            })),
            ("tickets", ("Tickets", "ticket.fill", {
                if !self.festival.tickets.isEmpty {
                    return AnyView(URLButtonInApp(label: "Tickets", systemImage: "ticket", urlString: self.festival.tickets))
                } else {
                    return AnyView(EmptyView())
                }
            })),
            ("lostAndFound", ("Lost & Found", "questionmark.app.fill", {
                if !self.festival.lostAndFound.isEmpty {
                    return AnyView(URLButtonInApp(label: "Lost & Found", systemImage: "questionmark.app", urlString: self.festival.lostAndFound))
                } else {
                    return AnyView(EmptyView())
                }
            })),
        ]
        return links.filter { !$0.value.0.isEmpty }
    }

    var socialLinks: [String: (label: String, systemImage: String, url: String)] {
        let socialLinks: [String: (label: String, systemImage: String, url: String)] = [
            "facebook": ("Facebook", "facebook", self.festival.facebookPage),
            "instagram": ("Instagram", "instagram", self.festival.instagramHandle),
            "x": ("𝕏", "x", self.festival.xHandle),
            "youTube": ("YouTube", "youtube", self.festival.youTubeChannel)
        ]
        return socialLinks.filter { !$1.url.isEmpty }
    }

    var activeIndicatorText: String {
        let startDate = convertStringToDate(dateString: self.festival.dateStart) ?? Date.distantFuture
        let endDate = convertStringToDate(dateString: self.festival.dateEnd) ?? Date.distantPast
        let currentDate = Date()

        if (currentDate >= startDate && currentDate <= endDate) {
            return "Currently Active!"
        } else if (currentDate < startDate) {
            let daysUntilStart = Calendar.current.dateComponents([.day], from: currentDate, to: startDate).day ?? 0
            return "\(daysUntilStart) Days Until Huzzah!"
        } else {
            return "TBA"
        }
    }
}
