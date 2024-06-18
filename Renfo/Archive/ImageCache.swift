//import UIKit
//
//class ImageCache {
//    static let shared = ImageCache()
//
//    private init() {}
//
//    private let cache = NSCache<NSString, UIImage>()
//    private var ongoingRequests = [String: Bool]()
//    private let fileManager = FileManager.default
//
//    func setImage(_ image: UIImage, forKey key: String) {
//        cache.setObject(image, forKey: key as NSString)
//        saveImageToDisk(image, forKey: key)
//        ongoingRequests[key] = false
//    }
//
//    func getImage(forKey key: String) -> UIImage? {
//        if let image = cache.object(forKey: key as NSString) {
//            return image
//        } else {
//            return loadImageFromDisk(forKey: key)
//        }
//    }
//
//    func isRequestOngoing(forKey key: String) -> Bool {
//        return ongoingRequests[key] ?? false
//    }
//
//    func setRequestOngoing(_ ongoing: Bool, forKey key: String) {
//        ongoingRequests[key] = ongoing
//    }
//
//    private func saveImageToDisk(_ image: UIImage, forKey key: String) {
//        guard let data = image.pngData() else { return }
//        let url = getDocumentsDirectory().appendingPathComponent(key)
//
//        do {
//            try data.write(to: url)
//        } catch {
//            print("Error saving image to disk: \(error.localizedDescription)")
//        }
//    }
//
//    private func loadImageFromDisk(forKey key: String) -> UIImage? {
//        let url = getDocumentsDirectory().appendingPathComponent(key)
//
//        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
//            cache.setObject(image, forKey: key as NSString)
//            return image
//        }
//
//        return nil
//    }
//
//    private func getDocumentsDirectory() -> URL {
//        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//    }
//}
