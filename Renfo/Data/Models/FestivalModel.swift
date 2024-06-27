import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct FestivalModel: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var address: String = ""
    var campgroundMapImage: String = ""
    var city: String = ""
    var contactEmail: String = ""
    var contactPhone: String = ""
    var dateEnd: String = ""
    var dateStart: String = ""
    var established: String = ""
    var facebookPage: String = ""
    var festivalDescription: String = ""
    var festivalMapImage: String = ""
    var instagramHandle: String = ""
    var locationMapLink: String = ""
    var logoImage: String = ""
    var lostAndFound: String = ""
    var name: String = ""
    var postalCode: String = ""
    var state: String = ""
    var tickets: String = ""
    var timeEnd: String = ""
    var timeStart: String = ""
    var website: String = ""
    var xHandle: String = ""
    var youTubeChannel: String = ""
    var coordinates: GeoPoint? = nil // Use GeoPoint for coordinates

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? nil
        self.address = try container.decodeIfPresent(String.self, forKey: .address) ?? ""
        self.campgroundMapImage = try container.decodeIfPresent(String.self, forKey: .campgroundMapImage) ?? ""
        self.city = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        self.contactEmail = try container.decodeIfPresent(String.self, forKey: .contactEmail) ?? ""
        self.contactPhone = try container.decodeIfPresent(String.self, forKey: .contactPhone) ?? ""
        self.dateEnd = try container.decodeIfPresent(String.self, forKey: .dateEnd) ?? ""
        self.dateStart = try container.decodeIfPresent(String.self, forKey: .dateStart) ?? ""
        self.established = try container.decodeIfPresent(String.self, forKey: .established) ?? ""
        self.facebookPage = try container.decodeIfPresent(String.self, forKey: .facebookPage) ?? ""
        self.festivalDescription = try container.decodeIfPresent(String.self, forKey: .festivalDescription) ?? ""
        self.festivalMapImage = try container.decodeIfPresent(String.self, forKey: .festivalMapImage) ?? ""
        self.instagramHandle = try container.decodeIfPresent(String.self, forKey: .instagramHandle) ?? ""
        self.locationMapLink = try container.decodeIfPresent(String.self, forKey: .locationMapLink) ?? ""
        self.logoImage = try container.decodeIfPresent(String.self, forKey: .logoImage) ?? ""
        self.lostAndFound = try container.decodeIfPresent(String.self, forKey: .lostAndFound) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode) ?? ""
        self.state = try container.decodeIfPresent(String.self, forKey: .state) ?? ""
        self.tickets = try container.decodeIfPresent(String.self, forKey: .tickets) ?? ""
        self.timeEnd = try container.decodeIfPresent(String.self, forKey: .timeEnd) ?? ""
        self.timeStart = try container.decodeIfPresent(String.self, forKey: .timeStart) ?? ""
        self.website = try container.decodeIfPresent(String.self, forKey: .website) ?? ""
        self.xHandle = try container.decodeIfPresent(String.self, forKey: .xHandle) ?? ""
        self.youTubeChannel = try container.decodeIfPresent(String.self, forKey: .youTubeChannel) ?? ""
        self.coordinates = try container.decodeIfPresent(GeoPoint.self, forKey: .coordinates) ?? nil
    }

    init() {}
    
    // Implementation of Hashable protocol
     func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }

     static func == (lhs: FestivalModel, rhs: FestivalModel) -> Bool {
         return lhs.id == rhs.id
     }
}

// Extension to provide a sample instance of FestivalModel for use in SwiftUI previews and testing.
extension FestivalModel {
    static var sample: FestivalModel {
        var festival = FestivalModel()
        festival.id = "trf"
        festival.address = "21778 FM 1774"
        festival.campgroundMapImage = "TRFCampgroundMap"
        festival.city = "Todd Mission"
        festival.contactEmail = "info@texrenfest.com"
        festival.contactPhone = "1234567890"
        festival.dateEnd = "12/17/2024"
        festival.dateStart = "10/10/2024"
        festival.established = "1974"
        festival.facebookPage = "texrenfest"
        festival.festivalDescription = "The Texas Renaissance Festival is an annual Renaissance fair located in Todd Mission, Texas."
        festival.festivalMapImage = "TRFFestivalMap"
        festival.instagramHandle = "texrenfest"
        festival.locationMapLink = "https://maps.google.com"
        festival.logoImage = "TRFLogo"
        festival.lostAndFound = "https://www.texrenfest.com/lost-and-found"
        festival.name = "Texas Renaissance Festival"
        festival.postalCode = "77363"
        festival.state = "Texas"
        festival.tickets = "https://www.texrenfest.com/tickets"
        festival.timeEnd = "2000"
        festival.timeStart = "0900"
        festival.website = "https://www.texrenfest.com"
        festival.xHandle = "texrenfest"
        festival.youTubeChannel = "@texasrenaissancefestival3257"
        return festival
    }
}
