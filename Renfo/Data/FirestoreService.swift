import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreService {
    private let db = Firestore.firestore()
    
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
}
