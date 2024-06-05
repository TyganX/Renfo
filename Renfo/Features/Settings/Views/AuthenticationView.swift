import SwiftUI
import FirebaseAuth
import Combine

// MARK: - Authentication View
struct AuthenticationView: View {
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
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        VStack {
            Form {
                Section {
                    VStack(alignment: .center, spacing: 5) {
                        Image("RenfoLogo")
                            .resizable()
                            .frame(width: 150, height: 150)
                    }
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                
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
                
                Section {
                    Button(action: {
                        isShowingSignUp ? signUp() : logIn()
                    }) {
                        Text(isShowingSignUp ? "Create Account" : "Sign in")
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                    }
                }
                
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
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func logIn() {
        sessionStore.signIn(email: email, password: password)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.alertMessage = error.localizedDescription
                    self.showingAlert = true
                }
            }, receiveValue: { success in
                if success {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
            .store(in: &cancellables)
    }

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
        
        sessionStore.createAccount(email: email, password: password, name: name)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.alertMessage = error.localizedDescription
                    self.showingAlert = true
                }
            }, receiveValue: { success in
                if success {
                    self.presentationMode.wrappedValue.dismiss()
                }
            })
            .store(in: &cancellables)
    }
}


// MARK: - Preview Provider
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(SessionStore())
    }
}
