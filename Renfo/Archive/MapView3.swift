//import Foundation
//import MapKit
//import Combine
//import SwiftUI
//
//struct Location: Identifiable {
//    let id = UUID()
//    let name: String
//    let coordinate: CLLocationCoordinate2D
//}
//
//let locations = [
//    Location(name: "Location 1", coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
//    Location(name: "Location 2", coordinate: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437))
//]
//
//struct MapView: View {
//        @State private var selectedLocation: Location?
//        @State private var region = MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 36.0, longitude: -120.0),
//            span: MKCoordinateSpan(latitudeDelta: 10.0, longitudeDelta: 10.0)
//        )
//
//        var body: some View {
//            VStack {
//                Map(coordinateRegion: $region, annotationItems: locations) { location in
//                    Marker(coordinate: location.coordinate, tint: .blue)
////                        .onTapGesture {
////                            selectedLocation = location
////                        }
//                }
//                .ignoresSafeArea()
//
//                if let selectedLocation = selectedLocation {
//                    VStack {
//                        Text("Selected Location")
//                            .font(.headline)
//                        Text(selectedLocation.name)
//                            .font(.subheadline)
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(10)
//                    .shadow(radius: 10)
//                }
//            }
//        }
//    }
//
//
//
//// MARK: - Preview Provider
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
