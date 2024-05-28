import SwiftUI
import MapKit
import FirebaseFirestore

class MapViewModel: ObservableObject {
    @Published var annotations: [MKPointAnnotation] = []
    @Published var festivals: [FestivalModel] = []
    @Published var selectedFestival: FestivalModel?
    @Published var showingFestivalView: Bool = false
    private let firestoreService = FirestoreService()

    init() {
        fetchFestivals()
    }

    func fetchFestivals() {
        firestoreService.fetchAllFestivals { fetchedFestivals in
            var fetchedAnnotations: [MKPointAnnotation] = []
            for festival in fetchedFestivals {
                if let coordinates = festival.coordinates {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    annotation.title = festival.name
                    fetchedAnnotations.append(annotation)
                }
            }
            DispatchQueue.main.async {
                self.annotations = fetchedAnnotations
                self.festivals = fetchedFestivals
            }
        }
    }

    func selectFestival(annotation: MKPointAnnotation) {
        guard let festival = festivals.first(where: { $0.coordinates?.latitude == annotation.coordinate.latitude && $0.coordinates?.longitude == annotation.coordinate.longitude }) else {
            return
        }
        selectedFestival = festival
        showingFestivalView = true
    }

    func isFestivalActive(_ festival: FestivalModel) -> Bool {
        let now = Date()
        guard let startDate = convertStringToDate(dateString: festival.dateStart),
              let endDate = convertStringToDate(dateString: festival.dateEnd) else {
            return false
        }
        return startDate <= now && now <= endDate
    }

    private func convertStringToDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy" // Update this format to match your actual date format
        return dateFormatter.date(from: dateString)
    }
}
