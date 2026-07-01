import SwiftUI

struct CheckEmailView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 40) {
                        Spacer(minLength: 30)
                        
                        VStack(spacing: 20) {
                            Image(systemName: "fork.knife")
                                .font(.system(size: 36, weight: .light))
                                .foregroundColor(Color(red: 0.12, green: 0.12, blue: 0.12))
                                .padding(24)
                                .background(Color(white: 0.97))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color(white: 0.9), lineWidth: 1)
                                )
                            
                            VStack(spacing: 8) {
                                Text("BookTable")
                                    .font(.system(size: 32, weight: .light, design: .serif))
                                    .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                                    .tracking(0.5)
                                
                                Text("RESERVE YOUR TABLE INSTANTLY")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .tracking(2.0)
                            }
                        }
                        .padding(.top, 20)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("EMAIL ADDRESS")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    .tracking(1.5)
                                
                                HStack(spacing: 12) {
                                    Image(systemName: "envelope")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                                        .frame(width: 20)
                                    
                                    TextField("", text: $viewModel.email, prompt: Text("name@example.com").foregroundColor(Color(white: 0.7)))
                                        .font(.system(size: 15))
                                        .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
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
                            
                            if let error = viewModel.errorMessage {
                                HStack(spacing: 6) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                    Text(LocalizedStringKey(error))
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                .padding(.horizontal, 4)
                             }
                        }
                        .padding(.horizontal, 28)
                        
                        Button(action: {
                            Task {
                                await viewModel.checkEmail()
                            }
                        }) {
                            HStack {
                                if viewModel.isChecking {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("CONTINUE")
                                        .font(.system(size: 14, weight: .semibold))
                                        .tracking(1.5)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                viewModel.email.isEmpty
                                ? Color(white: 0.9)
                                : Color(red: 0.08, green: 0.08, blue: 0.08)
                            )
                            .foregroundColor(viewModel.email.isEmpty ? Color(white: 0.6) : .white)
                            .cornerRadius(8)
                        }
                        .disabled(viewModel.email.isEmpty || viewModel.isChecking)
                        .padding(.horizontal, 28)
                        .padding(.top, 8)
                        
                        Spacer()
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.showSignIn) {
                SignInView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $viewModel.showSignUp) {
                SignUpView(viewModel: viewModel)
            }
            .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
                MainTabView(isAuthenticated: $viewModel.isAuthenticated)
            }
        }
    }
}
