//
//  BookTableView.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import SwiftUI

struct BookTableView: View {
    let restaurant: Restaurant
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = ReservationViewModel()
    
    @State private var selectedDate = Date()
    @State private var selectedTime: String = ""
    @State private var preOrderList: [String: Int] = [:]
    @State private var showSuccessAlert = false
    
    private let timeSlots = [
        "11:00", "11:30", "12:00", "12:30",
        "13:00", "13:30", "14:00", "14:30",
        "17:00", "17:30", "18:00", "18:30",
        "19:00", "19:30", "20:00", "20:30",
        "21:00", "21:30", "22:00"
    ]
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.white
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(restaurant.name)
                                .font(.system(size: 24, weight: .light, design: .serif))
                                .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                            
                            Text("BOOK A TABLE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.secondary)
                                .tracking(2.0)
                        }
                        .padding(.top, 16)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("SELECT DATE")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .tracking(1.5)
                            
                            DatePicker("", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .accentColor(.black)
                                .padding(8)
                                .background(Color(white: 0.98))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(white: 0.9), lineWidth: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("SELECT TIME SLOT")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                .tracking(1.5)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(timeSlots, id: \.self) { slot in
                                        Button(action: {
                                            selectedTime = slot
                                        }) {
                                            Text(slot)
                                                .font(.system(size: 13, weight: .medium))
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 10)
                                                .background(selectedTime == slot ? Color.black : Color(white: 0.98))
                                                .foregroundColor(selectedTime == slot ? .white : Color(red: 0.15, green: 0.15, blue: 0.15))
                                                .cornerRadius(6)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .stroke(selectedTime == slot ? Color.black : Color(white: 0.88), lineWidth: 1)
                                                )
                                        }
                                    }
                                }
                            }
                        }
                        
                        if let menuItems = restaurant.menu, !menuItems.isEmpty {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("PRE-ORDER DISHES (OPTIONAL)")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                                    .tracking(1.5)
                                
                                VStack(spacing: 12) {
                                    ForEach(menuItems) { item in
                                        let itemIdStr = String(item.id)
                                        let count = preOrderList[itemIdStr] ?? 0
                                        
                                        HStack {
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(item.name)
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                                                Text(String(format: "$%.2f", item.price))
                                                    .font(.system(size: 12))
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            Spacer()
                                            
                                            HStack(spacing: 16) {
                                                Button(action: {
                                                    if count > 0 {
                                                        preOrderList[itemIdStr] = count - 1
                                                        if count - 1 == 0 {
                                                            preOrderList.removeValue(forKey: itemIdStr)
                                                        }
                                                    }
                                                }) {
                                                    Image(systemName: "minus.circle")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(count > 0 ? .black : Color(white: 0.7))
                                                }
                                                .disabled(count == 0)
                                                
                                                Text("\(count)")
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                                                    .frame(width: 20)
                                                
                                                Button(action: {
                                                    preOrderList[itemIdStr] = count + 1
                                                }) {
                                                    Image(systemName: "plus.circle")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(.black)
                                                }
                                            }
                                        }
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color(white: 0.91), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                        }
                        
                        if let error = vm.errorMessage {
                            HStack(spacing: 6) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .padding(.horizontal, 4)
                        }
                        
                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 24)
                }
                
                VStack(spacing: 0) {
                    Divider()
                    HStack {
                        Button(action: {
                            Task {
                                let success = await vm.createReservation(
                                    restaurantId: restaurant.id,
                                    time: selectedTime,
                                    day: formattedDate,
                                    preOrderList: preOrderList
                                )
                                if success {
                                    showSuccessAlert = true
                                }
                            }
                        }) {
                            HStack {
                                if vm.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("CONFIRM BOOKING")
                                        .font(.system(size: 14, weight: .semibold))
                                        .tracking(1.5)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(selectedTime.isEmpty || vm.isLoading ? Color(white: 0.9) : Color.black)
                            .cornerRadius(8)
                        }
                        .disabled(selectedTime.isEmpty || vm.isLoading)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color.white)
                }
            }
            .navigationTitle("Reservation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.black)
                }
            }
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your reservation at \(restaurant.name) has been booked successfully.")
            }
        }
    }
}
