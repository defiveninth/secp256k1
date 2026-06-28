//
//  BookTable.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import SwiftUI

@main
struct BookTableApp: App {
    @State private var isLoggedIn: Bool = UserDefaults.standard.string(forKey: "authToken") != nil
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainTabView()
            } else {
                CheckEmailView()
            }
        }
    }
}
