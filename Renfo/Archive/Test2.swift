import SwiftUI

struct NavBar1: View {
    @ObservedObject var viewModel: FestivalViewModel
    
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        VStack {
            List {
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
//            .navigationBarHidden(true)
            .toolbarBackground(.hidden, for: .navigationBar)
//            .toolbar {
//                favoriteButton
//            }
            .navigationBarItems(trailing: favoriteButton)
//            .overlay(alignment: .top) {
            .safeAreaInset(edge: .top) {
                headerSection
//                .background(.ultraThinMaterial)
                .background(LinearGradient(colors: [.green.opacity(0.3), .blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .overlay(.ultraThinMaterial)
                )
                .padding(.top, 55)
            }
            .ignoresSafeArea(edges: .top)
        }
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
        Section {
            ZStack {
//                ParticleView()
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
                            .clipShape(Circle())
                            .redacted(reason: viewModel.logoImage == nil ? .placeholder : [])
                    }
                    
                    Text(viewModel.festival.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.bottom, 9)
                        .foregroundColor(.white)
                    
                    headerButtons
                }
            }
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .listRowInsets(EdgeInsets())
            .padding(.horizontal)
        }
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
                    viewModel.openLocationInAppleMaps()
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
}

// MARK: - Preview Provider
struct NavBar1_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NavBar1(viewModel: FestivalViewModel(festival: .sample))
        }
    }
}
