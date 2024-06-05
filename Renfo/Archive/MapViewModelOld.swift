//import SwiftUI
//import MapKit
//import CoreLocation
//import FirebaseFirestore
//
//class MapViewModel: ObservableObject {
//    @Published var annotations: [MKPointAnnotation] = []
//    @Published var festivals: [FestivalModel] = []
//    @Published var selectedFestival: FestivalModel?
//    @Published var isFestivalViewVisible: Bool = false
//    private let firestoreService = FirestoreService()
//
//    init() {
//        fetchFestivals()
//    }
//
//    func fetchFestivals() {
//        firestoreService.fetchAllFestivals { [weak self] fetchedFestivals in
//            guard let self = self else { return }
//            let fetchedAnnotations = fetchedFestivals.compactMap { festival -> MKPointAnnotation? in
//                guard let coordinates = festival.coordinates else { return nil }
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
//                annotation.title = festival.name
//                return annotation
//            }
//            DispatchQueue.main.async {
//                self.annotations = fetchedAnnotations
//                self.festivals = fetchedFestivals
//            }
//        }
//    }
//
//    func selectFestival(with coordinate: CLLocationCoordinate2D) {
//        if let festival = festivals.first(where: { $0.coordinates?.latitude == coordinate.latitude && $0.coordinates?.longitude == coordinate.longitude }) {
//            selectedFestival = festival
//            isFestivalViewVisible = true
//        }
//    }
//
//    func isFestivalActive(_ festival: FestivalModel) -> Bool {
//        let now = Date()
//        guard let startDate = festival.dateStart.toDate(), let endDate = festival.dateEnd.toDate() else { return false }
//        return startDate <= now && now <= endDate
//    }
//}
//
//extension String {
//    func toDate() -> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyyy" // Update this format to match your actual date format
//        return dateFormatter.date(from: self)
//    }
//}
