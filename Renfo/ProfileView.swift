import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.dismiss) var dismiss
    
    @State private var isEditing = false
    @State private var newName = ""
    @State private var newEmail = ""
    @State private var newPassword = ""
    @State private var newProfilePicture: UIImage? = nil

    var body: some View {
        Form {
            Section {
                VStack(alignment: .center, spacing: 10) {
                    if let photoURL = sessionStore.userPhotoURL, !isEditing {
                        AsyncImage(url: URL(string: photoURL)) { image in
                            image.resizable()
                        } placeholder: {
                            Image("DefaultProfilePicture")
                                .resizable()
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .foregroundColor(.gray)
                    }
                    
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
            
            if isEditing {
                Section(header: Text("Edit Profile")) {
                    TextField("Name", text: $newName)
                    TextField("Email", text: $newEmail)
                    SecureField("Password", text: $newPassword)
                    // Add a way for the user to select a new profile picture
                }
            }
            
            Section {
                if isEditing {
                    Button(action: {
                        sessionStore.updateProfile(name: newName, email: newEmail, password: newPassword, profilePicture: newProfilePicture!) { success, error in
                            if success {
                                isEditing = false
                            } else {
                                // Handle error
                            }
                        }
                    }) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                } else {
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
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            isEditing.toggle()
            if isEditing {
                newName = sessionStore.userName ?? ""
                newEmail = sessionStore.userEmail
                newPassword = ""
                newProfilePicture = nil
            }
        }) {
            Text(isEditing ? "Cancel" : "Edit")
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionStore())
    }
}
