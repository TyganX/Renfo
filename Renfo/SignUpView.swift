import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var password: String = ""
    @State private var verifyPassword: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.bottom, 10)
            
            TextField("Name", text: $name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.bottom, 10)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.bottom, 10)
            
            SecureField("Verify Password", text: $verifyPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.bottom, 20)
            
            Button("Sign Up") {
                signUp()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.blue)
            .cornerRadius(15.0)
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
