//import UIKit
//import Firebase
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
//        
//        // Enable Firestore offline persistence
//        let settings = Firestore.firestore().settings
//        settings.cacheSettings = PersistentCacheSettings()
//        Firestore.firestore().settings = settings
//        
//        return true
//    }
//}
