//
//  rrs_mobileApp.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 23.06.2026.
//

import SwiftUI

@main
struct rrs_mobileApp: App {
    @State private var authManager = AuthManager()
    
    var body: some Scene {
        WindowGroup {
            PrivateView()
                .environment(authManager)
        }
    }
}

@Observable
class AuthManager {
    var isAuthenticated: Bool = false
    var token: String? = nil
    var showLoginSheet: Bool = false
    
    var currentStep: AuthStep = .enterEmail
    var checkedEmail: String = ""
    
    init() {
        if let savedToken = UserDefaults.standard.string(forKey: "authtoken") {
            self.token = savedToken
            self.isAuthenticated = true
        }
    }
    
    func checkEmailStatus(_ email: String) async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        self.checkedEmail = email

        if email.lowercased().contains("new") {
            self.currentStep = .createAccount
        } else {
            self.currentStep = .verifyPassword
        }
    }

    func login(password: String) {
        let mockToken = "mocked_jwt_token_for_\(checkedEmail)"
        UserDefaults.standard.set(mockToken, forKey: "authtoken")
        self.token = mockToken
        self.isAuthenticated = true
        resetFlow()
    }
    
    func registerUser(fullName: String, password: String, otp: String) {
        let mockToken = "mocked_new_user_token"
        UserDefaults.standard.set(mockToken, forKey: "authtoken")
        self.token = mockToken
        self.isAuthenticated = true
        resetFlow()
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authtoken")
        self.token = nil
        self.isAuthenticated = false
    }
    
    func resetFlow() {
        self.currentStep = .enterEmail
        self.checkedEmail = ""
        self.showLoginSheet = false
    }
}
