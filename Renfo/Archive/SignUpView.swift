import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.presentationMode) var presentationMode
    var dismiss: DismissAction
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var verifyPassword: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @AppStorage("appColor") var appColor: AppColor = .default
    
    var body: some View {
            Form {
                // Renfo Icon
                Section {
                    VStack(alignment: .center, spacing: 5) {
                        Image("RenfoLogo")
                            .resizable()
                            .frame(width: 150, height: 150)
                    }
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                
                // Input Fields
                Section {
                    TextField("Email", text: $email)
                    TextField("Name", text: $name)
                    SecureField("Password", text: $password)
                    SecureField("Verify Password", text: $verifyPassword)
                }
                
                // Sign up Button
                Section {
                    Button(action: {
//                        signUp()
                        dismiss()
                    }) {
                        Text("Create Account")
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
//                    dismiss()
                }
                .foregroundColor(appColor.color)
            }
        }
    }
    
    func signUp() {
        guard password == verifyPassword else {
            self.alertMessage = "Passwords do not match."
            self.showingAlert = true
            return
        }
        
        // Check if the name field is empty
        guard !name.isEmpty else {
            self.alertMessage = "Please enter your name."
            self.showingAlert = true
            return
        }
        
        sessionStore.createAccount(email: email, password: password, name: name) { success, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.showingAlert = true
            } else if success {
                // Navigate to SettingsView after successful sign-up
                self.presentationMode.wrappedValue.dismiss()
            } else {
                self.alertMessage = "Failed to create account."
                self.showingAlert = true
            }
        }
    }
}

// MARK: - Preview Provider
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(SessionStore())
    }
}

