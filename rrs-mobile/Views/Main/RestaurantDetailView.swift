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
    @State private var showBookingSheet: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white
                .ignoresSafeArea()
            
            ScrollView {
                if let restaurant = vm.selectedRestaurant {
                    VStack(alignment: .leading, spacing: 24) {
                        if let photos = restaurant.photos, !photos.isEmpty {
                            TabView {
                                ForEach(photos) { photo in
                                    AsyncImage(url: URL(string: photo.photoUrl)) { img in
                                        img
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    }
                                    .frame(height: 240)
                                    .clipped()
                                }
                            }
                            .frame(height: 240)
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(restaurant.name)
                                .font(.system(size: 30, weight: .light, design: .serif))
                                .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                            
                            Text(restaurant.location.uppercased())
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.secondary)
                                .tracking(1.5)
                            
                            HStack {
                                Text(restaurant.isAlwaysOpen
                                     ? "OPEN 24/7"
                                     : "🕒 OPERATING HOURS: \(restaurant.openTime ?? "") - \(restaurant.closeTime ?? "")"
                                )
                                .font(.system(size: 10, weight: .bold))
                                .tracking(1.0)
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                Spacer()
                            }
                            .padding()
                            .background(Color(white: 0.97))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(white: 0.9), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 20)
                        
                        Divider()
                            .padding(.horizontal, 20)
                        
                        Text("Menu")
                            .font(.system(size: 20, weight: .light, design: .serif))
                            .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                            .padding(.horizontal, 20)
                        
                        if let menuItems = restaurant.menu, !menuItems.isEmpty {
                            VStack(spacing: 16) {
                                ForEach(menuItems) { item in
                                    HStack(alignment: .top, spacing: 14) {
                                        if let photoStr = item.photoUrl, let url = URL(string: photoStr) {
                                            AsyncImage(url: url) { img in
                                                img
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            } placeholder: {
                                                Rectangle().fill(Color(white: 0.97))
                                            }
                                            .frame(width: 75, height: 75)
                                            .cornerRadius(6)
                                            .clipped()
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text(item.name)
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                                                Spacer()
                                                Text(String(format: "$%.2f", item.price))
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                                            }
                                            
                                            if let desc = item.description {
                                                Text(desc)
                                                    .font(.system(size: 12, weight: .light))
                                                    .foregroundColor(.secondary)
                                                    .lineLimit(2)
                                            }
                                            
                                            Text(item.category.uppercased())
                                                .font(.system(size: 8, weight: .bold))
                                                .tracking(1.0)
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color(white: 0.94))
                                                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                                                .cornerRadius(4)
                                                .padding(.top, 2)
                                        }
                                    }
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(white: 0.91), lineWidth: 1)
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        } else {
                            Text("No items listed under this location yet.")
                                .font(.system(size: 13, weight: .light))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 20)
                        }
                        
                        Spacer(minLength: 100)
                    }
                } else {
                    VStack {
                        Spacer(minLength: 120)
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            if let restaurant = vm.selectedRestaurant {
                VStack(spacing: 0) {
                    Divider()
                    HStack {
                        Button(action: {
                            showBookingSheet = true
                        }) {
                            Text("BOOK A TABLE")
                                .font(.system(size: 14, weight: .semibold))
                                .tracking(1.5)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.black)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.white)
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await vm.fetchRestaurantDetails(id: restaurantId)
        }
        .sheet(isPresented: $showBookingSheet) {
            if let restaurant = vm.selectedRestaurant {
                BookTableView(restaurant: restaurant)
            }
        }
    }
}
