import SwiftUI

struct Test1: View {
    @ObservedObject var viewModel: FestivalViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                headerSection
                
//                bodySection
                SampleCardsView()
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack {
            Image("DefaultProfilePicture")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .clipShape(Circle())
            
            GeometryReader { geo in
                let minY = geo.frame(in: .global).minY
                VStack {
                    Text("Renfo")
                        .font(.title3)
                        .fontWeight(.bold)
//                        .foregroundColor(.white)
                    
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
    
    // MARK: - Body Section
    private var bodySection: some View {
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
    }
        
    @ViewBuilder
    func SampleCardsView() -> some View {
        VStack(spacing: 15) {
            ForEach(1...25, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.black.opacity(0.05))
                    .frame(height: 75)
            }
        }
        .padding(.top, 70)
        .padding(15)
    }
}

// MARK: - Preview Provider
struct Test1_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Test1(viewModel: FestivalViewModel(festival: .sample))
        }
    }
}
