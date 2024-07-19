//// MARK: - Address Section with map
//private var addressSectionMap: some View {
//    Section {
//        HStack {
//            VStack(alignment: .leading, spacing: 10) {
//                Text(viewModel.festival.address)
//                Divider()
//                Text("\(viewModel.festival.city), \(stateAbbreviations[viewModel.festival.state] ?? viewModel.festival.state) \(viewModel.festival.postalCode)")
//                Divider()
//                Text("United States")
//            }
//            Spacer()
//            if let geoPoint = viewModel.festival.coordinates {
//                MapSnapshot(coordinate: CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude))
//                    .frame(width: 100, height: 100)
//                    .cornerRadius(10)
//            }
//        }
//    }
//}
