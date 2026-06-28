//
//  Reservation.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import Foundation

struct Reservation: Codable, Identifiable {
    let id: Int
    let userId: Int
    let restaurantId: Int
    let time: String
    let day: String
    let preOrderList: [String: Int]
    let createdAt: String?
    let restaurantName: String
    let restaurantLocation: String
    let restaurantPhotos: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case restaurantId
        case time
        case day
        case preOrderList
        case createdAt = "created_at"
        case restaurantName
        case restaurantLocation
        case restaurantPhotos
    }
}
