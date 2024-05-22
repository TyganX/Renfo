import SwiftUI

struct VendorListView: View {
    @State private var vendors: [VendorModel] = []
    var festivalID: String?

    var body: some View {
        List(vendors) { vendor in
            NavigationLink(destination: VendorView(vendor: vendor)) {
                HStack {
                    if !vendor.logoImage.isEmpty {
                        Image(vendor.logoImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                    Text(vendor.name)
                }
            }
        }
        .navigationTitle("Vendors")
        .onAppear {
            fetchVendors()
        }
    }

    private func fetchVendors() {
        FirestoreService().fetchAllVendors { fetchedVendors in
            DispatchQueue.main.async {
                if let festivalID = festivalID {
                    let festivalIDLowercased = festivalID.lowercased()
                    self.vendors = fetchedVendors.filter { vendor in
                        let vendorFestivalIDsLowercased = vendor.festivalIDs.map { $0.lowercased() }
                        return vendorFestivalIDsLowercased.contains { $0 == festivalIDLowercased }
                    }
                } else {
                    self.vendors = fetchedVendors
                }
            }
        }
    }
}

// MARK: - Preview Provider
struct VendorListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VendorListView(festivalID: "trf")
        }
    }
}













//import Foundation
//import SwiftUI
//
//struct VendorListView: View {
//    var festivalID: String?
//    var vendors: [VendorData] = [trfDragonSlayer] // Add all vendors here
//
//    var filteredVendors: [VendorData] {
//        if let festivalID = festivalID {
//            return vendors.filter { $0.festivalIDs.contains(festivalID) }
//        } else {
//            return vendors
//        }
//    }
//
//    var body: some View {
//            List(filteredVendors, id: \.name) { vendor in
//                NavigationLink(destination: VendorView(vendor: vendor)) {
//                    HStack {
//                        Image(vendor.logoImageName)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 40, height: 40)
//                        Text(vendor.name)
//                    }
//                }
//            }
//        .navigationTitle("Vendors")
//        .navigationTitle(festivalID != nil ? "\(festivalID!) Vendors" : "Vendors")
//        .navigationBarTitleDisplayMode(festivalID != nil ? .inline : .large)
//    }
//}
//
//// MARK: - Preview Provider
//struct VendorListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            VendorListView()
////            VendorListView(festivalID: "TRF")
//        }
//    }
//}
