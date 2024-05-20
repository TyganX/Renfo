import Foundation

// Define the properties of each festival
struct FestivalData {
    var name: String
    var description: String
    var logoImageName: String
    var established: String
    var phoneNumber: String
    var email: String
    var mapLink: String
    var websiteURL: String
    var ticketsURL: String
    var festivalMapImageName: String
    var campgroundMapImageName: String
    var lostAndFoundURL: String
    var activeMonths: [String]
    var startDate: String
    var endDate: String
    var startTime: String
    var endTime: String
    var street: String
    var city: String
    var state: String
    var stateShort: String
    var zip: String
    var facebook: String
    var instagram: String
    var x: String
    var youTube: String
}

// Create instances of FestivalInfo for each festival
let texasRenaissanceFestival = FestivalData(
    name: "Texas Renaissance Festival",
    description: "A grand celebration of medieval culture.",
    logoImageName: "TRFLogo",
    established: "1974",
    phoneNumber: "800-458-3435",
    email: "info@texrenfest.com",
    mapLink: "https://maps.apple.com/?q=Texas+Renaissance+Festival",
    websiteURL: "https://www.texrenfest.com",
    ticketsURL: "https://www.texrenfest.com/tickets",
    festivalMapImageName: "TRFFestivalMap",
    campgroundMapImageName: "TRFCampgroundMap",
    lostAndFoundURL: "https://www.texrenfest.com/lost-and-found",
    activeMonths: ["Oct", "Nov", "Dec"],
    startDate: "10/12/2024",
    endDate: "12/01/2024",
    startTime: "0900",
    endTime: "2000",
    street: "21778 FM 1774",
    city: "Todd Mission",
    state: "Texas",
    stateShort: "TX",
    zip: "77363",
    facebook: "texrenfest",
    instagram: "texrenfest",
    x: "texrenfest",
    youTube: "@texasrenaissancefestival3257"
)

let sherwoodForestFaire = FestivalData(
    name: "Sherwood Forest Faire",
    description: "Witness the thrilling sport of kings.",
    logoImageName: "SFFLogo",
    established: "2010",
    phoneNumber: "512-222-6680",
    email: "info@sherwoodforestfaire.com",
    mapLink: "https://maps.apple.com/?q=Sherwood+Forest+Faire",
    websiteURL: "https://www.sherwoodforestfaire.com",
    ticketsURL: "https://www.etix.com/ticket/v/12633/sherwood-forest-faire?cobrand=SherwoodForest",
    festivalMapImageName: "SFFFestivalMap",
    campgroundMapImageName: "SFFCampgroundMap",
    lostAndFoundURL: "https://docs.google.com/forms/d/e/1FAIpQLSfjtw__EmEXitzdBxUeoHEzXZOWcDJ4iBAzotlq8podyhe9AQ/viewform?fbclid=IwAR2UOFTry3PYHK-uevjDgaijKchnpfctJKWWGZC3rTnWcwVHKSxotq0W-dw_aem_ASwbpiQpCOwKBpjyMCjJR6_YL6afxNXs_uMhMXn_jwOjofyWRy44pXSwA93blZyT7qk",
    activeMonths: ["Mar", "Apr"],
    startDate: "03/01/2025",
    endDate: "04/20/2025",
    startTime: "1000",
    endTime: "1900",
    street: "1883 Old Hwy 20",
    city: "McDade",
    state: "Texas",
    stateShort: "TX",
    zip: "78650",
    facebook: "sherwoodforestfaire",
    instagram: "sherwoodforestfaire",
    x: "sherwoodfaire",
    youTube: "@SherwoodForestFaire1189"
)

let scarboroughRenaissanceFestival = FestivalData(
    name: "Scarborough Renaissance Festival",
    description: "A grand celebration of medieval culture.",
    logoImageName: "SRFLogo",
    established: "1981",
    phoneNumber: "972-938-3247",
    email: "marketing@srfestival.com",
    mapLink: "https://maps.apple.com/?q=Scarborough+Renaissance+Festival",
    websiteURL: "https://www.srfestival.com/",
    ticketsURL: "https://secure.interactiveticketing.com/1.41/a03bb7/#/select",
    festivalMapImageName: "SRFFestivalMap",
    campgroundMapImageName: "",
    lostAndFoundURL: "",
    activeMonths: ["Apr", "May"],
    startDate: "04/06/2024",
    endDate: "05/27/2024",
    startTime: "1000",
    endTime: "1900",
    street: "2511 FM 66",
    city: "Waxahachie",
    state: "Texas",
    stateShort: "TX",
    zip: "75167",
    facebook: "SRFestival",
    instagram: "theSRFestival",
    x: "srfestival",
    youTube: "@srfestival"
)

