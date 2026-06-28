//
//  SignUpView.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Create Your Account")
                        .font(.title)
                        .bold()
                    
                    Text("A mock verification OTP (123456) has been generated for you.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                
                Group {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Full Name").font(.caption).bold().foregroundColor(.secondary)
                        TextField("Abdurrauf Sakenov", text: $viewModel.fullname)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("One-Time Password (OTP)").font(.caption).bold().foregroundColor(.secondary)
                        TextField("Enter 123456", text: $viewModel.otp)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Choose Password").font(.caption).bold().foregroundColor(.secondary)
                        SecureField("Secure Password", text: $viewModel.password)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    Task { await viewModel.signUp() }
                }) {
                    Text("Complete Registration")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
