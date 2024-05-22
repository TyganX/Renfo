import Foundation
import FirebaseFirestoreSwift

struct FestivalModel: Codable, Identifiable {
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

    // Custom decoding to handle missing fields
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
    }

    init() {}
}
