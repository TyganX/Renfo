import Foundation
import FirebaseFirestoreSwift

struct VendorModel: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString // Ensure that this is unique
    var festivalIDs: [String] = [] // Array to link the vendor to multiple festivals
    var name: String = ""
    var description: String = ""
    var logoImage: String = ""
    var contactPhone: String = ""
    var contactEmail: String = ""
    var website: String = ""
    var facebookPage: String = ""
    var instagramHandle: String = ""
    var xHandle: String = ""
    var youTubeChannel: String = ""

    // Custom decoding to handle missing fields
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.festivalIDs = try container.decodeIfPresent([String].self, forKey: .festivalIDs) ?? []
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.logoImage = try container.decodeIfPresent(String.self, forKey: .logoImage) ?? ""
        self.contactPhone = try container.decodeIfPresent(String.self, forKey: .contactPhone) ?? ""
        self.contactEmail = try container.decodeIfPresent(String.self, forKey: .contactEmail) ?? ""
        self.website = try container.decodeIfPresent(String.self, forKey: .website) ?? ""
        self.facebookPage = try container.decodeIfPresent(String.self, forKey: .facebookPage) ?? ""
        self.instagramHandle = try container.decodeIfPresent(String.self, forKey: .instagramHandle) ?? ""
        self.xHandle = try container.decodeIfPresent(String.self, forKey: .xHandle) ?? ""
        self.youTubeChannel = try container.decodeIfPresent(String.self, forKey: .youTubeChannel) ?? ""
    }

    // Default initializer
    init() {}
}
