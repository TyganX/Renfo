import Foundation
import SwiftUI

class FestivalViewModel: ObservableObject {
    @Published var festival: FestivalModel
    @Published var isFavorite: Bool = false
    private let favoriteKey = "favoriteFestivals"
    private let listViewModel: FestivalListViewModel

    init(festival: FestivalModel, listViewModel: FestivalListViewModel) {
        self.festival = festival
        self.listViewModel = listViewModel
        loadFavoriteStatus()
    }

    func toggleFavorite() {
        isFavorite.toggle()
        saveFavoriteStatus()
        listViewModel.refreshFavoriteSort()
    }

    private func loadFavoriteStatus() {
        let favorites = UserDefaults.standard.stringArray(forKey: favoriteKey) ?? []
        isFavorite = favorites.contains(festival.id ?? "")
    }

    private func saveFavoriteStatus() {
        var favorites = UserDefaults.standard.stringArray(forKey: favoriteKey) ?? []
        if isFavorite {
            if let festivalID = festival.id, !favorites.contains(festivalID) {
                favorites.append(festivalID)
            }
        } else {
            favorites.removeAll { $0 == festival.id }
        }
        UserDefaults.standard.set(favorites, forKey: favoriteKey)
    }

    var detailsLinks: [(key: String, value: (systemImage: String, text: String, isActive: Bool, daysUntilStart: Int?))] {
            let formattedStartDate = festival.dateStart.toDate(format: "MM/dd/yyyy")?.formattedDateString() ?? festival.dateStart
            let formattedEndDate = festival.dateEnd.toDate(format: "MM/dd/yyyy")?.formattedDateString() ?? festival.dateEnd
            let formattedStartTime = festival.timeStart.toTime() ?? festival.timeStart
            let formattedEndTime = festival.timeEnd.toTime() ?? festival.timeEnd

            let startDate = festival.dateStart.toDate(format: "MM/dd/yyyy") ?? Date.distantFuture
            let endDate = festival.dateEnd.toDate(format: "MM/dd/yyyy") ?? Date.distantPast
            let currentDate = Date()
            let isActive = (currentDate >= startDate && currentDate <= endDate)
            let daysUntilStart = Calendar.current.dateComponents([.day], from: currentDate, to: startDate).day

            let links: [(key: String, value: (systemImage: String, text: String, isActive: Bool, daysUntilStart: Int?))] = [
                ("dates", ("calendar", "\(formattedStartDate) - \(formattedEndDate)", isActive, daysUntilStart)),
                ("hours", ("clock", "\(formattedStartTime) - \(formattedEndTime)", false, nil))
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
                    return AnyView(NavigationLink(destination: ImageViewer(imageName: self.festival.festivalMapImage)) {
                        Label("Festival Map", systemImage: "map")
                    })
                } else {
                    return AnyView(EmptyView())
                }
            })),
            ("campgroundMapImage", ("Campground Map", "map.circle.fill", {
                if !self.festival.campgroundMapImage.isEmpty {
                    return AnyView(NavigationLink(destination: ImageViewer(imageName: self.festival.campgroundMapImage)) {
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
        let startDate = festival.dateStart.toDate(format: "MM/dd/yyyy") ?? Date.distantFuture
        let endDate = festival.dateEnd.toDate(format: "MM/dd/yyyy") ?? Date.distantPast
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
