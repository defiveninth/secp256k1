//
//  Models.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 23.06.2026.
//

import Foundation

struct Restaurant: Identifiable, Codable {
    let id: Int
    let name: String
    let cuisine: String
    let location: String
}

struct Reservation: Identifiable, Codable {
    let id: Int
    let restaurantId: Int
    let date: String
    let time: String
    let guests: Int
}


