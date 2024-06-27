import SwiftUI

@available(iOS 18.0, *)
struct FestivalView: View {
    @ObservedObject var viewModel: FestivalViewModel
    
    @State private var logoImage: UIImage? = nil
    @State private var scrollOffset: CGFloat = 0
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        VStack {
            List {
                bodySection
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
        .safeAreaInset(edge: .top) {
            headerSectionShrinkAnimation
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    // MARK: - Header Section Test | Shrink logo while scrolling
    private var headerSectionShrinkAnimation: some View {
        VStack {
            Group {
                Image(uiImage: viewModel.logoImage ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: max(40, min(200, -180 - scrollOffset)))
                    .frame(height: max(40, min(200, -180 - scrollOffset)))
                    .clipShape(Circle())
                    .redacted(reason: viewModel.logoImage == nil ? .placeholder : [])
            }
            .frame(height: 200, alignment: .bottom)
            
            Group {
                Text(viewModel.festival.name)
                    .foregroundColor(.white)
                    .fontDesign(.rounded)
                    .font(scrollOffset >= -220 ? .body: .title3)
                    .fontWeight(scrollOffset >= -220 ? .regular: .bold)
            }
            .frame(height: 30)
            
            headerButtons
        }
        .padding(.top, 95)
        .background(LinearGradient(colors: [.green.opacity(0.3), .blue.opacity(0.5)], startPoint: .top, endPoint: .bottom)
            .overlay(.ultraThinMaterial)
        )
        .offset(y: min(0, max(-420 - scrollOffset, -200)))
    }
    
    // MARK: - Header Section Test | Shrink logo while scrolling to give scroll effect (OLD)
    private var headerSectionShrinkToMove: some View {
        VStack {
            Image(uiImage: viewModel.logoImage ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(height: scrollOffset < -420 ? 200 : min(200, -200 - scrollOffset))
                .clipShape(Circle())
                .redacted(reason: viewModel.logoImage == nil ? .placeholder : [])
            
            Text(viewModel.festival.name)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            headerButtons
        }
        .background(.ultraThinMaterial)
        .padding(.top, 95)
    }
    
    // MARK: - Header Section Test | Shrink logo when scrolling far enough
    private var headerSectionShrink: some View {
        VStack {
            Group {
                Image(uiImage: viewModel.logoImage ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(width: scrollOffset >= -200 ? 40: 200, height: scrollOffset >= -200 ? 40: 200) // Shrink logo when scrolling far enough
                    .clipShape(Circle())
                    .redacted(reason: viewModel.logoImage == nil ? .placeholder : [])
            }
            .frame(height: 200, alignment: .bottom)
            
            Group {
                Text(viewModel.festival.name)
                    .foregroundColor(.white)
                    .font(scrollOffset >= -200 ? .body: .title3)
                    .fontWeight(scrollOffset >= -200 ? .regular: .bold)
            }
            .frame(height: 30)
            
            headerButtons
        }
        .padding(.top, 95)
        .background(LinearGradient(colors: [.green.opacity(0.3), .blue.opacity(0.5)], startPoint: .top, endPoint: .bottom)
            .overlay(.ultraThinMaterial)
        )
//        .background(.ultraThinMaterial)
        .offset(y: max(-420 - scrollOffset, -200))
    }
    
    // MARK: - Header Section Test | Hide logo when scrolling far enough
    private var headerSectionHide: some View {
        VStack {
            Image(uiImage: viewModel.logoImage ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .offset(y: scrollOffset >= -220 ? -100: 0) // Hide logo when scrolling far enough
                .redacted(reason: viewModel.logoImage == nil ? .placeholder : [])
            
            Text(viewModel.festival.name)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            headerButtons
        }
        .padding(.top, 95)
        .background(.ultraThinMaterial)
        .offset(y: max(-420 - scrollOffset, -200))
    }
    
    // MARK: - Header Section | original before consolidating
    private var headerSectionOriginal: some View {
        VStack {
            if let logoImage = viewModel.logoImage {
               Image(uiImage: logoImage)
                   .resizable()
                   .scaledToFit()
                   .frame(height: 200)
//                   .frame(height: scrollOffset < -420 ? 200 : min(200, -200 - scrollOffset))
//                   .frame(minHeight: 50)
//                   .frame(maxHeight: 200)
//                   .frame(width: 200, height: max(50, min(200, 200 - scrollOffset)))
//                   .frame(width: 200, height: min(200, -200 - scrollOffset))
//                   .frame(height: scrollOffset >= -200 ? 40: 200) // Shrink logo when scrolling far enough
                   .offset(y: scrollOffset >= -200 ? -100: 0) // Hide logo when scrolling far enough
//                   .offset(y: max(min(-420 - scrollOffset, 0), -420))
//                   .offset(y:  max(-420 - scrollOffset, -420))
//                   .offset(y: max(0, scrollOffset * 0.5) - 60)
//                   .offset(y: max(-450 - scrollOffset, -2000))
                   .padding(.top, 95)
            } else {
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(Circle())  // Make the image a circle
                    .offset(y: scrollOffset >= -200 ? -100: 0) // Hide logo when scrolling far enough
                    .padding(.top, 95)
                    .redacted(reason: logoImage == nil ? .placeholder : [])
            }
            
            Text(viewModel.festival.name)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            headerButtons
        }
//        .background(Color.black.opacity(0.4))
        .background(.ultraThinMaterial)
//        .offset(y: scrollOffset >= -200 ? -40: max(-420 - scrollOffset, -200)) // Goes with shrinking logo
        .offset(y: max(-420 - scrollOffset, -200)) // Goes with hiding logo
//        .offset(y: max(-420, min(-240, -420 - scrollOffset)))
    }
    
    // MARK: - Header Buttons
    private var headerButtons: some View {
        HStack {
            ForEach(buttonConfigs, id: \.label) { config in
                createButton(config: config)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
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
        }
    }
}

// MARK: - Preview Provider
@available(iOS 18.0, *)
struct FestivalView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FestivalView(viewModel: FestivalViewModel(festival: .sample))
        }
    }
}
