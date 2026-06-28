//
//  ReservationViewModel.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import Foundation
import Combine

@MainActor
class ReservationViewModel: ObservableObject {
    @Published var reservations: [Reservation] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isSuccess: Bool = false
    
    private let baseURL = NetworkManager.shared.baseURL
    
    func fetchReservations() async {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/reservations") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                self.reservations = try JSONDecoder().decode([Reservation].self, from: data)
            } else {
                self.errorMessage = "Failed to load reservations."
            }
            isLoading = false
        } catch {
            self.errorMessage = "Network error. Failed to load reservations."
            isLoading = false
        }
    }
    
    func createReservation(restaurantId: Int, time: String, day: String, preOrderList: [String: Int]) async -> Bool {
        isLoading = true
        errorMessage = nil
        isSuccess = false
        
        guard let url = URL(string: "\(baseURL)/reservations") else { return false }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let body: [String: Any] = [
            "restaurantId": restaurantId,
            "time": time,
            "day": day,
            "preOrderList": preOrderList
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            self.errorMessage = "Failed to serialize booking request."
            isLoading = false
            return false
        }
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    self.isSuccess = true
                    isLoading = false
                    return true
                } else {
                    if let errorObj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let errorMsg = errorObj["error"] as? String {
                        self.errorMessage = errorMsg
                    } else {
                        self.errorMessage = "Failed to complete reservation."
                    }
                }
            }
            isLoading = false
            return false
        } catch {
            self.errorMessage = "Network error. Failed to make reservation."
            isLoading = false
            return false
        }
    }
    
    func cancelReservation(id: Int) async {
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "\(baseURL)/reservations/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                self.reservations.removeAll { $0.id == id }
            } else {
                self.errorMessage = "Failed to cancel reservation."
            }
            isLoading = false
        } catch {
            self.errorMessage = "Network error. Failed to cancel reservation."
            isLoading = false
        }
    }
}
