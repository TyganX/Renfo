//import SwiftUI
//import MapKit
//import FirebaseFirestore
//
//struct MapView: View {
//    @StateObject private var firestoreService = FirestoreService()
//    
//    @State private var position = MapCameraPosition.automatic
//    @State private var isSheetPresented: Bool = true
//    @State private var selectedFestival: FestivalModel?
//    
//    var body: some View {
//        Map(position: $position) {
//            ForEach(firestoreService.festivals, id: \.id) { festival in
//                if let coordinates = festival.coordinates {
//                    let coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
//                    Annotation(LocalizedStringKey(festival.name), coordinate: coordinate) {
//                        Marker(festival.name, coordinate: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude))
////                            VStack {
////                                Image(systemName: "mappin.circle.fill")
////                                    .resizable()
////                                    .frame(width: 30, height: 30)
////                                    .foregroundColor(.red)
////                                Text(festival.name)
////                                    .font(.caption)
////                                    .fixedSize()
////                            }
////                            .onTapGesture {
////                                selectedFestival = festival
////                                isSheetPresented.toggle()
////                            }
//                        
//                    }
//                }
//            }
//        }
//        .ignoresSafeArea()
//        .sheet(isPresented: $isSheetPresented) {
//            SheetView()
//        }
//    }
//}
//
//struct SheetView: View {
//    @State private var search: String = ""
//
//    var body: some View {
//        VStack {
//            FestivalListView()
//                .environmentObject(FestivalListViewModel())
//        }
//        .interactiveDismissDisabled()
//        .presentationDetents([.height(200), .large])
//        .presentationBackground(.regularMaterial)
//        .presentationBackgroundInteraction(.enabled(upThrough: .large))
//    }
//}
//
//// MARK: - Preview Provider
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
