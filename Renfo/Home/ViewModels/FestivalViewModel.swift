//import Foundation
//import SwiftUI
//
//class FestivalViewModel: ObservableObject {
//    @Published var festival: FestivalModel
//
//    init(festival: FestivalModel) {
//        self.festival = festival
//    }
//
//    var headerSectionTitle: String {
//        return festival.id?.isEmpty == false ? "\(festival.id!)" : ""
//    }
//
//    var establishedText: String {
//        return festival.established.isEmpty ? "" : "Est. \(festival.established)"
//    }
//
//    var activeIndicatorText: String {
//        let startDate = convertStringToDate(dateString: festival.dateStart) ?? Date.distantFuture
//        let endDate = convertStringToDate(dateString: festival.dateEnd) ?? Date.distantPast
//        let currentDate = Date()
//
//        if currentDate >= startDate && currentDate <= endDate {
//            return "Currently Active!"
//        } else if currentDate < startDate {
//            let daysUntilStart = Calendar.current.dateComponents([.day], from: currentDate, to: startDate).day ?? 0
//            return "\(daysUntilStart) Days Until Huzzah!"
//        } else {
//            return "TBA"
//        }
//    }
//
//    var isActive: Bool {
//        let startDate = convertStringToDate(dateString: festival.dateStart) ?? Date.distantFuture
//        let endDate = convertStringToDate(dateString: festival.dateEnd) ?? Date.distantPast
//        let currentDate = Date()
//        return currentDate >= startDate && currentDate <= endDate
//    }
//
//    var detailsLinks: [(key: String, value: (systemImage: String, text: String))] {
//        let formattedStartDate = convertStringToDate(dateString: festival.dateStart)?.formattedDateString() ?? festival.dateStart
//        let formattedEndDate = convertStringToDate(dateString: festival.dateEnd)?.formattedDateString() ?? festival.dateEnd
//        let formattedStartTime = convertTimeString(timeString: festival.timeStart) ?? festival.timeStart
//        let formattedEndTime = convertTimeString(timeString: festival.timeEnd) ?? festival.timeEnd
//
//        let links: [(key: String, value: (systemImage: String, text: String))] = [
//            ("dates", ("calendar", "\(formattedStartDate) - \(formattedEndDate)")),
//            ("hours", ("clock", "\(formattedStartTime) - \(formattedEndTime)"))
//        ]
//        return links.filter { !$0.value.text.isEmpty }
//    }
//
//    var resourceLinks: [(key: String, value: (label: String, systemImage: String, view: () -> AnyView))] {
//        let links: [(key: String, value: (label: String, systemImage: String, view: () -> AnyView))] = [
//            ("vendors", ("Vendors", "cart", { [weak self] in
//                AnyView(NavigationLink(destination: VendorListView(festivalID: self?.festival.id ?? "")) {
//                    Label("Vendors", systemImage: "cart")
//                })
//            })),
//            ("festivalMapImage", ("Festival Map", "map.fill", { [weak self] in
//                if let festivalMapImage = self?.festival.festivalMapImage, !festivalMapImage.isEmpty {
//                    return AnyView(NavigationLink(destination: ImageView(imageName: festivalMapImage)) {
//                        Label("Festival Map", systemImage: "map")
//                    })
//                } else {
//                    return AnyView(EmptyView())
//                }
//            })),
//            ("campgroundMapImage", ("Campground Map", "map.circle.fill", { [weak self] in
//                if let campgroundMapImage = self?.festival.campgroundMapImage, !campgroundMapImage.isEmpty {
//                    return AnyView(NavigationLink(destination: ImageView(imageName: campgroundMapImage)) {
//                        Label("Campground Map", systemImage: "map.circle")
//                    })
//                } else {
//                    return AnyView(EmptyView())
//                }
//            })),
//            ("tickets", ("Tickets", "ticket.fill", { [weak self] in
//                if let tickets = self?.festival.tickets, !tickets.isEmpty {
//                    return AnyView(URLButtonInApp(label: "Tickets", systemImage: "ticket", urlString: tickets))
//                } else {
//                    return AnyView(EmptyView())
//                }
//            })),
//            ("lostAndFound", ("Lost & Found", "questionmark.app.fill", { [weak self] in
//                if let lostAndFound = self?.festival.lostAndFound, !lostAndFound.isEmpty {
//                    return AnyView(URLButtonInApp(label: "Lost & Found", systemImage: "questionmark.app", urlString: lostAndFound))
//                } else {
//                    return AnyView(EmptyView())
//                }
//            }))
//        ]
//        return links.filter { !$0.value.label.isEmpty }
//    }
//
//    var socialLinks: [String: (label: String, systemImage: String, url: String)] {
//        let socialLinks: [String: (label: String, systemImage: String, url: String)] = [
//            "facebook": ("Facebook", "facebook", festival.facebookPage),
//            "instagram": ("Instagram", "instagram", festival.instagramHandle),
//            "x": ("𝕏", "x", festival.xHandle),
//            "youTube": ("YouTube", "youtube", festival.youTubeChannel)
//        ]
//        return socialLinks.filter { !$1.url.isEmpty }
//    }
//}