let marylandRenaissanceFestival = FestivalData(
    name: "Maryland Renaissance Festival",
    description: "A grand celebration of medieval culture.",
    logoImageName: "MDRFLogo",
    established: "1977",
    phoneNumber: "410-266-7304",
    email: "info@rennfest.com",
    mapLink: "https://maps.apple.com/?q=Maryland+Renaissance+Festival",
    websiteURL: "https://www.rennfest.com/",
    ticketsURL: "https://rennfest.com/tickets/",
    festivalMapImageName: "MDRFFestivalMap",
    campgroundMapImageName: "",
    lostAndFoundURL: "",
    activeMonths: ["Aug", "Sep", "Oct"],
    startDate: "08/24/2024",
    endDate: "10/20/2024",
    startTime: "1000",
    endTime: "1900",
    street: "1821 Crownsville Rd",
    city: "Annapolis",
    state: "Maryland",
    stateShort: "MD",
    zip: "21401",
    facebook: "mdrenfest",
    instagram: "",
    x: "mdrenfest",
    youTube: ""
)

let renaissancePleasureFaire = FestivalData(
    name: "Renaissance Pleasure Faire",
    description: "A grand celebration of medieval culture.",
    logoImageName: "RPFLogo",
    established: "1962",
    phoneNumber: "626-969-4750",
    email: "reception@renfair.com",
    mapLink: "https://maps.apple.com/?q=Renaissance+Pleasure+Faire",
    websiteURL: "https://www.renfair.com/socal/",
    ticketsURL: "https://renfair.com/socal/tickets/",
    festivalMapImageName: "RPFFestivalMap",
    campgroundMapImageName: "",
    lostAndFoundURL: "",
    activeMonths: ["Apr", "May"],
    startDate: "04/06/2024",
    endDate: "05/19/2024",
    startTime: "1000",
    endTime: "1900",
    street: "15501 E. Arrow Highway",
    city: "Irwindale",
    state: "California",
    stateShort: "CA",
    zip: "91722",
    facebook: "socal.ren.faire",
    instagram: "renaissancepleasurefaire",
    x: "socal_ren_faire",
    youTube: ""
)

let louisianaRenaissanceFestival = FestivalData(
    name: "Louisiana Renaissance Festival",
    description: "A grand celebration of medieval culture.",
    logoImageName: "LRFLogo",
    established: "2000",
    phoneNumber: "985-507-5442",
    email: "info@larf.org.com",
    mapLink: "https://maps.apple.com/?q=Louisiana+Renaissance+Festival",
    websiteURL: "https://www.larf.org/",
    ticketsURL: "",
    festivalMapImageName: "LRFFestivalMap",
    campgroundMapImageName: "",
    lostAndFoundURL: "",
    activeMonths: ["Nov", "Dec"],
    startDate: "11/02/2024",
    endDate: "12/08/2024",
    startTime: "0945",
    endTime: "1700",
    street: "46468 River Rd",
    city: "Hammond",
    state: "Louisiana",
    stateShort: "LA",
    zip: "70401",
    facebook: "RenFest.net",
    instagram: "larenfest",
    x: "LARenFest",
    youTube: "@louisianarenaissancefestiv5481"
)

let northernCaliforniaRenaissanceFaire = FestivalData(
    name: "Northern California Renaissance Faire",
    description: "A grand celebration of medieval culture.",
    logoImageName: "NCRFLogo",
    established: "2004",
    phoneNumber: "",
    email: "entertainment@norcalrenfaire.com",
    mapLink: "https://maps.apple.com/?q=Northern+California+Renaissance+Faire",
    websiteURL: "https://norcalrenfaire.com/",
    ticketsURL: "https://norcalrenfaire.com/tickets/",
    festivalMapImageName: "NCRFFestivalMap",
    campgroundMapImageName: "",
    lostAndFoundURL: "",
    activeMonths: ["Sep", "Oct"],
    startDate: "09/14/2024",
    endDate: "10/20/2024",
    startTime: "1000",
    endTime: "1800",
    street: "10031 Pacheco Pass Hwy 152",
    city: "Hollister",
    state: "California",
    stateShort: "CA",
    zip: "95023",
    facebook: "norcalrenfaire",
    instagram: "norcalrenfaire",
    x: "norcalrenfaire",
    youTube: ""
)

// Add more festivals as needed
