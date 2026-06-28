//
//  AuthResponse.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import Foundation

struct CheckEmailResponse: Codable {
    let exists: Bool
    let message: String?
}

struct LoginResponse: Codable {
    let success: Bool
    let token: String?
    let user: User?
}
