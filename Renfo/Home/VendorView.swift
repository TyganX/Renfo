import SwiftUI

struct VendorView: View {
    var vendor: VendorData

    var body: some View {
        VStack {
            Image(vendor.logoImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)

            Text(vendor.name)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 9)

            Text(vendor.description)
                .font(.body)

            Spacer()
        }
//        .navigationTitle(vendor.name)
//        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview Provider
struct VendorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VendorView(vendor: trfDragonSlayer)
        }
    }
}
