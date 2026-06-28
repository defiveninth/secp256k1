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
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 40) {
                    Spacer(minLength: 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Create Your Account")
                            .font(.system(size: 32, weight: .light, design: .serif))
                            .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                            .tracking(0.5)
                        
                        Text("AN OTP VERIFICATION CODE HAS BEEN SENT TO YOUR EMAIL ADDRESS")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)
                            .tracking(2.0)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 28)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("FULL NAME")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .tracking(1.5)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "person")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .frame(width: 20)
                                
                                TextField("", text: $viewModel.fullname, prompt: Text("Abdurrauf Sakenov").foregroundColor(Color(white: 0.7)))
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                                    .disableAutocorrection(true)
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
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ONE-TIME PASSWORD (OTP)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .tracking(1.5)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "key")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .frame(width: 20)
                                
                                TextField("", text: $viewModel.otp, prompt: Text("Enter OTP code").foregroundColor(Color(white: 0.7)))
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                                    .keyboardType(.numberPad)
                                    .disableAutocorrection(true)
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
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("CHOOSE PASSWORD")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .tracking(1.5)
                            
                            HStack(spacing: 12) {
                                Image(systemName: "lock")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                    .frame(width: 20)
                                
                                SecureField("", text: $viewModel.password, prompt: Text("Secure Password").foregroundColor(Color(white: 0.7)))
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
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal, 28)
                    
                    Button(action: {
                        Task { await viewModel.signUp() }
                    }) {
                        HStack {
                            Text("COMPLETE REGISTRATION")
                                .font(.system(size: 14, weight: .semibold))
                                .tracking(1.5)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            (viewModel.fullname.isEmpty || viewModel.otp.isEmpty || viewModel.password.isEmpty)
                            ? Color(white: 0.9)
                            : Color(red: 0.08, green: 0.08, blue: 0.08)
                        )
                        .foregroundColor((viewModel.fullname.isEmpty || viewModel.otp.isEmpty || viewModel.password.isEmpty) ? Color(white: 0.6) : .white)
                        .cornerRadius(8)
                    }
                    .disabled(viewModel.fullname.isEmpty || viewModel.otp.isEmpty || viewModel.password.isEmpty)
                    .padding(.horizontal, 28)
                    .padding(.top, 8)
                    
                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
