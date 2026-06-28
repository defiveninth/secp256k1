//
//  MainTabView.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                RestaurantListView()
            }
            .tabItem {
                Label("Explore", systemImage: "fork.knife")
            }

            NavigationStack {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("Reservation Bookings History")
                        .font(.headline)
                    Text("Your explicit table choices live here.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .navigationTitle("History")
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

                        }
                    }
                }
                .navigationTitle("Profile")
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle")
            }
        }
    }
}
