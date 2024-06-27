import Foundation
import SwiftUI
import Combine
import FirebaseFirestore

class FestivalViewModel: ObservableObject {
    @Published var festival: FestivalModel
    @Published var logoImage: UIImage? = nil
    @Published var festivalMapImage: UIImage? = nil
    @Published var campgroundMapImage: UIImage? = nil
    @Published var isFavorite: Bool = false
    private let favoriteKey = "favoriteFestivals"
    private let firestoreService = FirestoreService()
    private var cancellables = Set<AnyCancellable>()

    init(festival: FestivalModel) {
        self.festival = festival
        self.isFavorite = UserDefaults.standard.stringArray(forKey: favoriteKey)?.contains(festival.id ?? "") ?? false

        fetchImages()
    }

    private func fetchImages() {
        fetchImage(for: festival.logoImage) { [weak self] image in
            self?.logoImage = image
        }

        fetchImage(for: festival.festivalMapImage) { [weak self] image in
            self?.festivalMapImage = image
        }

        fetchImage(for: festival.campgroundMapImage) { [weak self] image in
            self?.campgroundMapImage = image
        }
    }

    private func fetchImage(for imageName: String, completion: @escaping (UIImage?) -> Void) {
        firestoreService.downloadImage(imageName: imageName, completion: completion)
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        saveFavoriteStatus()
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

    func openLocationInAppleMaps() {
        if let coordinates = festival.coordinates {
            let latitude = coordinates.latitude
            let longitude = coordinates.longitude
            let url = URL(string: "http://maps.apple.com/?q=\(latitude),\(longitude)")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Can't open Apple Maps.")
            }
        } else {
            print("Coordinates not found.")
        }
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
                    Label("Merchants", systemImage: "cart")
                })
            })),
            ("festivalMapImage", ("Festival Map", "map.fill", {
                if let festivalMapImage = self.festivalMapImage {
                    return AnyView(NavigationLink(destination: ImageViewer(image: festivalMapImage)) {
                        Label("Festival Map", systemImage: "map")
                    })
                } else {
                    return AnyView(EmptyView())
                }
            })),
            ("campgroundMapImage", ("Campground Map", "map.circle.fill", {
                if let campgroundMapImage = self.campgroundMapImage {
                    return AnyView(NavigationLink(destination: ImageViewer(image: campgroundMapImage)) {
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
        return links.filter { !$0.value.label.isEmpty }
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
