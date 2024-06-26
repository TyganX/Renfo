import SwiftUI
import UIKit

// MARK: - Festival View
struct FestivalView1: View {
    @AppStorage("appColor") var appColor: AppColor = .default
    @State private var showingPopover = false
    @ObservedObject var viewModel: FestivalViewModel

    // Create an instance of UIImpactFeedbackGenerator
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        ScrollView {
            VStack {
                headerSection
                bodySection
            }
        }
        .navigationTitle(viewModel.festival.id?.isEmpty == false ? viewModel.festival.id!.uppercased() : "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: favoriteButton)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.festival.established.isEmpty ? "" : "Est. \(viewModel.festival.established)")
                    .foregroundColor(.white)
            }
        }
        .accentColor(appColor.color)
    }

    // MARK: - Favorite Button
    private var favoriteButton: some View {
        Button(action: {
            impactFeedbackGenerator.impactOccurred() // Trigger haptic feedback
            viewModel.toggleFavorite()
        }) {
            Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                .foregroundColor(viewModel.isFavorite ? .yellow : .gray)
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack {
            ZStack {
                VStack(alignment: .center, spacing: 0) {
                    if let logoImage = viewModel.logoImage {
                        Image(uiImage: logoImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    
                    GeometryReader { geo in
                        let minY = geo.frame(in: .global).minY
                        VStack {
                            Text(viewModel.festival.name)
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.bottom, 9)
                                .foregroundColor(.white)
                            
                            headerButtons
                        }
                        .frame(maxWidth: .infinity)
                        .offset(y: max(60 - minY, 0))
                    }
                    .padding(.horizontal)
                    .offset(y: 0)
                    .zIndex(1)
                }
            }
            .frame(height: 300)
            .frame(maxWidth: .infinity)
        }
        .background(.ultraThinMaterial)
    }

    // MARK: - Header Buttons
    private var headerButtons: some View {
        HStack {
            ForEach(buttonConfigs, id: \.label) { config in
                createButton(config: config)
            }
        }
    }

    private func createButton(config: ButtonConfig) -> some View {
        Button(action: config.action) {
            VStack {
                Image(systemName: config.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical, config.verticalPadding)
                Text(config.label)
                    .font(.caption2)
                    .fontWeight(.semibold)
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
        }
        .buttonStyle(.bordered)
    }

    // MARK: - Button Configurations
    private var buttonConfigs: [ButtonConfig] {
        [
            ButtonConfig(
                action: {
                    let phoneNumber = viewModel.festival.contactPhone
                    let telephone = "tel://"
                    let formattedNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
                    if let url = URL(string: "\(telephone)\(formattedNumber)") {
                        UIApplication.shared.open(url)
                    }
                },
                imageName: "phone.fill",
                label: "Call",
                verticalPadding: 2
            ),
            ButtonConfig(
                action: {
                    let email = viewModel.festival.contactEmail
                    let mailto = "mailto:\(email)"
                    if let url = URL(string: mailto) {
                        UIApplication.shared.open(url)
                    }
                },
                imageName: "envelope.fill",
                label: "Mail",
                verticalPadding: 3
            ),
            ButtonConfig(
                action: {
                    let mapLink = viewModel.festival.locationMapLink
                    if let url = URL(string: mapLink) {
                        UIApplication.shared.open(url)
                    }
                },
                imageName: "arrow.triangle.turn.up.right.circle.fill",
                label: "Directions",
                verticalPadding: 1
            ),
            ButtonConfig(
                action: {
                    let website = viewModel.festival.website
                    if let url = URL(string: website) {
                        UIApplication.shared.open(url)
                    }
                },
                imageName: "safari.fill",
                label: "Website",
                verticalPadding: 1
            )
        ]
    }

    // MARK: - Body Section
    private var bodySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !viewModel.detailsLinks.isEmpty {
                Section(header: Text("Details")) {
                    ForEach(viewModel.detailsLinks, id: \.key) { link in
                        HStack {
                            Label {
                                Text(link.value.text)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: link.value.systemImage)
                                    .foregroundColor(nil)
                            }
                            Spacer()
                            if link.key == "dates" {
                                ActiveIndicator(isActive: link.value.isActive, daysUntilStart: link.value.daysUntilStart)
                            }
                        }
                    }
                }
            }
            if !viewModel.resourceLinks.isEmpty {
                Section(header: Text("Resources")) {
                    ForEach(viewModel.resourceLinks, id: \.key) { link in
                        link.value.view()
                    }
                }
            }
            if !viewModel.socialLinks.isEmpty {
                Section(header: Text("Social")) {
                    ForEach(viewModel.socialLinks.keys.sorted(), id: \.self) { key in
                        let link = viewModel.socialLinks[key]!
                        URLButtonCustom(label: link.label, image: Image(link.systemImage), urlString: "https://www.\(key).com/\(link.url)")
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

//// MARK: - Button Config Struct
//struct ButtonConfig {
//    let action: () -> Void
//    let imageName: String
//    let label: String
//    let verticalPadding: CGFloat
//}
//
//// MARK: - Active Indicator
//struct ActiveIndicator: View {
//    let isActive: Bool
//    let daysUntilStart: Int?
//
//    var body: some View {
//        HStack {
//            if isActive {
//                PulsingView()
//                    .foregroundColor(.green)
//                    .frame(width: 10, height: 10)
//            } else {
//                ZStack {
//                    Circle()
//                        .fill(Color.red)
//                        .frame(width: 20, height: 20)
//                    Text(daysUntilStart ?? 0 >= 0 ? "\(daysUntilStart!)" : "?")
//                        .font(.system(size: 9))
//                        .fontWeight(.bold)
//                        .foregroundColor(.white)
//                }
//            }
//        }
//    }
//}

// MARK: - Preview Provider
struct FestivalView1_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FestivalView1(viewModel: FestivalViewModel(festival: .sample))
        }
    }
}
