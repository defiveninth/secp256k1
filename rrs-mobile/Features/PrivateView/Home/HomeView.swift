//
//  HomeView.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 23.06.2026.
//
import SwiftUI

struct HomeView: View {
    @Environment(AuthManager.self) private var authManager
    @State private var isLoading: Bool = false
    @State private var restaurants: [Restaurant] = []
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading delicious places...")
                } else {
                    List (restaurants) { restaurant in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(restaurant.name)
                                    .font(.headline)
                                Text("\(restaurant.cuisine) • \(restaurant.location)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            
                            Button(action: {
                                bookTable(for: restaurant)
                            }) {
                                Text(authManager.isAuthenticated ? "Book Table" : "Login to Book")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(authManager.isAuthenticated ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundStyle(authManager.isAuthenticated ? .white : .secondary)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Restaurants")
            .task {
                await fetchRestaurants()
            }
            .sheet(isPresented: Bindable(authManager).showLoginSheet) {
                LoginMockView()
            }
        }
    }
    
    func fetchRestaurants() async {
        guard let url = URL(string: "http://192.168.0.2:3000/api/restaurants") else { return }
        isLoading = true
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decoded = try? JSONDecoder().decode([Restaurant].self, from: data) {
                self.restaurants = decoded
            }
        } catch {
            print("Error fetching restaurants: \(error)")
        }
        isLoading = false
    }
    
    func bookTable(for restaurant: Restaurant) {
        if !authManager.isAuthenticated {
            authManager.showLoginSheet = true
        } else {
            print("Booking requested for \(restaurant.name)!")
        }
    }
}
