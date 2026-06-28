//
//  AuthViewModel.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var otp: String = ""
    @Published var password: String = ""
    @Published var fullname: String = ""
    
    @Published var isChecking: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published var showSignIn: Bool = false
    @Published var showSignUp: Bool = false
    @Published var isAuthenticated: Bool = false
    
    private let networkManager = NetworkManager.shared
    
    func checkEmail() async {
        guard !email.isEmpty else { return }
        isChecking = true
        errorMessage = nil
        
        guard let url = URL(string: "\(networkManager.baseURL)/auth/check") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email]
        request.httpBody = try? JSONEncoder().encode(body)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(CheckEmailResponse.self, from: data)
        
            isChecking = false
            if response.exists {
                showSignIn = true
            } else {
                showSignUp = true
            }
        } catch {
            isChecking = false
            errorMessage = "Server down. Verify your node instance is listening on Port 3000."
        }
    }
    
    func signIn() async {
        errorMessage = nil
        
        guard let url = URL(string: "\(networkManager.baseURL)/auth/sign-in") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email, "password": password]
        request.httpBody = try? JSONEncoder().encode(body)
        
        await handleAuthNetworkCall(with: request)
    }
    
    func signUp() async {
        errorMessage = nil
        
        guard let url = URL(string: "\(networkManager.baseURL)/auth/sign-up") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "email": email,
            "password": password,
            "otp": otp,
            "fullname": fullname
        ]
        request.httpBody = try? JSONEncoder().encode(body)
        
        await handleAuthNetworkCall(with: request)
    }
    
    func handleAuthNetworkCall(with request: URLRequest) async {
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let result = try JSONDecoder().decode(LoginResponse.self, from: data)
                
            if result.success, let sessionToken = result.token {
            // Local key storage persistence wrapper
                UserDefaults.standard.set(sessionToken, forKey: "authToken")
                self.isAuthenticated = true
            } else {
                self.errorMessage = "Failed validation checks. Check inputs."
            }
        } catch {
            self.errorMessage = "Request failure. Verify schema structure details syntax."
        }
    }
}
