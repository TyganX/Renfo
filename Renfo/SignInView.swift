import SwiftUI
import FirebaseAuth

// MARK: - Sign In View
struct SignInView: View {
    // MARK: - Environment Objects and States
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isShowingSignUp = false
    
    // MARK: - View Body
    var body: some View {
            VStack {
                Form {
                    // User Icon
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
                        SecureField("Password", text: $password)
                    }
                    
                    // Sign In Button
                    Section {
                        Button(action: {
                            logIn()
                        }) {
                            Text("Sign in")
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                        }
                    }
                       
                    // Sign Up Link View
                    HStack {
                        Text("Don't have an account?")
                        //                    .foregroundColor(.gray)
                        Button("Sign up") {
                            isShowingSignUp = true
                        }
                        .foregroundColor(.blue)
                        //                .sheet(isPresented: $isShowingSignUp) {
                        .fullScreenCover(isPresented: $isShowingSignUp) {
                            NavigationView {
                                SignUpView(dismiss: dismiss)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }
        }
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
}

// MARK: - Preview Provider
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(SessionStore())
    }
}
