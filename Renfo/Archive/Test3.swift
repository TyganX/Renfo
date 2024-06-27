import SwiftUI

struct ContentViewT: View {
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let safeArea = proxy.safeAreaInsets

            HomeT(
                viewModel: FestivalViewModel(festival: .sample),
                size: size,
                safeArea: safeArea
            )
        }
    }
}

struct HomeT: View {
    @ObservedObject var viewModel: FestivalViewModel
    let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    var size: CGSize
    var safeArea: EdgeInsets
    @State private var offsetY: CGFloat = 0

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                HeaderView()
                    .zIndex(1000)
                bodySection
            }
            .background(
                ScrollDetector { offset in
                    offsetY = -offset
                }
            )
        }
    }

    @ViewBuilder
    func HeaderView() -> some View {
        let headerHeight = (size.height * 0.3) + safeArea.top
        let minimumHeaderHeight = safeArea.top * 3
        let progress = max(min(-offsetY / (headerHeight - minimumHeaderHeight), 1), 0)

        GeometryReader { _ in
            VStack(spacing: 20) {
                GeometryReader { proxy in
                    if let logoImage = viewModel.logoImage {
                        Image(uiImage: logoImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .clipShape(Circle())
                            .scaleEffect(1 - (progress * 0.7))
                    }
                }
                .frame(width: headerHeight * 0.5, height: headerHeight * 0.5)
                
                Text(viewModel.festival.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                headerButtons
            }
            .padding([.horizontal, .bottom])
            .background(.ultraThinMaterial)
            .frame(height: (headerHeight + offsetY) < minimumHeaderHeight ? minimumHeaderHeight : (headerHeight + offsetY), alignment: .bottom)
            .offset(y: -offsetY)
        }
        .frame(height: headerHeight)
    }

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

    private var buttonConfigs: [ButtonConfig] {
        [
            ButtonConfig(
                action: {
                    if let url = URL(string: "tel://\(viewModel.festival.contactPhone.replacingOccurrences(of: "-", with: ""))") {
                        UIApplication.shared.open(url)
                    }
                },
                imageName: "phone.fill",
                label: "Call",
                verticalPadding: 2
            ),
            ButtonConfig(
                action: {
                    if let url = URL(string: "mailto:\(viewModel.festival.contactEmail)") {
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
                    if let url = URL(string: viewModel.festival.website) {
                        UIApplication.shared.open(url)
                    }
                },
                imageName: "safari.fill",
                label: "Website",
                verticalPadding: 1
            )
        ]
    }

    private var bodySection: some View {
        VStack(alignment: .leading) {
            if !viewModel.detailsLinks.isEmpty {
                Section(header: Text("Details")) {
                    ForEach(viewModel.detailsLinks, id: \.key) { link in
                        HStack {
                            Label(link.value.text, systemImage: link.value.systemImage)
                                .font(.body)
                                .foregroundColor(.primary)
                            Spacer()
                            if link.key == "dates" {
                                ActiveIndicator(isActive: link.value.isActive, daysUntilStart: link.value.daysUntilStart)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.ultraThinMaterial))
                    }
                }
            }
            
            if !viewModel.resourceLinks.isEmpty {
                Section(header: Text("Resources")) {
                    ForEach(viewModel.resourceLinks, id: \.key) { link in
                        link.value.view()
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.ultraThinMaterial))
                    }
                }
            }
            
            if !viewModel.socialLinks.isEmpty {
                Section(header: Text("Social")) {
                    ForEach(viewModel.socialLinks.keys.sorted(), id: \.self) { key in
                        let link = viewModel.socialLinks[key]!
                        URLButtonCustom(label: link.label, image: Image(link.systemImage), urlString: "https://www.\(key).com/\(link.url)")
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.ultraThinMaterial))
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct ScrollDetector: UIViewRepresentable {
    var onScroll: (CGFloat) -> ()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView, !context.coordinator.isDelegateAdded {
                scrollView.delegate = context.coordinator
                context.coordinator.isDelegateAdded = true
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollDetector
        
        init(parent: ScrollDetector) {
            self.parent = parent
        }
        
        var isDelegateAdded: Bool = false
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.onScroll(scrollView.contentOffset.y)
        }
    }
}

struct ContentViewT_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewT()
//        ContentViewT(viewModel: FestivalViewModel(festival: .sample))
//        ContentViewT(
//            viewModel: FestivalViewModel(festival: .sample),
//            size: size,
//            safeArea: safeArea
//        )
    }
}
