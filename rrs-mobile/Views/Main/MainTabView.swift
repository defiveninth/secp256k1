//
//  MainTabView.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        TabView {
            NavigationStack {
                RestaurantListView()
            }
            .tabItem {
                Label("Explore", systemImage: "fork.knife")
            }

            NavigationStack {
                ReservationHistoryView()
            }
            .tabItem {
                Label("History", systemImage: "clock.fill")
            }
            
            NavigationStack {
                List {
                    Section(header: Text("Account Preferences")) {
                        Text("Manage Profile Settings")
                        Text("Notification Rules")
                    }
                    Section {
                        Button("Log Out", role: .destructive) {
                            UserDefaults.standard.removeObject(forKey: "authToken")
                            dismiss()
                        }
                    }
                }
                .navigationTitle("Profile")
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
        .accentColor(.black)
    }
}
