import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .center, spacing: 5) {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 100, height: 100)
                        .overlay(Text(sessionStore.userInitials)
                            .font(.largeTitle)
                            .foregroundColor(.white))
                    
                    // Display the user's name if available
                    if let userName = sessionStore.userName {
                        Text(userName)
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    Text(sessionStore.userEmail)
                        .font(.headline)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
            }
            
            Section {
                Button(action: {
                    sessionStore.signOut()
                    dismiss()
                }) {
                    Text("Sign Out")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionStore())
    }
}
