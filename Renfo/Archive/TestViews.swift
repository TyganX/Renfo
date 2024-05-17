//import SwiftUI
//
//struct FestivalResourcesView: View {
//    var festival: FestivalData
//    
//    var body: some View {
//        Form {
//            if !resourceLinks.isEmpty {
//                Section(header: Text("Resources")) {
//                    ForEach(resourceLinks, id: \.key) { link in
//                        link.value.view()
//                    }
//                }
//            }
//            
//            let socialLinks: [String: (label: String, systemImage: String, url: String)] = [
//                "facebook": ("Facebook", "facebook", festival.facebook),
//                "instagram": ("Instagram", "instagram", festival.instagram),
//                "x": ("𝕏", "x", festival.x),
//                "youTube": ("YouTube", "youtube.fill", festival.youTube)
//            ]
//
//            let nonEmptySocialLinks = socialLinks.filter { !$1.url.isEmpty }
//
//            if !nonEmptySocialLinks.isEmpty {
//                Section(header: Text("Social")) {
//                    ForEach(nonEmptySocialLinks.keys.sorted(), id: \.self) { key in
//                        let link = nonEmptySocialLinks[key]!
//                        URLButtonCustom(label: link.label, image: Image(link.systemImage), urlString: "https://www.\(key).com/\(link.url)")
//                    }
//                }
//            }
//        }
//    }
//    
//    // MARK: - Resource Links
//    private var resourceLinks: [(key: String, value: (label: String, systemImage: String, view: () -> AnyView))] {
//        let links: [(key: String, value: (label: String, systemImage: String, view: () -> AnyView))] = [
//            ("festivalMapImageName", ("Festival Map", "map.fill", {
//                if !festival.festivalMapImageName.isEmpty {
//                    return AnyView(NavigationLink(destination: ImageView(imageName: festival.festivalMapImageName)) {
//                        Label("Festival Map", systemImage: "map.fill")
//                    })
//                } else {
//                    return AnyView(
//                        Label("Festival Map (No Image)", systemImage: "map.fill")
//                            .foregroundColor(.gray)
//                    )
//                }
//            })),
//            ("campgroundMapImageName", ("Campground Map", "map.circle.fill", {
//                if !festival.campgroundMapImageName.isEmpty {
//                    return AnyView(NavigationLink(destination: ImageView(imageName: festival.campgroundMapImageName)) {
//                        Label("Campground Map", systemImage: "map.circle.fill")
//                    })
//                } else {
//                    return AnyView(
//                        Label("Campground Map (No Image)", systemImage: "map.circle.fill")
//                            .foregroundColor(.gray)
//                    )
//                }
//            })),
//            ("ticketsURL", ("Tickets", "ticket.fill", {
//                if !festival.ticketsURL.isEmpty {
//                    return AnyView(URLButtonInApp(label: "Tickets", systemImage: "ticket.fill", urlString: festival.ticketsURL))
//                } else {
//                    return AnyView(
//                        Label("Tickets (No URL)", systemImage: "ticket.fill")
//                            .foregroundColor(.gray)
//                    )
//                }
//            })),
//            ("lostAndFoundURL", ("Lost & Found", "questionmark.app.fill", {
//                if !festival.lostAndFoundURL.isEmpty {
//                    return AnyView(URLButtonInApp(label: "Lost & Found", systemImage: "questionmark.app.fill", urlString: festival.lostAndFoundURL))
//                } else {
//                    return AnyView(
//                        Label("Lost & Found (No URL)", systemImage: "questionmark.app.fill")
//                            .foregroundColor(.gray)
//                    )
//                }
//            }))
//        ]
//        return links.filter { !$0.key.isEmpty }
//    }
//}
//
//struct FestivalResourcesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FestivalResourcesView(festival: texasRenaissanceFestival)
//    }
//}
