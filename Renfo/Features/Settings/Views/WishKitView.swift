import SwiftUI
import WishKit

struct WishKitView: View {

    init() {
        WishKit.configure(with: "8AB8AC10-EE01-49AF-B4FC-770E1C3B74A0")
        WishKit.theme.tertiaryColor = .set(light: .gray, dark: .black)
        WishKit.config.buttons.addButton.bottomPadding = .large
    }

    var body: some View {
        WishKit.view
    }
}

// MARK: - Preview Provider
struct WishKitView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            WishKitView()
        }
    }
}
