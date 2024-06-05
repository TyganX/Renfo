import Foundation
import SwiftUI
import Combine

class FestivalListViewModel: ObservableObject {
    @Published var festivals: [FestivalModel] = []
    @Published var sortOption: SortOption {
        didSet {
            UserDefaults.standard.set(sortOption.rawValue, forKey: Constants.sortOptionKey)
        }
    }
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    private var dataLoaded: Bool = false

    init() {
        let savedSortOption = UserDefaults.standard.integer(forKey: Constants.sortOptionKey)
        self.sortOption = SortOption(rawValue: savedSortOption) ?? .state
    }

    func fetchFestivals() {
        guard !dataLoaded else { return }

        isLoading = true
        FirestoreService().fetchAllFestivals { fetchedFestivals in
            DispatchQueue.main.async {
                self.festivals = fetchedFestivals
                self.isLoading = false
                self.dataLoaded = true
            }
        }
    }

    var filteredFestivals: [FestivalModel] {
        if searchText.isEmpty {
            return festivals
        } else {
            return festivals.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var sortedFestivals: [String: [FestivalModel]] {
        switch sortOption {
        case .name:
            return Dictionary(grouping: filteredFestivals.sorted(by: { $0.name < $1.name })) {
                String($0.name.prefix(1))
            }
        case .state:
            let groupedByState = Dictionary(grouping: filteredFestivals) { $0.state }
            return groupedByState.mapValues { $0.sorted(by: { $0.name < $1.name }) }
        case .active:
            let now = Date()
            let activeFestivals = filteredFestivals.filter { $0.isActive }
                .sorted(by: { ($0.dateStart.toDate(format: "MM/dd/yyyy") ?? Date.distantFuture) < ($1.dateStart.toDate(format: "MM/dd/yyyy") ?? Date.distantFuture) })
            let upcomingFestivals = filteredFestivals.filter { !($0.isActive) && ($0.dateStart.toDate(format: "MM/dd/yyyy") ?? Date.distantFuture) > now }
                .sorted(by: { ($0.dateStart.toDate(format: "MM/dd/yyyy") ?? Date.distantFuture) < ($1.dateStart.toDate(format: "MM/dd/yyyy") ?? Date.distantFuture) })
            let tbaFestivals = filteredFestivals.filter { !($0.isActive) && ($0.dateEnd.toDate(format: "MM/dd/yyyy") ?? Date.distantPast) < now }
                .sorted(by: { ($0.dateStart.toDate(format: "MM/dd/yyyy") ?? Date.distantFuture) < ($1.dateStart.toDate(format: "MM/dd/yyyy") ?? Date.distantFuture) })
            
            var activeSections: [String: [FestivalModel]] = [:]
            if !activeFestivals.isEmpty {
                activeSections[" Active"] = activeFestivals
            }
            if !upcomingFestivals.isEmpty {
                activeSections[" Upcoming"] = upcomingFestivals
            }
            if !tbaFestivals.isEmpty {
                activeSections["TBA"] = tbaFestivals
            }
            return activeSections
        case .favorite:
            let favorites = UserDefaults.standard.stringArray(forKey: "favoriteFestivals") ?? []
            let favoriteFestivals = filteredFestivals.filter { favorites.contains($0.id ?? "") }
                .sorted(by: { $0.name < $1.name })
            let nonFavoriteFestivals = filteredFestivals.filter { !favorites.contains($0.id ?? "") }
                .sorted(by: { $0.name < $1.name })
            
            var favoriteSections: [String: [FestivalModel]] = [:]
            if !favoriteFestivals.isEmpty {
                favoriteSections["Favorites"] = favoriteFestivals
            }
            if !nonFavoriteFestivals.isEmpty {
                favoriteSections["Others"] = nonFavoriteFestivals
            }
            return favoriteSections
        }
    }

    func refreshFavoriteSort() {
        objectWillChange.send()
    }
}

struct Constants {
    static let sortOptionKey = "sortOption"
}

enum SortOption: Int, Identifiable {
    case name
    case state
    case active
    case favorite

    var id: Int { self.rawValue }
}
