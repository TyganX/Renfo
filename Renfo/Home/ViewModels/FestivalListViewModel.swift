import Foundation
import SwiftUI

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
            let activeFestivals = filteredFestivals.filter { $0.isActive }.sorted(by: { convertStringToDate(dateString: $0.dateStart) ?? Date.distantFuture < convertStringToDate(dateString: $1.dateStart) ?? Date.distantFuture })
            let upcomingFestivals = filteredFestivals.filter { convertStringToDate(dateString: $0.dateStart) ?? Date.distantFuture > now }.sorted(by: { convertStringToDate(dateString: $0.dateStart) ?? Date.distantFuture < convertStringToDate(dateString: $1.dateStart) ?? Date.distantFuture })
            let tbaFestivals = filteredFestivals.filter { convertStringToDate(dateString: $0.dateEnd) ?? Date.distantPast < now && !$0.isActive }.sorted(by: { convertStringToDate(dateString: $0.dateEnd) ?? Date.distantPast > convertStringToDate(dateString: $1.dateEnd) ?? Date.distantPast })
            return ["Active": activeFestivals, "Inactive": upcomingFestivals, "TBA": tbaFestivals]
        }
    }
}

struct Constants {
    static let sortOptionKey = "sortOption"
}

enum SortOption: Int, Identifiable {
    case name
    case state
    case active

    var id: Int { self.rawValue }
}
