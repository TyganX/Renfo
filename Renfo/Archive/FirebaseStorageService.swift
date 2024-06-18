//import Foundation
//import SwiftUI
//import FirebaseStorage
//
//struct FirebaseStorageService {
//    static let shared = FirebaseStorageService()
//    private let storage = Storage.storage()
//    private let folderPath = "festivals"
//    private let fileExtensions = ["png", "jpg"] // Add other common extensions if needed
//
//    func downloadImage(from fileName: String, completion: @escaping (UIImage?) -> Void) {
//        // Check the cache first
//        if let cachedImage = ImageCache.shared.getImage(forKey: fileName) {
//            completion(cachedImage)
//            return
//        }
//
//        tryDownloadImage(from: fileName, withExtensions: fileExtensions) { image in
//            if let image = image {
//                // Cache the downloaded image
//                ImageCache.shared.setImage(image, forKey: fileName)
//            }
//            completion(image)
//        }
//    }
//
//    private func tryDownloadImage(from fileName: String, withExtensions extensions: [String], completion: @escaping (UIImage?) -> Void) {
//        guard !extensions.isEmpty else {
//            completion(nil)
//            return
//        }
//
//        var remainingExtensions = extensions
//        let currentExtension = remainingExtensions.removeFirst()
//        let pathReference = storage.reference(withPath: "\(folderPath)/\(fileName).\(currentExtension)")
//
//        pathReference.getData(maxSize: 100 * 1024 * 1024) { data, error in
//            if let error = error as NSError?, error.domain == StorageErrorDomain, error.code == StorageErrorCode.objectNotFound.rawValue {
//                // Try next extension
//                self.tryDownloadImage(from: fileName, withExtensions: remainingExtensions, completion: completion)
//            } else if let data = data, let image = UIImage(data: data) {
//                completion(image)
//            } else {
//                completion(nil)
//            }
//        }
//    }
//}
