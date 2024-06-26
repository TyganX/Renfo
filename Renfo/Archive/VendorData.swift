import Foundation

// Define the properties of each vendor
struct VendorData {
    var name: String
    var description: String
    var logoImageName: String
    var phoneNumber: String
    var email: String
    var mapLink: String
    var websiteURL: String
    var facebook: String
    var instagram: String
    var x: String
    var festivalIDs: [String]
}

// Create instances of VendorData for each vendor
let trfDragonSlayer = VendorData(
    name: "TRF DragonSlayer",
    description: "Making History Fashionable",
    logoImageName: "TRFDragonSlayerLogo",
    phoneNumber: "",
    email: "sales@trfdragonslayer.com",
    mapLink: "https://maps.apple.com/?q=TRF+DragonSlayer",
    websiteURL: "http://www.trfdragonslayer.com/",
    facebook: "TRFDragonSlayer",
    instagram: "",
    x: "",
    festivalIDs: ["TRF", "SFF"]
)

// Add more vendors as needed
