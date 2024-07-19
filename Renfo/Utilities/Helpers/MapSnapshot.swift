import SwiftUI
import MapKit

struct MapSnapshot: View {
    @State private var position = MapCameraPosition.automatic
    var coordinate: CLLocationCoordinate2D
    
    var body: some View {
        Map(position: $position) {
            Marker("", systemImage: "crown.fill", coordinate: coordinate)
//                .tint(.red)
        }
        .allowsHitTesting(false) // Disable interactions
        .onAppear {
            // Center the map position on the provided coordinate
            position = .region(MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        }
    }
}
