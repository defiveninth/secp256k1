import SwiftUI
import CoreImage

struct ReservationHistoryView: View {
    @StateObject private var vm = ReservationViewModel()
    @State private var selectedReservationForQR: Reservation? = nil
    
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
                                        
                                        Image(systemName: "qrcode")
                                            .font(.system(size: 24))
                                            .foregroundColor(.black)
                                            .padding(6)
                                            .background(Color(white: 0.96))
                                            .cornerRadius(6)
                                    }
                                    
                                    if !reservation.preOrderList.isEmpty {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("PRE-ORDERED ITEMS")
                                                .font(.system(size: 8, weight: .bold))
                                                .foregroundColor(.secondary)
                                                .tracking(1.0)
                                            
                                            Text(reservation.preOrderList.map { String(format: NSLocalizedString("Dish #%@ (x%d)", comment: ""), $0.key, $0.value) }.joined(separator: ", "))
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
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedReservationForQR = reservation
                                }
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
        .sheet(item: $selectedReservationForQR) { reservation in
            ReservationQRView(reservation: reservation)
        }
    }
}

struct ReservationQRView: View {
    let reservation: Reservation
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 36) {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .padding(8)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                VStack(spacing: 8) {
                    Text(reservation.restaurantName)
                        .font(.system(size: 28, weight: .light, design: .serif))
                        .foregroundColor(Color(red: 0.08, green: 0.08, blue: 0.08))
                    
                    Text("RESERVATION PASS")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(2.0)
                }
                
                if let qrImage = generateQRCode(from: String(reservation.id)) {
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 220, height: 220)
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(white: 0.91), lineWidth: 1)
                        )
                } else {
                    Rectangle()
                        .fill(Color(white: 0.97))
                        .frame(width: 220, height: 220)
                        .overlay(Text("Generating QR...").font(.caption))
                }
                
                VStack(spacing: 12) {
                    HStack(spacing: 40) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("DATE")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.secondary)
                                .tracking(1.0)
                            Text(reservation.day)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("TIME")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.secondary)
                                .tracking(1.0)
                            Text(reservation.time)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
                        }
                    }
                    
                    Text("Show this code to the receptionist at check-in.")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.secondary)
                        .alignmentGuide(.leading) { _ in 0 }
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                }
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Text("DONE")
                        .font(.system(size: 14, weight: .semibold))
                        .tracking(1.5)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.black)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 24)
            }
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .ascii)
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter.outputImage else { return nil }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciImage.transformed(by: transform)
        
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledCIImage, from: scaledCIImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
