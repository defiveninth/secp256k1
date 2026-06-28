//
//  SignInView.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 40) {
                    Spacer(minLength: 30)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome Back")
                            .font(.system(size: 32, weight: .light, design: .serif))
                            .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                            .tracking(0.5)
                        
                        Text("ENTER YOUR PASSWORD BELOW TO CONTINUE")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                            .tracking(2.0)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 28)
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("PASSWORD")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .tracking(1.5)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .frame(width: 20)
                                
                                SecureField("", text: $viewModel.password, prompt: Text("••••••••").foregroundColor(Color(white: 0.7)))
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 16)
                            .background(Color(white: 0.98))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(white: 0.88), lineWidth: 1)
                            )
                        }
                        
                        if let error = viewModel.errorMessage {
                            HStack(spacing: 6) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .padding(.horizontal, 4)
                        }
                    }
                    .padding(.horizontal, 28)
                    
                    Button(action: {
                        Task { await viewModel.signIn() }
                    }) {
                        HStack {
                            Text("SIGN IN")
                                .font(.system(size: 14, weight: .semibold))
                                .tracking(1.5)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            viewModel.password.isEmpty
                            ? Color(white: 0.9)
                            : Color(red: 0.08, green: 0.08, blue: 0.08)
                        )
                        .foregroundColor(viewModel.password.isEmpty ? Color(white: 0.6) : .white)
                        .cornerRadius(8)
                    }
                    .disabled(viewModel.password.isEmpty)
                    .padding(.horizontal, 28)
                    .padding(.top, 8)
                    
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
