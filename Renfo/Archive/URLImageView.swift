//import SwiftUI
//
//struct URLImageView: View {
//    let fileName: String
//
//    @State private var image: UIImage? = nil
//    @State private var isLoading = false
//
//    var body: some View {
//        if let image = image {
//            Image(uiImage: image)
//                .resizable()
//                .scaledToFit()
//        } else if isLoading {
//            ProgressView()
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//        } else {
//            Color.clear
//                .onAppear {
//                    loadImage()
//                }
//        }
//    }
//
//    private func loadImage() {
//        isLoading = true
//
//        if let cachedImage = ImageCache.shared.getImage(forKey: fileName) {
//            self.image = cachedImage
//            self.isLoading = false
//        } else if ImageCache.shared.isRequestOngoing(forKey: fileName) {
//            // If a request is already ongoing, wait and retry after some delay
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                self.loadImage()
//            }
//        } else {
//            ImageCache.shared.setRequestOngoing(true, forKey: fileName)
//            FirestoreService().downloadImage(from: fileName) { downloadedImage in
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                    if let downloadedImage = downloadedImage {
//                        self.image = downloadedImage
//                        ImageCache.shared.setImage(downloadedImage, forKey: fileName)
//                    }
//                    ImageCache.shared.setRequestOngoing(false, forKey: fileName)
//                }
//            }
//        }
//    }
//}
