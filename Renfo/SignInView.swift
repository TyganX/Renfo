import SwiftUI
import FirebaseAuth

// MARK: - Sign In View
struct SignInView: View {
    // MARK: - Environment Objects and States
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    // MARK: - View Body
    var body: some View {
        VStack {
            Spacer()
            
            // User Icon
            Image(systemName: "person.crop.circle")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipped()
                .padding(.bottom, 50)
            
            // Email Input Field
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.bottom, 20)
            
            // Password Input Field
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.bottom, 20)
            
            // Sign In Button
            Button("Sign in", action: logIn)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(Color.blue)
                .cornerRadius(15.0)
            
            Spacer()
            
            // Sign Up Navigation Link
            signUpLink()
        }
        .padding()
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("Sign in")
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
    }
    
    // MARK: - Subviews
    // Sign Up Link View
    private func signUpLink() -> some View {
        HStack {
            Text("Don't have an account?")
                .foregroundColor(.gray)
            NavigationLink(destination: SignUpView()) {
                Text("Sign Up")
                    .foregroundColor(.blue)
            }
        }
    }
}

// MARK: - Preview Provider
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(SessionStore())
    }
}
