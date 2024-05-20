import SwiftUI

struct BeanBandits: View {
    @State private var showAlert = false  // State variable to control the alert visibility

    var body: some View {
        List {
            Section {
                VStack {
                    Button(action: {
                        showAlert = true
                    }) {
                        Image("BeanBanditsLogo")
                            .resizable()
                            .cornerRadius(15)
                            .aspectRatio(contentMode: .fit)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Beanedict Cumberbandit"),
                            message: Text("Live by the Bean. Die by the bean.")
                        )
                    }
                }
                .listRowBackground(Color.clear) // Makes the list row background transparent
            }
            
            Section {
                URLButtonInApp(label: "Website", systemImage: "globe", urlString: "https://www.beanbandits.net/")
                
                URLButton(label: "Discord", systemImage: "person.bubble", urlString: "discord://discord.gg/bE5tkVdAt9")
                
                URLButton(label: "Telegram", systemImage: "paperplane", urlString: "https://t.me/BeanBandits")
            }
        }
        .navigationTitle("Bean Bandits")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BeanBandits_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BeanBandits()
        }
    }
}
