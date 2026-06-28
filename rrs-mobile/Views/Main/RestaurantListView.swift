//
//  RestaurantListView.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import SwiftUI

struct RestaurantListView: View {
    @StateObject private var vm = RestaurantViewModel()
    
    var body: some View {
        Group {
            if vm.isLoading && vm.restaurants.isEmpty {
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Fetching local spots...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            } else if let error = vm.errorMessage {
                VStack(spacing: 16) {
                    Text("⚠️").font(.system(size: 40))
                    Text(error)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                    Button("Retry Initialization") {
                        Task { await vm.fetchRestaurants() }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else {
                List(vm.restaurants) { restaurant in
                    NavigationLink(destination: RestaurantDetailView(restaurantId: restaurant.id)) {
                        HStack(spacing: 16) {
                            if let firstPhoto = restaurant.photos?.first?.photoUrl, let url = URL(string: firstPhoto) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Rectangle().fill(Color.gray.opacity(0.2))
                                }
                                .frame(width: 80, height: 80)
                                .cornerRadius(10)
                                .clipped()
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(restaurant.name)
                                    .font(.headline)
                                
                                Text(restaurant.location)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(restaurant.isAlwaysOpen
                                     ? "Open 24/7"
                                     : "🕒 \(restaurant.openTime ?? "") - \(restaurant.closeTime ?? "")"
                                )
                                .font(.caption)
                                .bold()
                                .foregroundColor(restaurant.isAlwaysOpen ? .green : .blue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .refreshable {
                    await vm.fetchRestaurants()
                }
            }
        }
        .navigationTitle("Discover Spots")
        .task {
            await vm.fetchRestaurants()
        }
    }
}
