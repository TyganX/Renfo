//import SwiftUI
//
//extension UserDefaults {
//    func set<T: Codable>(object: T, forKey: String) {
//        if let data = try? JSONEncoder().encode(object) {
//            set(data, forKey: forKey)
//        }
//    }
//    
//    func getObject<T: Codable>(forKey: String, castTo type: T.Type) -> T? {
//        if let data = data(forKey: forKey) {
//            return try? JSONDecoder().decode(T.self, from: data)
//        }
//        return nil
//    }
//}
