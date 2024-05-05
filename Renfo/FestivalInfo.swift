import Foundation

// Define the properties of each festival
struct FestivalInfo {
    var name: String
    var description: String
    var logoImageName: String
    var phoneNumber: String
    var email: String
    var mapLink: String
    var websiteURL: String
    var ticketsURL: String
    var festivalMapImageName: String
    var campgroundMapImageName: String
    var lostAndFoundURL: String
    var activeMonths: [String]
    var street: String
    var city: String
    var state: String
    var stateShort: String
    var zip: String
}

// Create instances of FestivalInfo for each festival
let texasRenaissanceFestival = FestivalInfo(
    name: "Texas Renaissance Festival",
    description: "A grand celebration of medieval culture.",
    logoImageName: "TRFLogo",
    phoneNumber: "800-458-3435",
    email: "info@texrenfest.com",
    mapLink: "https://maps.apple.com/?q=Texas+Renaissance+Festival",
    websiteURL: "https://www.texrenfest.com",
    ticketsURL: "https://www.texrenfest.com/tickets",
    festivalMapImageName: "TRFFestivalMap",
    campgroundMapImageName: "TRFCampgroundMap",
    lostAndFoundURL: "https://www.texrenfest.com/lost-and-found",
    activeMonths: ["Oct", "Nov", "Dec"],
    street: "21778 FM 1774",
    city: "Todd Mission",
    state: "Texas",
    stateShort: "TX",
    zip: "77363"
)

let sherwoodForestFaire = FestivalInfo(
    name: "Sherwood Forest Faire",
    description: "Witness the thrilling sport of kings.",
    logoImageName: "SFFLogo",
    phoneNumber: "512-222-6680",
    email: "info@sherwoodforestfaire.com",
    mapLink: "https://maps.apple.com/?q=Sherwood+Forest+Faire",
    websiteURL: "https://www.sherwoodforestfaire.com",
    ticketsURL: "https://www.etix.com/ticket/v/12633/sherwood-forest-faire?cobrand=SherwoodForest",
    festivalMapImageName: "SFFFestivalMap",
    campgroundMapImageName: "SFFCampgroundMap",
    lostAndFoundURL: "https://docs.google.com/forms/d/e/1FAIpQLSfjtw__EmEXitzdBxUeoHEzXZOWcDJ4iBAzotlq8podyhe9AQ/viewform?fbclid=IwAR2UOFTry3PYHK-uevjDgaijKchnpfctJKWWGZC3rTnWcwVHKSxotq0W-dw_aem_ASwbpiQpCOwKBpjyMCjJR6_YL6afxNXs_uMhMXn_jwOjofyWRy44pXSwA93blZyT7qk",
    activeMonths: ["Mar", "Apr"],
    street: "1883 Old Hwy 20",
    city: "McDade",
    state: "Texas",
    stateShort: "TX",
    zip: "78650"
)

let scarboroughRenaissanceFestival = FestivalInfo(
    name: "Scarborough Renaissance Festival",
    description: "A grand celebration of medieval culture.",
    logoImageName: "SRFLogo",
    phoneNumber: "972-938-3247",
    email: "marketing@srfestival.com",
    mapLink: "https://maps.apple.com/?q=Scarborough+Renaissance+Festival",
    websiteURL: "https://www.srfestival.com/",
    ticketsURL: "https://secure.interactiveticketing.com/1.41/a03bb7/#/select",
    festivalMapImageName: "SRFFestivalMap",
    campgroundMapImageName: "SRFCampgroundMap",
    lostAndFoundURL: "https://www.srfestival.com/",
    activeMonths: ["Apr", "May"],
    street: "2511 FM 66",
    city: "Waxahachie",
    state: "Texas",
    stateShort: "TX",
    zip: "75167"
)

let marylandRenaissanceFestival = FestivalInfo(
    name: "Maryland Renaissance Festival",
    description: "A grand celebration of medieval culture.",
    logoImageName: "MDRFLogo",
    phoneNumber: "410-266-7304",
    email: "info@rennfest.com",
    mapLink: "https://maps.apple.com/?q=Maryland+Renaissance+Festival",
    websiteURL: "https://www.rennfest.com/",
    ticketsURL: "https://rennfest.com/tickets/",
    festivalMapImageName: "MDRFFestivalMap",
    campgroundMapImageName: "MDRFCampgroundMap",
    lostAndFoundURL: "https://www.rennfest.com/",
    activeMonths: ["Aug", "Sep", "Oct"],
    street: "1821 Crownsville Rd",
    city: "Annapolis",
    state: "Maryland",
    stateShort: "MD",
    zip: "21401"
)

let renaissancePleasureFaire = FestivalInfo(
    name: "Renaissance Pleasure Faire",
    description: "A grand celebration of medieval culture.",
    logoImageName: "RPFLogo",
    phoneNumber: "626-969-4750",
    email: "reception@renfair.com",
    mapLink: "https://maps.apple.com/?q=Renaissance+Pleasure+Faire",
    websiteURL: "https://www.renfair.com/socal/",
    ticketsURL: "https://renfair.com/socal/tickets/",
    festivalMapImageName: "RPFFestivalMap",
    campgroundMapImageName: "RPFCampgroundMap",
    lostAndFoundURL: "https://www.renfair.com/socal/",
    activeMonths: ["Apr", "May"],
    street: "15501 E. Arrow Highway",
    city: "Irwindale",
    state: "California",
    stateShort: "CA",
    zip: "91722"
)

let louisianaRenaissanceFestival = FestivalInfo(
    name: "Louisiana Renaissance Festival",
    description: "A grand celebration of medieval culture.",
    logoImageName: "LRFLogo",
    phoneNumber: "985-507-5442",
    email: "info@larf.org.com",
    mapLink: "https://maps.apple.com/?q=Louisiana+Renaissance+Festival",
    websiteURL: "https://www.larf2023.org/",
    ticketsURL: "https://www.larf2023.org/",
    festivalMapImageName: "LRFFestivalMap",
    campgroundMapImageName: "LRFCampgroundMap",
    lostAndFoundURL: "https://www.larf2023.org/",
    activeMonths: ["Nov", "Dec"],
    street: "46468 River Rd",
    city: "Hammond",
    state: "Louisiana",
    stateShort: "LA",
    zip: "70401"
)

let northernCaliforniaRenaissanceFaire = FestivalInfo(
    name: "Northern California Renaissance Faire",
    description: "A grand celebration of medieval culture.",
    logoImageName: "NCRFLogo",
    phoneNumber: "111-111-1111",
    email: "entertainment@norcalrenfaire.com",
    mapLink: "https://maps.apple.com/?q=Northern+California+Renaissance+Faire",
    websiteURL: "https://norcalrenfaire.com/",
    ticketsURL: "https://norcalrenfaire.com/tickets/",
    festivalMapImageName: "NCRFFestivalMap",
    campgroundMapImageName: "NCRFCampgroundMap",
    lostAndFoundURL: "https://www.larf2023.org/",
    activeMonths: ["Sep", "Oct"],
    street: "10031 Pacheco Pass Hwy 152",
    city: "Hollister",
    state: "California",
    stateShort: "CA",
    zip: "95023"
)

// Add more festivals as needed
