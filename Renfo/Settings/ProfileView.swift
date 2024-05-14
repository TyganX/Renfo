import SwiftUI
import Firebase

struct ProfileView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.dismiss) var dismiss
    
    @State private var isEditing = false
    @State private var newName = ""
    @State private var newEmail = ""
    @State private var newPassword = ""
    @State private var isPasswordModalPresented = false
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
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
            }
            
            if isEditing {
                Section(header: Text("Edit Profile")) {
                    HStack {
                        Text("Name")
                        Spacer(minLength: 50)
                        TextField("Name", text: $newName)
                    }
                    
                    HStack {
                        Text("Email ")
                        Spacer(minLength: 50)
                        TextField("Email", text: $newEmail)
                    }
                    
                    Button(action: { isPasswordModalPresented = true }) {
                        Text("Change Password")
                    }
                    .sheet(isPresented: $isPasswordModalPresented) {
                        ChangePasswordView()
                    }
                }
            }
            
            Section {
                if isEditing {
                    Button(action: {
                        sessionStore.updateProfile(name: newName, email: newEmail, password: newPassword, profilePicture: newProfilePicture) { success, error in
                            DispatchQueue.main.async {
                                if success {
                                    isEditing = false
                                } else {
                                    // Handle error
                                    print("Error updating profile: \(error?.localizedDescription ?? "Unknown error")")
                                }
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

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @ObservedObject var sessionStore = SessionStore()

    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("Your password must be at least 6 characters.")) {
                    HStack {
                        Text("New")
                        Spacer(minLength: 50)
                        SecureField("enter password", text: $newPassword)
                    }
                    
                    HStack {
                        Text("Verify")
                        Spacer(minLength: 40)
                        SecureField("re-enter password", text: $confirmPassword)
                    }
                }
            }
            .navigationTitle("Change Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: handleChangePassword) {
                        Text("Change")
                            .bold()
                    }
                    .disabled(newPassword.isEmpty || confirmPassword.isEmpty)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func handleChangePassword() {
        if newPassword == confirmPassword {
            if newPassword.count >= 6 {
                sessionStore.updatePassword(newPassword: newPassword) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            dismiss()
                        } else {
                            // Handle error
                            print("Error updating password: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }
            } else {
                alertTitle = "Weak Password"
                alertMessage = "Your password must be at least 6 characters."
                showingAlert = true
            }
        } else {
            alertTitle = "Passwords Do Not Match"
            alertMessage = "Enter your new password again."
            showingAlert = true
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionStore())
    }
}

//struct ChangePasswordView: View {
//    @Environment(\.dismiss) var dismiss
//    @State private var newPassword = ""
//    @State private var confirmPassword = ""
//    @ObservedObject var sessionStore = SessionStore()
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(footer: Text("Your password must be at least 6 characters.")) {
//                    HStack {
//                        Text("New")
//                        Spacer(minLength: 50)
//                        SecureField("enter password", text: $newPassword)
//                    }
//                    
//                    HStack {
//                        Text("Verify")
//                        Spacer(minLength: 40)
//                        SecureField("re-enter password", text: $confirmPassword)
//                    }
//                }
//            }
//            .navigationTitle("Change Password")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: handleChangePassword) {
//                        Text("Change")
//                            .bold()
//                    }
//                    .disabled(newPassword.isEmpty || confirmPassword.isEmpty)
//                }
//            }
//        }
//    }
//    
//    private func handleChangePassword() {
//        if newPassword == confirmPassword && newPassword.count >= 6 {
//            sessionStore.updatePassword(newPassword: newPassword) { success, error in
//                DispatchQueue.main.async {
//                    if success {
//                        dismiss()
//                    } else {
//                        // Handle error
//                        print("Error updating password: \(error?.localizedDescription ?? "Unknown error")")
//                    }
//                }
//            }
//        }
//    }
//}
