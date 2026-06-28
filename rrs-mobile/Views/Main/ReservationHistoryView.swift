//
//  ReservationHistoryView.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import SwiftUI

struct ReservationHistoryView: View {
    @StateObject private var vm = ReservationViewModel()
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            Group {
                if vm.isLoading && vm.reservations.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        Text("Loading your bookings...")
                            .font(.system(size: 13, weight: .light))
                            .foregroundColor(.secondary)
                    }
                } else if vm.reservations.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 40, weight: .light))
                            .foregroundColor(Color(white: 0.7))
                        Text("No Bookings")
                            .font(.system(size: 18, weight: .medium, design: .serif))
                            .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                        Text("Your table reservation history will appear here.")
                            .font(.system(size: 13, weight: .light))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(vm.reservations) { reservation in
                                VStack(alignment: .leading, spacing: 14) {
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(reservation.restaurantName)
                                                .font(.system(size: 18, weight: .light, design: .serif))
                                                .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                                            
                                            Text(reservation.restaurantLocation.uppercased())
                                                .font(.system(size: 9, weight: .medium))
                                                .foregroundColor(.secondary)
                                                .tracking(1.5)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            Task {
                                                await vm.cancelReservation(id: reservation.id)
                                            }
                                        }) {
                                            Text("CANCEL")
                                                .font(.system(size: 10, weight: .semibold))
                                                .tracking(1.0)
                                                .foregroundColor(.red)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 6)
                                                .background(Color.red.opacity(0.08))
                                                .cornerRadius(4)
                                        }
                                    }
                                    
                                    Divider()
                                    
                                    HStack(spacing: 24) {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("DATE")
                                                .font(.system(size: 8, weight: .bold))
                                                .foregroundColor(.secondary)
                                                .tracking(1.0)
                                            Text(reservation.day)
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("TIME")
                                                .font(.system(size: 8, weight: .bold))
                                                .foregroundColor(.secondary)
                                                .tracking(1.0)
                                            Text(reservation.time)
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                                        }
                                        
                                        Spacer()
                                    }
                                    
                                    if !reservation.preOrderList.isEmpty {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("PRE-ORDERED ITEMS")
                                                .font(.system(size: 8, weight: .bold))
                                                .foregroundColor(.secondary)
                                                .tracking(1.0)
                                            
                                            Text(reservation.preOrderList.map { "Dish #\($0.key) (x\($0.value))" }.joined(separator: ", "))
                                                .font(.system(size: 12, weight: .light))
                                                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                                        }
                                        .padding(.top, 4)
                                    }
                                }
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(white: 0.91), lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    .refreshable {
                        await vm.fetchReservations()
                    }
                }
            }
        }
        .navigationTitle("History")
        .task {
            await vm.fetchReservations()
        }
    }
}
