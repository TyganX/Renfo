import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        view.setRegion(region, animated: true)
    }
}

struct TestView2: View {
    var body: some View {
        VStack {
            MapView(coordinate: CLLocationCoordinate2D(latitude: 30.1594659, longitude: -95.7718052)) // Coordinates for Texas Renaissance Festival
                .frame(height: 200)
            Text("21778 FM 1774")
            Text("Todd Mission, TX 77363")
        }
    }
}

struct TestView2_Previews: PreviewProvider {
    static var previews: some View {
        TestView2()
    }
}
