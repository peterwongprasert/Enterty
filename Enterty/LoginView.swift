import CoreData
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isShowingSignUp = false
    @State private var isShowingPasswordRecovery = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo and App Name
                VStack(spacing: 10) {
                    Image(systemName: "play.square.stack")
                        .font(.system(size: 60))
                        .foregroundColor(.accentColor)

                    Text("Enterty")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Track Your Entertainment")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)

                // Login Form
                VStack(spacing: 15) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.password)

                    Button(action: handleLogin) {
                        Text("Log In")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 30)

                // Sign Up and Password Recovery
                VStack(spacing: 15) {
                    Button("Create Account") {
                        isShowingSignUp = true
                    }
                    .foregroundColor(.accentColor)

                    Button("Forgot Password?") {
                        isShowingPasswordRecovery = true
                    }
                    .foregroundColor(.secondary)
                }

                Spacer()
            }
            .sheet(isPresented: $isShowingSignUp) {
                SignUpView()
            }
            .sheet(isPresented: $isShowingPasswordRecovery) {
                PasswordRecoveryView()
            }
            .alert("Login Error", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func handleLogin() {
        // Validate inputs
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Please fill in all fields"
            showingAlert = true
            return
        }

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "email == %@ AND password == %@", email, password)

        do {
            let users = try viewContext.fetch(fetchRequest)
            if users.first != nil {
                // login successful
                alertMessage = "Login successful"
                showingAlert = true

            } else {
                alertMessage = "Invalid credentials"
                showingAlert = true
            }
        } catch {
            alertMessage = "Error: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Information")) {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)

                    SecureField("Password", text: $password)
                        .textContentType(.newPassword)

                    SecureField("Confirm Password", text: $confirmPassword)
                        .textContentType(.newPassword)
                }

                Button(action: handleSignUp) {
                    Text("Create Account")
                }
            }
            .navigationTitle("Sign Up")
            .navigationBarItems(
                trailing: Button("Cancel") {
                    dismiss()
                }
            ).alert("Sign Up", isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    if alertMessage == "Account created successfully!" {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)

    }

    private func handleSignUp() {
        // validate inputs
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            alertMessage = "Please fill in all fields"
            showingAlert = true
            return
        }

        // Validate email format

        guard isValidEmail(email) else {
            alertMessage = "Please enter a valid email address"
            showingAlert = true
            return
        }

        // check if password match
        guard password == confirmPassword else {
            alertMessage = "Password do not match"
            showingAlert = true
            return
        }

        // check password length
        guard password.count >= 6 else {
            alertMessage = "Password must be at least 6 characters"
            showingAlert = true
            return
        }

        // check if user already exists
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {

            let existingUsers = try viewContext.fetch(fetchRequest)
            if !existingUsers.isEmpty {
                alertMessage = "An Account with this email already exists"
                showingAlert = true
                return
            }

            // create new user
            let newUser = User(context: viewContext)
            newUser.email = email
            newUser.password = password

            try viewContext.save()

            alertMessage = "Account created successfully"
            showingAlert = true

        } catch {
            alertMessage = "Errpr Creating Account : \(error.localizedDescription)"
            showingAlert = true

        }
    }
}

struct PasswordRecoveryView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Reset Password")) {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)

                    Button(action: handlePasswordRecovery) {
                        Text("Send Reset Link")
                    }
                }

                Section {
                    Text(
                        "Enter your email address and we'll send you a link to reset your password."
                    )
                    .foregroundColor(.secondary)
                    .font(.footnote)
                }
            }
            .navigationTitle("Password Recovery")
            .navigationBarItems(
                trailing: Button("Cancel") {
                    dismiss()
                })
        }
    }

    private func handlePasswordRecovery() {
        // TODO: Implement password recovery logic
    }
}

#Preview {
    LoginView()
}
