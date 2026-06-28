//
//  NetworkManager.swift
//  rrs-mobile
//
//  Created by Abdurrauf on 28.06.2026.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    let baseURL = "http://192.168.0.6:3000"
    
    private init() {}
}
