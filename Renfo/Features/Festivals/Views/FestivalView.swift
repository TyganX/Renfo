import SwiftUI
import MapKit

struct FestivalView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @ObservedObject var viewModel: FestivalViewModel
    
    @State private var logoImage: UIImage? = nil
    @State private var scrollOffset: CGFloat = 0
    @State private var copiedToClipboard = false
    @State private var isEditing = false
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        VStack {
            List {
                bodySection
                establishedBanner
                missingInformation
            }
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                return geometry.contentOffset.y
            } action: { oldValue, newValue in
                scrollOffset = newValue
//                print("Scroll Offset: \(scrollOffset)") // Debugging print statement
            }
        }
        .scrollIndicators(.hidden)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarItems(trailing: favoriteButton)
        .navigationBarItems(trailing: editButton)
        .safeAreaInset(edge: .top) {
            headerSection
        }
        .edgesIgnoringSafeArea(.top)
        .overlay {
            if copiedToClipboard {
                Text("Copied to Clipboard")
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.bottom)
                    .shadow(radius: 5)
                    .transition(.move(edge: .bottom))
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack {
            Group {
                Image(uiImage: viewModel.logoImage ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: 200 + (40 - 200) * ((min(max(scrollOffset, -419), -220) + 419) / 199),
                        height: 200 + (40 - 200) * ((min(max(scrollOffset, -419), -220) + 419) / 199)
                    )
                    .clipShape(Circle())
                    .redacted(reason: viewModel.logoImage == nil ? .placeholder : [])
            }
            .frame(height: 200, alignment: .bottom)
            
            Group {
                Text(viewModel.festival.name)
                    .foregroundColor(.white)
                    .fontDesign(.rounded)
                    .fontWeight(.bold)
                    .font(.system(size: 20 + (15 - 20) * ((min(max(scrollOffset, -419), -220) + 419) / 199)))
                    .minimumScaleFactor(0.5) // Allows text to scale down
                    .lineLimit(1) // Ensures text stays on one line
            }
            .frame(height: 30)
            
            headerButtons
        }
        .padding(.horizontal)
        .padding(.bottom)
        .padding(.top, 95)
        .background(MeshgradientAnimation()
            .overlay(.ultraThinMaterial)
        )
//        .background(Image(uiImage: viewModel.logoImage ?? UIImage())
//            .resizable()
//            .scaledToFit()
//            .blur(radius: 50)
//            .overlay(.ultraThinMaterial)
//        )
//        .background(RadialGradient(gradient: Gradient(colors: [.orange, .red]), center: .center, startRadius: 100, endRadius: 300)
//        )
//        .background(LinearGradient(colors: [.green.opacity(0.3), .blue.opacity(0.5)], startPoint: .top, endPoint: .bottom)
//            .overlay(.ultraThinMaterial)
//        )
//        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay(
            Rectangle()
                .stroke(.ultraThinMaterial, lineWidth: 1)
        )
        .offset(y: min(0, max(-420 - scrollOffset, -200)))
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
                    .fontDesign(.rounded)
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
    
    // MARK: - Edit Button
    private var editButton: some View {
        Button(action: {
            isEditing.toggle()
        }) {
            Image(systemName: isEditing ? "checkmark" : "pencil")
//                .foregroundColor(viewModel.isFavorite ? .yellow : .gray)
        }
    }
    
//    private var isCurrentUserMe: Bool {
//        return sessionStore.userEmail == "Tyler@Keegan.pro"
//    }
    
    // MARK: - Body Section
    private var bodySection: some View {
        Group {
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
            
            addressSection
            
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
                        SocialButton(label: link.label, image: Image(link.systemImage), handle: link.url, urlString: "https://www.\(key).com/\(link.url)")
                    }
                }
            }
            mapSection
        }
        .fontDesign(.rounded)
    }
    
    // MARK: - Address Section
    private var addressSection: some View {
        Section {
            // Address
            HStack {
                Label {
                    Text(viewModel.festival.address)
                        .font(.body)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "")
                        .foregroundColor(nil)
                }
                Spacer()
            }
            
            // City, State, ZIP
            HStack {
                Label {
                    Text("\(viewModel.festival.city), \(stateAbbreviations[viewModel.festival.state] ?? viewModel.festival.state) \(viewModel.festival.postalCode)")
                        .font(.body)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "location")
                        .foregroundColor(nil)
                }
                Spacer()
            }
            
            // Country
            HStack {
                Label {
                    Text("United States")
                        .font(.body)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "")
                        .foregroundColor(nil)
                }
                Spacer()
            }
        }
        .onTapGesture {
            impactFeedbackGenerator.impactOccurred()
            
            // Construct the full address
            let fullAddress = """
            \(viewModel.festival.address)
            \(viewModel.festival.city), \(stateAbbreviations[viewModel.festival.state] ?? viewModel.festival.state) \(viewModel.festival.postalCode)
            United States
            """
            
            UIPasteboard.general.string = fullAddress
            
            withAnimation(.snappy) {
                copiedToClipboard = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.snappy) {
                    copiedToClipboard = false
                }
            }
        }
    }
    
    // MARK: - Map Section
    private var mapSection: some View {
        Section {
            if let geoPoint = viewModel.festival.coordinates {
                MapSnapshot(coordinate: CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude))
                    .frame(height: 150)
                    .listRowInsets(EdgeInsets())
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(.ultraThinMaterial, lineWidth: 1)
                    )
            }
        }
    }
    
    // MARK: - Established Banner
    private var establishedBanner: some View {
        Group {
            if !viewModel.festival.established.isEmpty {
                HStack {
                    Spacer()
                    Image(systemName: "laurel.leading")
                        .font(.system(size: 30))
                    Text("Est. \(viewModel.festival.established)")
                    Image(systemName: "laurel.trailing")
                        .font(.system(size: 30))
                    Spacer()
                }
                .foregroundStyle(.secondary)
                .fontWeight(.bold)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
    }
    
    // MARK: - Missing Information
    private var missingInformation: some View {
        HStack {
            Text("Missing information?")
            Text("Let us know!")
                .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
    }
}

// MARK: - Button Config Struct
struct ButtonConfig {
    let action: () -> Void
    let imageName: String
    let label: String
    let verticalPadding: CGFloat
}

// MARK: - Preview Provider
#Preview {
    NavigationStack {
        FestivalView(viewModel: FestivalViewModel(festival: .sample))
    }
}
