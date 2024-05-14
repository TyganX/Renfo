import SwiftUI
import FirebaseAuth

// MARK: - Authentication View
struct AuthenticationView: View {
    // MARK: - Environment Objects and States
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var verifyPassword: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isShowingSignUp = false

    // MARK: - View Body
    var body: some View {
        VStack {
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
                    if isShowingSignUp {
                        TextField("Name", text: $name)
                    }
                    SecureField("Password", text: $password)
                    if isShowingSignUp {
                        SecureField("Verify Password", text: $verifyPassword)
                    }
                }
                
                // Sign In/Up Button
                Section {
                    Button(action: {
                        isShowingSignUp ? signUp() : logIn()
                    }) {
                        Text(isShowingSignUp ? "Create Account" : "Sign in")
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Switch to Sign Up/In Button
                Section {
                    HStack {
                        Text(isShowingSignUp ? "Already have an account?" : "Don't have an account?")
                        Button(action: {
                            isShowingSignUp.toggle()
                        }) {
                            Text(isShowingSignUp ? "Sign in" : "Sign up")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle(isShowingSignUp ? "Sign Up" : "Sign In")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Functions
    // Function to handle user sign in
    func logIn() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.alertMessage = error.localizedDescription
                self.showingAlert = true
            } else {
                self.sessionStore.isUserSignedIn = true
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        dismiss()
    }

    // Function to handle user sign up
    func signUp() {
        guard password == verifyPassword else {
            self.alertMessage = "Passwords do not match."
            self.showingAlert = true
            return
        }
        
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
        dismiss()
    }
}


// MARK: - Preview Provider
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(SessionStore())
    }
}
