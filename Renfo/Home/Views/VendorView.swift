import SwiftUI

struct VendorView: View {
    var vendor: VendorModel

    var body: some View {
        VStack {
            if !vendor.logoImage.isEmpty {
                Image(vendor.logoImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
            Text(vendor.name)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 9)
            Text(vendor.description)
                .font(.body)
                .padding(.bottom)
            if !vendor.contactEmail.isEmpty {
                Text("Email: \(vendor.contactEmail)")
                    .padding(.bottom)
            }
            if !vendor.contactPhone.isEmpty {
                Text("Phone: \(vendor.contactPhone)")
                    .padding(.bottom)
            }
            if !vendor.website.isEmpty {
                Link("Visit Website", destination: URL(string: vendor.website)!)
                    .padding(.bottom)
            }
            Spacer()
        }
//        .navigationTitle(vendor.name)
    }
}

// MARK: - Preview Provider
struct VendorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            var vendor = VendorModel()
            vendor.id = "trfds"
            vendor.festivalIDs = ["trf"]
            vendor.name = "TRF DragonSlayer"
            vendor.description = "Making History Fashionable"
            vendor.logoImage = "TRFDragonSlayerLogo"
            vendor.contactPhone = "1234567890"
            vendor.contactEmail =  "sales@trfdragonslayer.com"
            vendor.website = "http://www.trfdragonslayer.com/"
            vendor.facebookPage = "sampleVendorFacebook"
            vendor.instagramHandle = "sampleVendorInstagram"
            vendor.xHandle = "sampleVendorX"
            vendor.youTubeChannel = "sampleVendorYouTube"
            
            return VendorView(vendor: vendor)
        }
    }
}







//import SwiftUI
//
//struct VendorView: View {
//    var vendor: VendorData
//
//    var body: some View {
//        VStack {
//            Image(vendor.logoImageName)
//                .resizable()
//                .scaledToFit()
//                .frame(height: 200)
//
//            Text(vendor.name)
//                .font(.title3)
//                .fontWeight(.bold)
//                .padding(.bottom, 9)
//
//            Text(vendor.description)
//                .font(.body)
//
//            Spacer()
//        }
////        .navigationTitle(vendor.name)
////        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//// MARK: - Preview Provider
//struct VendorView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            VendorView(vendor: trfDragonSlayer)
//        }
//    }
//}
