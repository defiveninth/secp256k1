//
//  User.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import Foundation
typealias Cdbl = Encodable & Decodable
struct User: Cdbl, Identifiable {
    let id: Int
    let email: String
    let fullname: String?
}
