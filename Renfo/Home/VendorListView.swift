import SwiftUI

struct VendorListView: View {
    var festivalID: String?
    var vendors: [VendorData] = [trfDragonSlayer] // Add all vendors here

    var filteredVendors: [VendorData] {
        if let festivalID = festivalID {
            return vendors.filter { $0.festivalIDs.contains(festivalID) }
        } else {
            return vendors
        }
    }

    var body: some View {
        List(filteredVendors, id: \.name) { vendor in
            NavigationLink(destination: VendorView(vendor: vendor)) {
                HStack {
                    Image(vendor.logoImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text(vendor.name)
                }
            }
        }
        .navigationTitle("Vendors")
//        .navigationTitle(festivalID != nil ? "\(festivalID!) Vendors" : "Vendors")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview Provider
struct VendorListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VendorListView()
//            VendorListView(festivalID: "TRF")
        }
    }
}
