//import SwiftUI
//import MapKit
//import CoreLocation
//
//struct CustomAnnotation: Identifiable {
//    let id = UUID()
//    let title: String
//    let coordinate: CLLocationCoordinate2D
//}
//
//struct MapView: View {
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
//        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
//    )
//    
//    @State private var annotations: [CustomAnnotation] = []
//    
//    let festivalAddresses = [
//        "1600 Pennsylvania Ave NW, Washington, DC 20500",
//        "Golden Gate Bridge, San Francisco, CA",
//        "Eiffel Tower, Paris, France"
//    ]
//    
//    var body: some View {
//        Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
//            MapMarker(coordinate: annotation.coordinate, tint: .red)
//        }
//        .onAppear {
//            addFestivalAnnotations()
//        }
//    }
//    
//    func addFestivalAnnotations() {
//        let geocoder = CLGeocoder()
//        for address in festivalAddresses {
//            geocoder.geocodeAddressString(address) { (placemarks, error) in
//                if let error = error {
//                    print("Geocoding error: \(error.localizedDescription)")
//                    return
//                }
//                
//                guard let placemark = placemarks?.first, let location = placemark.location else {
//                    print("No location found for address: \(address)")
//                    return
//                }
//                
//                // Create custom annotation and add to the list
//                let annotation = CustomAnnotation(title: address, coordinate: location.coordinate)
//                annotations.append(annotation)
//                
//                // Optionally, adjust the region to fit all annotations
//                adjustRegionToFitAllAnnotations()
//            }
//        }
//    }
//    
//    func adjustRegionToFitAllAnnotations() {
//        var zoomRect = MKMapRect.null
//        for annotation in annotations {
//            let annotationPoint = MKMapPoint(annotation.coordinate)
//            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1)
//            zoomRect = zoomRect.union(pointRect)
//        }
//        if !zoomRect.isNull {
//            region = MKCoordinateRegion(zoomRect)
//        }
//    }
//}
//
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
