//
//  Login.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 23.06.2026.
//
import SwiftUI

struct Login: View {
    @Environment(AuthManager.self) private var authManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var fullname = ""
    @State private var otpCode = ""
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                switch authManager.currentStep {
                case .enterEmail:
                    Section(header: Text("Get Started"), footer: Text("Tip: Enter an email containing the word 'new' to test the registration flow.")) {
                        TextField("Email Address", text: $email)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                    
                    Button(action: {
                        Task {
                            isLoading = true
                            await authManager.checkEmailStatus(email)
                            isLoading = false
                        }
                    }) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Continue")
                                .frame(maxWidth: .infinity)
                                .bold()
                        }
                    }
                    .disabled(email.isEmpty || isLoading)
                    
                case .verifyPassword:
                    Section(header: Text("Welcome Back"), footer: Text("Enter password for \(authManager.checkedEmail)")) {
                        SecureField("Password", text: $password)
                    }
                    
                    Button("Sign In") {
                        authManager.login(password: password)
                    }
                    .frame(maxWidth: .infinity)
                    .bold()
                    .disabled(password.isEmpty)
                    
                case .createAccount:
                    Section(header: Text("Create Account"), footer: Text("An OTP was sent to \(authManager.checkedEmail)")) {
                        TextField("Full Name", text: $fullname)
                            .textContentType(.name)
                        
                        SecureField("Choose password", text: $password)
                        
                        TextField("OTP Code", text: $otpCode)
                            .keyboardType(.numberPad)
                        
                        Button("Verify & Register") {
                            authManager.registerUser(fullName: fullname, password: password, otp: otpCode)
                        }
                        .frame(maxWidth: .infinity)
                        .bold()
                        .disabled(fullname.isEmpty || password.isEmpty || otpCode.isEmpty)
                    }
                }
            }
            .animation(.default, value: authManager.currentStep)
            .navigationTitle(navigationTitleForStep)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if authManager.currentStep != .enterEmail {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Back") {
                            authManager.currentStep = .enterEmail
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        authManager.resetFlow()
                    }
                }
            }
        }
    }
    
    private var navigationTitleForStep: String {
            switch authManager.currentStep {
            case .enterEmail: return "Sign In"
            case .verifyPassword: return "Verify Password"
            case .createAccount: return "Register Account"
            }
        }
}
