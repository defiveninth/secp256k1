//
//  Login.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 23.06.2026.
//
import SwiftUI

struct LoginMockView: View {
    @Environment(AuthManager.self) private var authManager
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Account Access") {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                    SecureField("Password", text: $password)
                }
                
                Button("Sign In") {
                    authManager.login(token: "mocked_jwt_token")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .bold()
            }
            .navigationTitle("Sign In Required")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
