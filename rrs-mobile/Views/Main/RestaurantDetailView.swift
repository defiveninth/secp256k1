//
//  RestaurantDetailView.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import SwiftUI

struct RestaurantDetailView: View {
    let restaurantId: Int
    @StateObject private var vm = RestaurantViewModel()
    
    var body: some View {
        ScrollView {
            if let restaurant = vm.selectedRestaurant {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 1. Dynamic Photo Carousel
                    if let photos = restaurant.photos, !photos.isEmpty {
                        TabView {
                            ForEach(photos) { photo in
                                AsyncImage(url: URL(string: photo.photoUrl)) { img in
                                    img
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(height: 240)
                                .clipped()
                            }
                        }
                        .frame(height: 240)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    }
                    
                    // 2. Info Detail Meta Headers
                    VStack(alignment: .leading, spacing: 8) {
                        Text(restaurant.name)
                            .font(.largeTitle)
                            .bold()
                        
                        Text("📍 \(restaurant.location)")
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text(restaurant.isAlwaysOpen ? "🟢 Open 24/7" : "🕒 Operating Hours: \(restaurant.openTime ?? "") - \(restaurant.closeTime ?? "")")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Divider().padding(.horizontal)
                    
                    // 3. Menu Iteration
                    Text("Menu Items")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    if let menuItems = restaurant.menu, !menuItems.isEmpty {
                        ForEach(menuItems) { item in
                            HStack(alignment: .top, spacing: 14) {
                                if let photoStr = item.photoUrl, let url = URL(string: photoStr) {
                                    AsyncImage(url: url) { img in
                                        img
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Rectangle().fill(Color.gray.opacity(0.1))
                                    }
                                    .frame(width: 75, height: 75)
                                    .cornerRadius(12)
                                    .clipped()
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(item.name).font(.headline)
                                        Spacer()
                                        Text(String(format: "$%.2f", item.price))
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(.orange)
                                    }
                                    
                                    if let desc = item.description {
                                        Text(desc)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .lineLimit(2)
                                    }
                                    
                                    Text(item.category.uppercased())
                                        .font(.system(size: 9, weight: .bold))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.orange.opacity(0.15))
                                        .foregroundColor(.orange)
                                        .cornerRadius(4)
                                        .padding(.top, 2)
                                }
                            }
                            .padding(.horizontal)
                            Divider().padding(.horizontal)
                        }
                    } else {
                        Text("No items populated under this location menu record yet.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                }
            } else {
                VStack {
                    Spacer(minLength: 100)
                    ProgressView("Pulling specific item details...")
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.fetchRestaurantDetails(id: restaurantId)
        }
    }
}
