import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreService: ObservableObject {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    @Published var festivals: [FestivalModel] = []
    
    init() {
        fetchAllFestivals { [weak self] festivals in
            self?.festivals = festivals
        }
    }
    
    // Fetch all festivals
    func fetchAllFestivals(completion: @escaping ([FestivalModel]) -> Void) {
        db.collection("festivals").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching festivals: \(error)")
                completion([])
                return
            }
            let festivals = snapshot?.documents.compactMap { document -> FestivalModel? in
                var festival = try? document.data(as: FestivalModel.self)
                festival?.id = document.documentID // Set the document ID
                return festival
            } ?? []
            completion(festivals)
        }
    }
    
    // Fetch a single festival by ID
    func fetchFestival(byID id: String, completion: @escaping (FestivalModel?) -> Void) {
        let docRef = db.collection("festivals").document(id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    var festival = try document.data(as: FestivalModel.self)
                    festival.id = document.documentID // Set the document ID
                    completion(festival)
                } catch {
                    print("Error decoding festival data: \(error)")
                    completion(nil)
                }
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    
    // Fetch all vendors
    func fetchAllVendors(completion: @escaping ([VendorModel]) -> Void) {
        db.collection("vendors").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching vendors: \(error)")
                completion([])
                return
            }
            let vendors = snapshot?.documents.compactMap { document -> VendorModel? in
                var vendor = try? document.data(as: VendorModel.self)
                vendor?.id = document.documentID // Set the document ID
                return vendor
            } ?? []
            completion(vendors)
        }
    }

    // Fetch a single vendor by ID
    func fetchVendor(byID id: String, completion: @escaping (VendorModel?) -> Void) {
        let docRef = db.collection("vendors").document(id)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                do {
                    var vendor = try document.data(as: VendorModel.self)
                    vendor.id = document.documentID // Set the document ID
                    completion(vendor)
                } catch {
                    print("Error decoding vendor data: \(error)")
                    completion(nil)
                }
            } else {
                print("Document does not exist")
                completion(nil)
            }
        }
    }
    
    // Download an image from Firebase Storage and cache it locally
    func downloadImage(imageName: String, completion: @escaping (UIImage?) -> Void) {
        guard !imageName.isEmpty else {
            completion(nil)
            return
        }
        
        let extensions = ["png", "jpg", "jpeg"]
        fetchImageWithExtensions(imageName: imageName, extensions: extensions, completion: completion)
    }

    private func fetchImageWithExtensions(imageName: String, extensions: [String], completion: @escaping (UIImage?) -> Void) {
        guard let ext = extensions.first else {
            completion(nil)
            return
        }
        
        let imageRef = storage.reference().child("festivals/\(imageName).\(ext)")
        let localURL = getLocalFileURL(for: "\(imageName).\(ext)")
        
        // Check if the image is already cached locally
        if FileManager.default.fileExists(atPath: localURL.path) {
            let image = UIImage(contentsOfFile: localURL.path)
            completion(image)
            return
        }
        
        imageRef.write(toFile: localURL) { url, error in
            if let error = error {
                if extensions.count > 1 {
                    // Try next extension
                    self.fetchImageWithExtensions(imageName: imageName, extensions: Array(extensions.dropFirst()), completion: completion)
                } else {
                    print("Error downloading image: \(error)")
                    completion(nil)
                }
            } else {
                if let url = url, let image = UIImage(contentsOfFile: url.path) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }

    private func getLocalFileURL(for imageName: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent(imageName)
    }
}
