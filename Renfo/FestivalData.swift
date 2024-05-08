//import SwiftUI
//import Firebase
//
//class FestivalData: ObservableObject {
//    @Published var festivals: [Festival] = []
//    
//    init() {
//        fetchFestivals()
//    }
//    func fetchFestivals() {
//        festivals.removeALL()
//        let db = Firestore.firestore()
//        let ref = db.collection("Festivals")
//        ref.getDocuments { snapshot, error in
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
//            
//            if let snapshot = snapshot {
//                for document in snapshot.documents {
//                    let data = document.data()
//                    
//                    let id = data["id"] as? String ?? ""
//                    let festival = data["Festival"] as? String ?? ""
//                    
//                    let festival = Festival(id: id, festival: festival)
//                    self.festivals.append(festival)
//                }
//            }
//        }
//    }
//}
