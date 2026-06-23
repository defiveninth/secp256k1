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
    
    init() {
        if let savedToken = UserDefaults.standard.string(forKey: "authtoken") {
            self.token = savedToken
            self.isAuthenticated = true
        }
    }
    
    func login(token: String) {
        UserDefaults.standard.set(token, forKey: "authtoken")
        self.token = token
        self.isAuthenticated = true
        self.showLoginSheet = false
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authtoken")
        self.token = nil
        self.isAuthenticated = false
    }
}
