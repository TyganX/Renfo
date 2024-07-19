import SwiftUI

struct URLButton: View {
    let label: String
    let systemImage: String
    let urlString: String

    var body: some View {
        Button(action: {
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }) {
            Label(label, systemImage: systemImage)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct URLButtonCustom: View {
    let label: String
    let image: Image
    let urlString: String

    var body: some View {
        Button(action: {
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }) {
            Label {
                Text(label)
            } icon: {
                image
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SocialButton: View {
    let label: String
    let image: Image
    let handle: String
    let urlString: String

    var body: some View {
        Button(action: {
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                Label {
                    Text(handle)
                        .lineLimit(1)
//                        .minimumScaleFactor(0.5)
                } icon: {
                    image
                }
//                .symbolRenderingMode(.multicolor)
                Spacer()
                Image(systemName: "chevron.up")
                    .foregroundStyle(.placeholder)
                    .fontWeight(.bold)
                    .rotationEffect(.degrees(45))
                    .font(.system(size: 13))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct URLButtonInApp: View {
    let label: String
    let systemImage: String
    let urlString: String

    @State private var showingSafariView = false

    var body: some View {
        Button(action: {
            self.showingSafariView = true
        }) {
            HStack {
                Label(label, systemImage: systemImage)
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingSafariView) {
            if let url = URL(string: urlString) {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
    }
}
