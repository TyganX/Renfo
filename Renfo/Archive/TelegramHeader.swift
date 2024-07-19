import SwiftUI

// MARK: - Home View
struct TelegramHeaderView: View {
    var size: CGSize
    var safeArea: EdgeInsets
    
    // View properties
    @AppStorage("appColor") var appColor: AppColor = .default
    @State private var showingPopover = false
    @ObservedObject var viewModel: FestivalViewModel
    @State private var scrollProgress: CGFloat = 0
    @Environment(\.colorScheme) private var colorScheme
    @State private var textHeaderOffset: CGFloat = 0
    
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    // MARK: - View Body
    var body: some View {
        let isHavingNotch = safeArea.bottom != 0
        
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 12) {
                profileImage(isHavingNotch: isHavingNotch)
                headerText(fixedTop: safeArea.top + 3)
                headerButtons
                SampleRows(safeArea: safeArea)
            }
            .frame(maxWidth: .infinity)
        }
        .backgroundPreferenceValue(AnchorKey.self, { pref in
            backgroundCanvas(pref: pref, isHavingNotch: isHavingNotch)
        })
        .overlay(alignment: .top) {
            topOverlay
        }
        .coordinateSpace(name: "SCROLLVIEW")
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
    
    // MARK: - Profile Image
    @ViewBuilder
    private func profileImage(isHavingNotch: Bool) -> some View {
        if let logoImage = viewModel.logoImage {
            Image(uiImage: logoImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 130 - (75 * scrollProgress), height: 130 - (75 * scrollProgress))
                .opacity(1 - scrollProgress)
                .blur(radius: scrollProgress * 10, opaque: true)
                .clipShape(Circle())
                .anchorPreference(key: AnchorKey.self, value: .bounds, transform: {
                    return ["HEADER": $0]
                })
                .padding(.top, safeArea.top + 15)
                .offsetExtractor(coordinateSpace: "SCROLLVIEW") { scrollRect in
                    guard isHavingNotch else { return }
                    let progress = -scrollRect.minY / 25
                    scrollProgress = min(max(progress, 0), 1)
                }
                .redacted(reason: viewModel.logoImage == nil ? .placeholder : [])
        }
    }
    
    // MARK: - Header Text
    @ViewBuilder
    private func headerText(fixedTop: CGFloat) -> some View {
        Text(viewModel.festival.name)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.gray)
            .padding(.vertical, 15)
            .background(content: {
                Rectangle()
                    .fill(colorScheme == .dark ? .black : .white)
                    .frame(width: size.width)
                    .padding(.top, textHeaderOffset < fixedTop ? -safeArea.top : 0)
                    .shadow(color: .black.opacity(textHeaderOffset < fixedTop ? 0.1 : 0), radius: 5, x: 0, y: 5)
            })
            .offset(y: textHeaderOffset < fixedTop ? -(textHeaderOffset - fixedTop) : 0)
            .offsetExtractor(coordinateSpace: "SCROLLVIEW") {
                textHeaderOffset = $0.minY
            }
            .zIndex(1000)
    }
    
    // MARK: - Background Canvas
    @ViewBuilder
    private func backgroundCanvas(pref: [String: Anchor<CGRect>], isHavingNotch: Bool) -> some View {
        GeometryReader { proxy in
            if let anchor = pref["HEADER"], isHavingNotch {
                let frameRect = proxy[anchor]
                let isHavingDynamicIsland = safeArea.top > 51
                let capsuleHeight = isHavingDynamicIsland ? 37 : (safeArea.top - 15)
                
                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.5))
                    context.addFilter(.blur(radius: 12))
                    
                    context.drawLayer { ctx in
                        if let headerView = context.resolveSymbol(id: 0) {
                            ctx.draw(headerView, in: frameRect)
                        }
                        
                        if let dynamicIsland = context.resolveSymbol(id: 1) {
                            let rect = CGRect(x: (size.width - 120) / 2, y: isHavingDynamicIsland ? 11 : 0, width: 120, height: capsuleHeight)
                            ctx.draw(dynamicIsland, in: rect)
                        }
                    }
                } symbols: {
                    HeaderView(frameRect)
                        .tag(0)
                        .id(0)
                    
                    DynamicIslandCapsule(capsuleHeight)
                        .tag(1)
                        .id(1)
                }
            }
        }
        .overlay(alignment: .top) {
            Rectangle()
                .fill(colorScheme == .dark ? .black : .white)
                .frame(height: 15)
        }
    }
    
    // MARK: - Top Overlay
    private var topOverlay: some View {
        HStack {
            Button {
                // Action for back button
            } label: {
                Label("", systemImage: "chevron.left")
            }
            
            Spacer()
            
            favoriteButton
        }
        .padding(15)
        .padding(.top, safeArea.top)
    }
    
    // MARK: - Canvas Symbols
    @ViewBuilder
    func HeaderView(_ frameRect: CGRect) -> some View {
        Circle()
            .fill(.black)
            .frame(width: frameRect.width, height: frameRect.height)
    }
    
    @ViewBuilder
    func DynamicIslandCapsule(_ height: CGFloat = 37) -> some View {
        Capsule()
            .fill(.black)
            .frame(width: 120, height: height)
    }
    
    // MARK: - Header Buttons
    private var headerButtons: some View {
        HStack {
            ForEach(buttonConfigs, id: \.label) { config in
                createButton(config: config)
            }
        }
        .padding(.horizontal)
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
    
    // MARK: - Sample Rows
    @ViewBuilder
    func SampleRows(safeArea: EdgeInsets) -> some View {
        VStack {
//            if !viewModel.detailsLinks.isEmpty {
//                Section(header: Text("Details")) {
//                    ForEach(viewModel.detailsLinks, id: \.key) { link in
//                        HStack {
//                            Label {
//                                Text(link.value.text)
//                                    .font(.body)
//                                    .foregroundColor(.primary)
//                            } icon: {
//                                Image(systemName: link.value.systemImage)
//                                    .foregroundColor(nil)
//                            }
//                            Spacer()
//                            if link.key == "dates" {
//                                ActiveIndicator(isActive: link.value.isActive, daysUntilStart: link.value.daysUntilStart)
//                            }
//                        }
//                    }
//                }
//            }
//            
//            if !viewModel.resourceLinks.isEmpty {
//                Section(header: Text("Resources")) {
//                    ForEach(viewModel.resourceLinks, id: \.key) { link in
//                        link.value.view()
//                    }
//                }
//            }
//            
//            if !viewModel.socialLinks.isEmpty {
//                Section(header: Text("Social")) {
//                    ForEach(viewModel.socialLinks.keys.sorted(), id: \.self) { key in
//                        let link = viewModel.socialLinks[key]!
//                        URLButtonCustom(label: link.label, image: Image(link.systemImage), urlString: "https://www.\(key).com/\(link.url)")
//                    }
//                }
//            }
            
            ForEach(1...20, id: \.self) { _ in
                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(.gray.opacity(0.15))
                        .frame(height: 25)
                    
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(.gray.opacity(0.15))
                        .frame(height: 15)
                        .padding(.trailing, 50)
                    
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(.gray.opacity(0.15))
                        .padding(.trailing, 150)
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, safeArea.bottom + 15)
    }
}

// MARK: - Helper Methods
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetExtractor(coordinateSpace: String, completion: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .named(coordinateSpace))
                    Color.clear
                        .preference(key: OffsetKey.self, value: rect)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                }
            }
    }
}

struct AnchorKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}

// MARK: - Preview Provider
struct TelegramHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            TelegramHeaderView(
                size: geometry.size,
                safeArea: geometry.safeAreaInsets,
                viewModel: FestivalViewModel(festival: .sample)
            )
            .ignoresSafeArea()
        }
    }
}
